--
-- Funcion encargada de realizar toda la facturacion del sistema
--
CREATE OR REPLACE FUNCTION FA_FACTURACION   (  
                                                p_tius          INT,
                                                p_clien         INT,
                                                p_idTrans       INT,
                                                p_sede          INT,
                                                p_tipoPago      varchar,
                                                p_idVoucher     NUMERIC(15,6),
                                                p_valrTarjeta   NUMERIC(15,6)
                                            ) RETURNS VARCHAR  AS $$
    DECLARE
    --
    --Logica para validaciones previas a la facturacion
    --
    --
    --Cursor el cual valida si la subcuenta para el iva generado existe
    --
    c_val_caja_menor CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '110501'
      ;
    --
    --Cursor el cual valida si la subcuenta para el iva generado existe
    --
    c_val_iva_generado CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '240802'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para el costo por ventas
    --
    c_costo_ventas CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '613535'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para la Mercancia al por mayor y menor
    --
    c_mercancia_mm CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '413535'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para los descuentos
    --
    c_descuentos CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '530535'
      ;
    --
    v_vlr_total_fact_co     NUMERIC(15,6) := 0;
    --
    --Variables utilizadas para los valores principales de facturacion
    --
    v_vlr_total     NUMERIC  :=0;
    v_vlr_iva       NUMERIC  :=0;
    --
    --Variables necesarias para la validacion de subcuentas
    --
    v_val_iva_generado          int :=0;
    v_val_costo_ventas          int :=0;
    v_val_mercancias_mm         int :=0;
    v_val_descuentos            int :=0;
    v_val_caja_menor            int :=0;
    --
    v_fact_fact     NUMERIC  :=0;
    --
    --Cursor utilizado para generar el id de la factura
    --    
    c_fact_fact CURSOR FOR
    SELECT coalesce(max(fact_fact),0) + 1
      from fa_tfact     
    ;
    --
    --Cursor el cual obtiene todos los productos que fueron facturados teniendo en cuenta el id de transaccion
    --
    c_prod_fact CURSOR FOR
    SELECT tem_fact_dska, tem_fact_cant,tem_fact_dcto 
      FROM co_ttem_fact
     WHERE tem_fact_trans = p_idTrans
     ;
    --
    --Cursro el cual obtiene todas las recetas que fueron facturados teniendo en cuenta el id de transaccion
    --
    c_rece_fact CURSOR FOR
    SELECT tem_fact_rece, tem_rece_cant, tem_rece_dcto, tem_rece_rece
      FROM co_ttem_fact_rece
     WHERE tem_rece_trans = p_idTrans
    ;
    --
    --Variable con la cual utilizo para almacenar la respuesta de 
    --
    v_rta_fact_prod             varchar(500):= '';
    v_rta_fact_rece             varchar(500):= '';    
    --
    --Cursor el cual sirve para obtener el id temporal de transaccion para la tabla temporal
    --de movimientos contables
    --
    c_sec_tem_mvco CURSOR FOR
    SELECT nextval('co_temp_movi_contables') 
    ;
    --
    --Cursores necesarios para la contabilizacion
    --
    c_sum_debitos CURSOR(vc_temIdTrans INT) IS
    SELECT sum(coalesce(cast(tem_mvco_valor as numeric),0) )
      FROM co_ttem_mvco
     WHERE upper(tem_mvco_naturaleza) = 'D'
       AND tem_mvco_trans = vc_temIdTrans
       ;
    --
    c_sum_creditos CURSOR(vc_temIdTrans INT) IS
    SELECT sum(coalesce(cast(tem_mvco_valor as numeric),0) )
      FROM co_ttem_mvco
     WHERE tem_mvco_naturaleza = 'C'
       AND tem_mvco_trans = vc_temIdTrans
       ;
    --
    v_sum_deb               NUMERIC(15,6):=0;
    v_sum_cre               NUMERIC(15,6):=0;
    v_sbcu_sbcu             INT := 0;
    --
    --Obtiene el id de una subcuenta basandose en el codigo de la misma
    --
    c_sbcu_sbcu CURSOR(vc_sbcu_codigo VARCHAR) IS
    SELECT sbcu_sbcu
      FROM co_tsbcu
     WHERE sbcu_codigo = vc_sbcu_codigo
     ;
    --
    c_sbcu_factura  CURSOR(vc_temIdTrans INT) IS
    SELECT tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza
      FROM co_ttem_mvco
     WHERE tem_mvco_trans = vc_temIdTrans
     ;
    --
    --Cursor con el cual obtengo el valor total de los productos de la factura
    --
    c_vlr_total_fact CURSOR(vc_fact_fact INT) FOR
    SELECT fact_vlr_total + fact_vlr_iva
      FROM fa_tfact
     WHERE fact_fact = vc_fact_fact
     ;
    --
    --Cursor con el cual obtenemos el valor total del iva de la factura
    --
    c_vlr_iva_fact CURSOR(vc_fact_fact INT) FOR
    SELECT fact_vlr_iva
      FROM fa_tfact
     WHERE fact_fact = vc_fact_fact
     ;
    --
    --Cursor con el cual obtnemos el valor de la factura sin iva
    --
    c_vlr_total_fact_sin_iva CURSOR(vc_fact_fact INT) FOR
    SELECT fact_vlr_total 
      FROM fa_tfact
     WHERE fact_fact = vc_fact_fact
     ;
    --
    v_valor_iva_fact        NUMERIC(15,6) := 0;
    v_vlr_total_factura     NUMERIC(15,6) := 0;
    v_idTrans_con           INT := 0;
    --
    BEGIN
    --
    --Inicio de Validacion de Subcuentas Contables necesarias para la contabilizacion
    --
    --
    OPEN c_val_iva_generado;
    FETCH c_val_iva_generado INTO v_val_iva_generado;
    CLOSE c_val_iva_generado;
    --
    OPEN c_costo_ventas;
    FETCH c_costo_ventas INTO v_val_costo_ventas;
    CLOSE c_costo_ventas;
    --
    OPEN c_mercancia_mm;
    FETCH c_mercancia_mm INTO v_val_mercancias_mm;
    CLOSE c_mercancia_mm;
    --
    OPEN c_descuentos;
    FETCH c_descuentos INTO v_val_descuentos;
    CLOSE c_descuentos;
    --
    OPEN c_val_caja_menor;
    FETCH c_val_caja_menor INTO v_val_caja_menor;
    CLOSE c_val_caja_menor;
    --
    IF v_val_iva_generado <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de iva generado 240802 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_costo_ventas <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de costo de ventas 613535 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_mercancias_mm <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de mercancias al por menor y mayor 413535 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_descuentos <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de descuentos por ventas 530535 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_caja_menor <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de caja menor 110501 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    OPEN c_fact_fact;
    FETCH c_fact_fact INTO v_fact_fact;
    CLOSE c_fact_fact;
    --
    IF upper(p_tipoPago) = 'T' THEN
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_tipo_pago, fact_id_voucher, fact_sede)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva,    'T',            p_idVoucher,p_sede)
                    ;
        --
    ELSIF upper(p_tipoPago) = 'M' THEN
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_tipo_pago, fact_id_voucher, fact_sede)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva,    'M',            p_idVoucher)
                    ;
        --
    ELSE
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_sede)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva, p_sede)
        ;
        --
    END IF;
    --
    --Cursor con el cual obtengo el id de movimientos contables
    --
    OPEN c_sec_tem_mvco;
    FETCH c_sec_tem_mvco INTO v_idTrans_con;
    CLOSE c_sec_tem_mvco;
    --
    --For con el cual recorro todos los productos vendidos en la factura
    --
    FOR prod IN c_prod_fact
    LOOP
        --
        v_rta_fact_prod := FA_FACTURA_PRODUCTO(
                                                p_tius,
                                                prod.tem_fact_dska,
                                                p_sede,
                                                prod.tem_fact_cant,
                                                v_idTrans_con,
                                                cast(v_fact_fact as int)
                                                );
        --
        IF UPPER(v_rta_fact_prod) <> 'OK' THEN 
        --
            RAISE EXCEPTION 'Error al facturar el producto con el id % con el siguiente error % ',prod.tem_fact_dska, v_rta_fact_prod;
        --
        END IF;
        --
    END LOOP;
    --
    FOR receta IN c_rece_fact 
    LOOP
        --
        v_rta_fact_rece := FA_FACTURA_RECETA(
                                            p_tius,
                                            receta.tem_rece_rece,
                                            p_sede,
                                            receta.tem_rece_cant,
                                            v_idTrans_con,
                                            cast(v_fact_fact as int)                                            
                                            );
        --
        IF UPPER(v_rta_fact_rece) <> 'OK' THEN 
        --
            RAISE EXCEPTION 'Error al facturar la receta o plato con el id % con el siguiente error % ',receta.tem_fact_rece, v_rta_fact_rece;
        --
        END IF;
        --
    END LOOP;
    --
    DELETE FROM co_ttem_fact
    WHERE tem_fact_trans = p_idTrans
    ;
    --
    OPEN c_vlr_iva_fact(v_fact_fact);
    FETCH c_vlr_iva_fact INTO v_valor_iva_fact;  
    CLOSE c_vlr_iva_fact;
    --
    --Insercion para contabilizar el iva
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (v_idTrans_con, '240802' , v_valor_iva_fact , 'C');
    --
    --
    --
    OPEN c_vlr_total_fact_sin_iva(v_fact_fact);
    FETCH c_vlr_total_fact_sin_iva INTO v_vlr_total_factura;
    CLOSE c_vlr_total_fact_sin_iva;
    --
    --Insercion de Mercancias al por mayor y menor
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (v_idTrans_con, '413535' , v_vlr_total_factura , 'C');
    --
    --Insercion de descuentos para la factura
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (v_idTrans_con, '530535' , 0 , 'D');
    --
    --Obtengo el valor total de la factura
    --
    OPEN c_vlr_total_fact(v_fact_fact);
    FETCH c_vlr_total_fact INTO v_vlr_total_fact_co;
    CLOSE c_vlr_total_fact;
    --
    --Logica para que el dinero valla directo a la caja menor
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                     VALUES (v_idTrans_con, '110501' , v_vlr_total_fact_co , 'D');
    --
    UPDATE fa_tfact
    SET fact_vlr_efectivo = v_vlr_total_fact_co
    WHERE fact_fact = v_fact_fact
    ;
    --
    --
    OPEN c_sum_debitos(v_idTrans_con);
    FETCH c_sum_debitos INTO v_sum_deb;
    CLOSE c_sum_debitos;
    --
    OPEN c_sum_creditos(v_idTrans_con);
    FETCH c_sum_creditos INTO v_sum_cre;
    CLOSE c_sum_creditos;
    --
    IF v_sum_deb = v_sum_cre THEN
        --
        FOR movi IN c_sbcu_factura(v_idTrans_con) 
        LOOP
            --
            OPEN c_sbcu_sbcu(movi.tem_mvco_sbcu);
            FETCH c_sbcu_sbcu INTO v_sbcu_sbcu;
            CLOSE c_sbcu_sbcu;
            --
            INSERT INTO co_tmvco(mvco_trans, 
                                 mvco_sbcu, mvco_naturaleza, 
                                 mvco_tido, mvco_valor, 
                                 mvco_lladetalle, mvco_id_llave, 
                                 mvco_tercero, mvco_tipo)
                VALUES ( v_idTrans_con, 
                         v_sbcu_sbcu , movi.tem_mvco_naturaleza, 
                         2, cast(movi.tem_mvco_valor as NUMERIC),
                         'fact', v_fact_fact,
                         1, p_clien );
            
        END LOOP;
        --
    ELSE
        --
        RAISE EXCEPTION 'Las sumas de las cuentas al facturar no coinciden por favor contactese con el administrador Debitos %, Creditos %',v_sum_deb,v_sum_cre;
        --
    END IF;
    --
    DELETE FROM co_ttem_mvco
    WHERE tem_mvco_trans =  v_idTrans_con
    ;
    RETURN 'Ok-'||v_fact_fact;
    --    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_FACTURACION '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';