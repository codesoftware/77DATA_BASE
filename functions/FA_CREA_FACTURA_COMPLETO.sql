--
-- Funcion encargada de realizar toda la facturacion del sistema
--
CREATE OR REPLACE FUNCTION FA_CREA_FACTURA_COMPLETO (  
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
    --Variables necesarias para la validacion de subcuentas
    --
    v_val_iva_generado          int :=0;
    v_val_costo_ventas          int :=0;
    v_val_mercancias_mm         int :=0;
    v_val_descuentos            int :=0;
    --
    --Valida si el movimiento de inventario para facturacion esta parametrizado
    --
    c_valida_movi_fact CURSOR FOR
    SELECT count(*)
      FROM in_tmvin
     WHERE mvin_venta = 'S'
     ;
    --
    v_val_mvin_fact             int := 0;
    --
    --Moviento de inventario parametrizado para la venta de productos
    --
    c_mvin_venta CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_venta = 'S'
     ;
    --
    v_mvin_mvin             INT :=0;
    --
    --Cursor utilizado para generar el id de la factura
    --    
    c_fact_fact CURSOR FOR
    SELECT coalesce(max(fact_fact),0) + 1
      from fa_tfact     
    ;
    --Variables utilizadas para los valores principales de facturacion
    v_vlr_total     NUMERIC  :=0;
    v_vlr_iva       NUMERIC  :=0;
    --
    --Identificador primario de la tabla fa_tfact
    --
    v_fact_fact     NUMERIC  :=0;
    v_kapr_kapr     NUMERIC  :=0;
    --
    --Cursor el cual obtiene todos los productos que fueron facturados teniendo en cuenta el id de transaccion
    --
    c_prod_fact CURSOR FOR
    SELECT tem_fact_dska, tem_fact_cant,tem_fact_dcto 
      FROM co_ttem_fact
     WHERE tem_fact_trans = p_idTrans
     ;
    --Variable utilizada para almacenar la respuesta de la salida de inventario
    v_rta_insrt_kar         VARCHAR(500) := '';
    --
    --Cursor el cual sirve para obtener el id temporal de transaccion para la tabla temporal
    --de movimientos contables
    --
    c_sec_tem_mvco CURSOR FOR
    SELECT nextval('co_temp_movi_contables') 
    ;
    --
    --Cursor en el cual obtengo el valor parametrizado para el  producto en la sede en la cual fue comprado
    --
    c_precio_prod CURSOR(vc_dska_dska  INT)IS
    SELECT prpr_precio
      FROM in_tprpr
     WHERE prpr_estado = 'A'
       and prpr_dska = vc_dska_dska
       and prpr_sede = p_sede
       ;
    --
    --Cursor con el cual se calcula el valor del iva parametrizado
    --
    c_calc_iva CURSOR(vc_valor  NUMERIC)IS
    SELECT (cast(para_valor as numeric) *vc_valor) / 100 vlrIva
    FROM em_tpara where para_clave = 'IVAPR'
    ;
    --
    c_vlr_total_fact CURSOR(vc_fact_fact INT) FOR
    SELECT fact_vlr_total + fact_vlr_iva
      FROM fa_tfact
     WHERE fact_fact = vc_fact_fact
     ;
    --
    v_idTrans_con           INT:= 0;
    --
    --Variable para el precio del producto
    --
    v_precio_prod           NUMERIC(15,6):=0;
    v_dtpr_dtpr             NUMERIC;
    v_vlr_total_fact        NUMERIC(15,6):=0;
    v_vlr_uni_fact          NUMERIC(15,6):=0;
    v_vlr_uni_fact_iva      NUMERIC(15,6):=0;
    v_vlr_tot_fact_iva      NUMERIC(15,6):=0;
    v_vlr_iva_uni           NUMERIC(15,6):=0;
    v_vlr_iva_tot           NUMERIC(15,6):=0;
    --
    v_aplica_descuento      VARCHAR(2);
    --
    --Cursor con el cual obtengo el id de la tabla fa_tdtpr (Detalles de facturacion de productos)
    --
    c_dtpr_dtpr CURSOR FOR
    SELECT coalesce(max(dtpr_dtpr),0) + 1
      from fa_tdtpr
    ;
    --
    c_sbcu_factura  CURSOR(vc_temIdTrans INT) IS
    SELECT tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza
      FROM co_ttem_mvco
     WHERE tem_mvco_trans = vc_temIdTrans
     ;
    --
    c_sbcu_sbcu CURSOR(vc_sbcu_codigo VARCHAR) IS
    SELECT sbcu_sbcu
      FROM co_tsbcu
     WHERE sbcu_codigo = vc_sbcu_codigo
     ;  
    --
    --
    --Variables necesarias para la contabilizacion
    --
    v_iva_mvco              NUMERIC(15,6):=0;
    v_sum_deb               NUMERIC(15,6):=0;
    v_sum_cre               NUMERIC(15,6):=0;
    v_sbcu_sbcu             INT := 0;
    --
    --Obtiene el codico de la subcuenta para un producto
    --
    c_cod_sbcu CURSOR (vc_dska_dska  INT) IS
    SELECT sbcu_codigo
      FROM co_tsbcu, in_tdska
     WHERE dska_dska = vc_dska_dska
       AND sbcu_sbcu = dska_sbcu
     ;
    --
    --
    v_sbcu_cod_prod         varchar(100) := '';
    v_vlr_total_fact_co     NUMERIC(15,6) := 0;
    v_vlr_dscto_fact        NUMERIC(15,6) := 0;
    --
    --
    --Cursor con el cual obtengo el valor del promedio pornderado del producto
    --
    c_prom_pond_prod CURSOR(vc_dska_dska INT) IS
    SELECT kapr_cost_saldo_uni, kapr_cant_saldo,kapr_cost_saldo_tot
      FROM in_tkapr
     WHERE kapr_kapr = (select max(kapr_kapr) from in_tkapr where kapr_dska = vc_dska_dska)
    ;
    --
    v_vlr_prom_pond        NUMERIC(15,6) := 0;
    --
    v_vlr_total_factura     NUMERIC(15,6) := 0;
    --
    v_sbcu_cod_pgtj         varchar(10);
    --
    --
    --Cursor el cual encuentra la subcuenta parametrizada en 
    --el sistema para ingresar los pagos con tarjeta
    --
    c_cuenta_tarjeta CURSOR FOR 
    SELECT para_valor
      FROM em_tpara
     WHERE para_clave = 'SBCUTARJETA'
     ;
    --
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
    -- Cursor con el cual encuentro el id del movimiento de inventario
    --
    c_kapr_kapr CURSOR (vc_expresion varchar) IS
    SELECT cast(kapr_kapr as int)
      FROM (
           SELECT regexp_split_to_table(vc_expresion, '-') kapr_kapr
           offset 1) as tabla
    ;
    --
    v_valor_real_apagar         NUMERIC(15,6) := 0;
    v_valor_pago_efectivo       NUMERIC(15,6) := 0;
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
    --Validacion de existencia de movimientos de inventario referenciando facturacion
    --
    OPEN c_valida_movi_fact;
    FETCH c_valida_movi_fact INTO v_val_mvin_fact;
    CLOSE c_valida_movi_fact;
    --
    IF v_val_mvin_fact <> 1 THEN
        --
        RAISE EXCEPTION 'No existe ningun movimiento de inventario que referencie la facturacion de productos';
        --
    ELSE
    --
        OPEN c_mvin_venta;
        FETCH c_mvin_venta INTO v_mvin_mvin;
        CLOSE c_mvin_venta;
    --
    END IF;
    --
    IF v_mvin_mvin is null THEN
    --
        RAISE EXCEPTION 'No existe ningun movimiento de inventario que referencie la facturacion';
    --
    END IF;
    --
    --Inicio generacion de una Factura
    --
    OPEN c_fact_fact;
    FETCH c_fact_fact INTO v_fact_fact;
    CLOSE c_fact_fact;
    --
    IF upper(p_tipoPago) = 'T' THEN
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_tipo_pago, fact_id_voucher,fact_sede)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva,    'T',            p_idVoucher,p_sede)
                    ;
        --
    ELSIF upper(p_tipoPago) = 'M' THEN
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_tipo_pago, fact_id_voucher,fact_sede)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva,    'M',            p_idVoucher,p_sede)
                    ;
        --
    ELSE
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_sede)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva,p_sede)
        ;
        --
    END IF;
    --
    --Obtiene el valor de la secuencia para los movimientos contables
    --
    OPEN c_sec_tem_mvco;
    FETCH c_sec_tem_mvco INTO v_idTrans_con;
    CLOSE c_sec_tem_mvco;
    --
    FOR prod IN c_prod_fact
    LOOP
        --
        --Realizamos la salida del inventario del producto 
        --
        v_rta_insrt_kar := IN_FINSERTA_PROD_KARDEX(prod.tem_fact_dska,
                                                   v_mvin_mvin,
                                                   p_tius,
                                                   prod.tem_fact_dska,
                                                   0,
                                                   p_sede                                                   
                                                   );
        --
        IF upper(v_rta_insrt_kar) NOT LIKE '%OK%' THEN
            --
            RAISE EXCEPTION 'Error al hacer la salida de inventario. % ',v_rta_insrt_kar ;
            --
        ELSE
            --
            OPEN c_kapr_kapr(v_rta_insrt_kar);
            FETCH c_kapr_kapr INTO v_kapr_kapr;
            CLOSE c_kapr_kapr;
            --
        END IF;
        --
        --Obtiene el precio de venta del producto
        --
        OPEN c_precio_prod(prod.tem_fact_dska);
        FETCH c_precio_prod INTO v_precio_prod;
        CLOSE c_precio_prod;
        --
        --Cursor el cual obtiene el id para el ingreso de detalles de facturacion
        --
        OPEN c_dtpr_dtpr;
        FETCH c_dtpr_dtpr INTO v_dtpr_dtpr;
        CLOSE c_dtpr_dtpr;
        --
        IF prod.tem_fact_dcto = 0 THEN
        --
            v_aplica_descuento := 'N';
        --
        ELSE
        --
            v_aplica_descuento := 'S';
        --
        END IF;
        --
        --
        -- Ini Calculos para la facturacion
        --
        v_vlr_total_fact := prod.tem_fact_cant*v_precio_prod;
        v_vlr_uni_fact := v_precio_prod;
        --
        OPEN c_calc_iva(v_vlr_total_fact);
        FETCH c_calc_iva INTO v_vlr_iva_tot;
        CLOSE c_calc_iva;
        --
        v_vlr_tot_fact_iva := v_vlr_total_fact + v_vlr_iva_tot;
        --
        OPEN c_calc_iva(v_vlr_uni_fact);
        FETCH c_calc_iva INTO v_vlr_iva_uni;
        CLOSE c_calc_iva;
        --
        v_vlr_uni_fact_iva := v_vlr_uni_fact+v_vlr_iva_uni;
        --
        -- Fin Calculos para la facturacion
        --
        INSERT INTO fa_tdtpr(
            dtpr_dtpr, dtpr_dska, dtpr_fact, 
            dtpr_num_prod, dtpr_cant, dtpr_vlr_pr_tot, 
            dtpr_vlr_uni_prod, dtpr_vlr_iva_tot, dtpr_vlr_iva_uni, 
            dtpr_vlr_venta_tot, dtpr_vlr_venta_uni, dtpr_vlr_total, 
            dtpr_desc, dtpr_kapr,dtpr_valor_desc)
        VALUES (
            v_dtpr_dtpr, prod.tem_fact_dska, v_fact_fact, 
            0, prod.tem_fact_cant, v_vlr_total_fact, 
            v_vlr_uni_fact, v_vlr_iva_tot, v_vlr_iva_uni, 
            v_vlr_tot_fact_iva, v_vlr_uni_fact_iva, v_vlr_tot_fact_iva,
            v_aplica_descuento, v_kapr_kapr,prod.tem_fact_dcto);
        --
        --Suma de Iva
        --        
        v_iva_mvco := v_iva_mvco + v_vlr_iva_tot;
        --
        --Suma de valores de descuento
        --
        v_vlr_dscto_fact := v_vlr_dscto_fact + prod.tem_fact_dcto;
        --
        --Suma el valor total a pagar de cada producto
        --
        v_vlr_total_factura := v_vlr_total_factura + v_vlr_total_fact;
        --
        OPEN c_cod_sbcu(prod.tem_fact_dska);
        FETCH c_cod_sbcu INTO v_sbcu_cod_prod;
        CLOSE c_cod_sbcu;
        --
        --Obtengo el valor del promedio ponderado
        --
        OPEN c_prom_pond_prod(prod.tem_fact_dska);
        FETCH c_prom_pond_prod INTO v_vlr_prom_pond;
        CLOSE c_prom_pond_prod;
        --
        v_vlr_prom_pond := v_vlr_prom_pond * prod.tem_fact_cant;
        --
        --Insercion para que se contabilice la salida del producto
        --
        INSERT INTO co_ttem_mvco(
                tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
        VALUES (v_idTrans_con, v_sbcu_cod_prod , v_vlr_prom_pond , 'C');
        --
        --Insercion para la entrada de costo de ventas
        --
        INSERT INTO co_ttem_mvco(
                tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
        VALUES (v_idTrans_con, '613535' , v_vlr_prom_pond , 'D');
        --
    END LOOP;
    --
    DELETE FROM co_ttem_fact
    WHERE tem_fact_trans = p_idTrans
    ;
    --Insercion para contabilizar el iva
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (v_idTrans_con, '240802' , v_iva_mvco , 'C');
    --
    --Insercion para contabilizar Mercancias al por mayor y menor
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (v_idTrans_con, '413535' , v_vlr_total_factura , 'C');
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (v_idTrans_con, '530535' , v_vlr_dscto_fact , 'D');
    --
    OPEN c_vlr_total_fact(v_fact_fact);
    FETCH c_vlr_total_fact INTO v_vlr_total_fact_co;
    CLOSE c_vlr_total_fact;
    
    v_vlr_total_fact_co := v_vlr_total_fact_co - v_vlr_dscto_fact;
    
    IF upper(p_tipoPago) = 'T' THEN
        --
        OPEN c_cuenta_tarjeta;
        FETCH c_cuenta_tarjeta INTO v_sbcu_cod_pgtj;
        CLOSE c_cuenta_tarjeta;        
        --
        INSERT INTO co_ttem_mvco(
                tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                         VALUES (v_idTrans_con, v_sbcu_cod_pgtj , v_vlr_total_fact_co , 'D');
        --
        UPDATE fa_tfact
        SET fact_vlr_tarjeta = v_vlr_total_fact_co,
        fact_vlr_dcto = v_vlr_dscto_fact
        WHERE fact_fact = v_fact_fact
        ;
        --
    ELSIF upper(p_tipoPago) = 'M' THEN
        --
        --Validaciones necesarias para el pago mixto(tarjeta y efectivo)
        --
        IF p_valrTarjeta = 0 THEN
            --
            RAISE EXCEPTION 'SI DESA PAGAR CON TARJETA Y EN EFECTIVO EL VALOR DEL PAGO CON TARJETA NO PUEDE SER 0';
            --
        END IF;
        --
        v_valor_real_apagar := v_vlr_total_fact_co - v_vlr_dscto_fact;
        --
        IF v_valor_real_apagar = p_valrTarjeta THEN
            --
            RAISE EXCEPTION  'Cuando se realiza el pago mixto no es posible que el pago con tarjeta sea la totatalida de la compra y si desea realizarlo asi por favor seleccione PAGO CON TARJETA ';
            --
        END IF;
        
        IF v_valor_real_apagar < p_valrTarjeta THEN
            --
            RAISE EXCEPTION  'El pago con tarjeta no puede ser mayor a la totalidad de la compra';
            --
        END IF;        
        --
        v_valor_pago_efectivo := v_vlr_total_fact_co - p_valrTarjeta;
        --
        OPEN c_cuenta_tarjeta;
        FETCH c_cuenta_tarjeta INTO v_sbcu_cod_pgtj;
        CLOSE c_cuenta_tarjeta;        
        --        
        INSERT INTO co_ttem_mvco(
                tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                         VALUES (v_idTrans_con, v_sbcu_cod_pgtj , p_valrTarjeta , 'D');
        --
        INSERT INTO co_ttem_mvco(
                tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                         VALUES (v_idTrans_con, '110501' , v_valor_pago_efectivo , 'D');
        --
        --Actualizaciones en la factura de los pagos
        --
        UPDATE fa_tfact
        SET fact_vlr_efectivo = v_valor_pago_efectivo,
        fact_vlr_tarjeta = p_valrTarjeta,
        fact_vlr_dcto = v_vlr_dscto_fact
        WHERE fact_fact = v_fact_fact
        ;
        --
    ELSE 
        --
        INSERT INTO co_ttem_mvco(
                tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                         VALUES (v_idTrans_con, '110501' , v_vlr_total_fact_co , 'D');
        --
        UPDATE fa_tfact
        SET fact_vlr_efectivo = v_vlr_total_fact_co,
        fact_vlr_dcto = v_vlr_dscto_fact
        WHERE fact_fact = v_fact_fact
        ;
        --
    END IF;
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
                         1, 1);
            
        END LOOP;
        --
    ELSE
        --
        RAISE EXCEPTION 'Las sumas de las cuentas al facturar no coinciden por favor contactese con el administrador Debitos %, Creditos %',v_sum_deb,v_sum_cre;
        --
    END IF;
    --
    RETURN 'Ok-'||v_fact_fact;
    --    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';