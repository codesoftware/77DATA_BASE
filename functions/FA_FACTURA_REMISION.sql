--
-- Funcion con la cual facturo una remision en el sistema(en el cual solo factura no mueve inventarios ya que al generar la remision ya fueron realizados)
--
CREATE OR REPLACE FUNCTION FA_FACTURA_REMISION (  
                                p_tius                  BIGINT      ,
                                p_clien                 BIGINT      ,
                                p_idTrans               BIGINT      ,
                                p_sede                  BIGINT      , 
                                p_tipoPago              VARCHAR     ,
                                p_idVaucher             BIGINT      ,
                                p_valrTarjeta           BIGINT      ,
                                p_idPedido              BIGINT      ,
                                p_retefuente            VARCHAR     ,
                                p_rsfa                  BIGINT      ,
                                p_remi                  BIGINT 
                         )RETURNS VARCHAR AS $$
    DECLARE
    --
    --Cursor que obtiene el iva parametrizado
    --
    c_iva_precio CURSOR IS
    SELECT cast(para_valor as numeric)
      FROM em_tpara
     WHERE para_clave = 'IVAPRVENTA'
    ;
    --
    v_aux_porc          numeric(1000,10) := 100.00;
    v_vlr_fin_tot       numeric(1000,10) := 0;
    v_iva_precio        NUMERIC(1000,10) := 0;
    v_auxiliar          NUMERIC(1000,10) := 0;
    v_precio_base       NUMERIC(1000,10) := 0;
    --
    --Logica para validaciones previas a la facturacion
    --
    --
    v_vlr_total_fact_co     NUMERIC(1000,10) := 0;
    --
    --Variables utilizadas para los valores principales de facturacion
    --
    v_vlr_total     NUMERIC(1000,10)  :=0;
    v_vlr_iva       NUMERIC(1000,10)  :=0;
    v_vlr_retfuente NUMERIC(1000,10)  :=0;
    --
    --Variables necesarias para la validacion de subcuentas
    --
    v_val_iva_generado          bigint :=0;
    v_val_costo_ventas          bigint :=0;
    v_val_mercancias_mm         bigint :=0;
    v_val_descuentos            bigint :=0;
    v_val_caja_menor            bigint :=0;
    --
    v_fact_fact     NUMERIC(1000,10)  :=0;
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
    SELECT tem_fact_dska, tem_fact_cant,tem_fact_dcto , tem_fact_pruni
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
    v_precio_prod               numeric(1000,5):= 0;
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
    v_sum_deb               NUMERIC(1000,10):=0;
    v_sum_cre               NUMERIC(1000,10):=0;
    v_sbcu_sbcu             BIGINT := 0;
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
    v_valor_iva_fact        NUMERIC(1000,10) := 0;
    v_vlr_total_factura     NUMERIC(1000,10) := 0;
    v_idTrans_con           BIGINT := 0;
    --
    v_valida_basica         varchar(4000)   := '';
    --
    c_valida_Pedido CURSOR FOR
    select count(*)
      from in_tpedi
     where pedi_pedi = p_idPedido
     ;
    v_valida_pedido         BIGINT:=0;
    --
    --Cursor con el cual se obtiene el id de la subcuenta de la caja menor
    --
    c_sbcu_caja CURSOR FOR
    SELECT sbcu_codigo
      FROM em_tsede, co_tsbcu
     WHERE sede_sede = p_sede
       AND sbcu_sbcu = sede_sbcu_caja
     ;
    --
    v_sbcu_caja_cod     varchar(10):= '';
    --
    --Cursor con el cual se obtiene el valor del descuento de la factura
    --
    c_valor_dcto CURSOR(vc_fact_fact INT) FOR
    SELECT fact_vlr_dcto
      FROM fa_tfact
     WHERE fact_fact = vc_fact_fact
      ;
    --
    v_vlr_dsc           NUMERIC(1000,6) := 0;
    --
    v_ajuste_peso       NUMERIC(1000,6) := 0;
    --
    v_aux_peso          NUMERIC(1000,6) := 50.0000000000;
    --
    v_valida            varchar(4000) := '';
    --
    BEGIN
    --
    v_valida_basica := FA_VAL_CON_FACTU(p_sede);
    --
    --
    IF UPPER(v_valida_basica) <> 'OK' THEN
        --
        RAISE EXCEPTION ' %', v_valida_basica;
        --
    END IF;
    --
    IF p_idPedido <> 0 THEN
        --
        OPEN c_valida_Pedido;
        FETCH c_valida_Pedido INTO v_valida_pedido;
        CLOSE c_valida_Pedido;
        --
        IF v_valida_pedido = 0 THEN
            --
            RAISE EXCEPTION ' La factura referencia un pedido inexistente con el numero % ', p_idPedido;
            --
        END IF;
        --
    END IF;
    --
    OPEN c_fact_fact;
    FETCH c_fact_fact INTO v_fact_fact;
    CLOSE c_fact_fact;
    --
    IF upper(p_tipoPago) = 'T' THEN
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_tipo_pago, fact_id_voucher, fact_sede, fact_pedi)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva,    'T',            p_idVoucher,p_sede,p_idPedido)
                    ;
        --
    ELSIF upper(p_tipoPago) = 'M' THEN
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_tipo_pago, fact_id_voucher, fact_sede, fact_pedi)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva,    'M',            p_idVoucher,p_sede,p_idPedido)
                    ;
        --
    ELSE
        --
        INSERT INTO FA_TFACT(fact_fact,   fact_tius, fact_clien, fact_vlr_total, fact_vlr_iva, fact_sede, fact_pedi)
                     VALUES (v_fact_fact, p_tius,    p_clien,    v_vlr_total,    v_vlr_iva, p_sede,p_idPedido)
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
        v_rta_fact_prod := FA_FACT_PROD_REMI(
                                                p_tius,
                                                prod.tem_fact_dska,
                                                p_sede,
                                                prod.tem_fact_cant,
                                                v_idTrans_con,
                                                cast(v_fact_fact as int),
                                                prod.tem_fact_pruni,
                                                p_remi
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
    --Se comenta el codigo ya que el codigo 
    --
    --FOR receta IN c_rece_fact 
    --LOOP
    --    --
    --    v_rta_fact_rece := FA_FACTURA_RECETA(
    --                                        p_tius,
    --                                        receta.tem_rece_rece,
    --                                        p_sede,
    --                                        receta.tem_rece_cant,
    --                                        v_idTrans_con,
    --                                        cast(v_fact_fact as int)                                            
    --                                        );
    --    --
    --    IF UPPER(v_rta_fact_rece) <> 'OK' THEN 
    --    --
    --        RAISE EXCEPTION 'Error al facturar la receta o plato con el id % con el siguiente error % ',receta.tem_fact_rece, v_rta_fact_rece;
    --    --
    --    END IF;
    --    --
    --END LOOP;
    --
    DELETE FROM co_ttem_fact
    WHERE tem_fact_trans = p_idTrans
    ;
    --
    OPEN c_vlr_iva_fact(cast(v_fact_fact as int));
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
    OPEN c_vlr_total_fact_sin_iva(cast(v_fact_fact as int));
    FETCH c_vlr_total_fact_sin_iva INTO v_vlr_total_factura;
    CLOSE c_vlr_total_fact_sin_iva;
    --
    --Insercion de Mercancias al por mayor y menor
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (v_idTrans_con, '413535' , v_vlr_total_factura , 'C');
    --
    OPEN c_valor_dcto(cast(v_fact_fact as int));
    FETCH c_valor_dcto INTO v_vlr_dsc;
    CLOSE c_valor_dcto;
    --
    --v_vlr_dsc := FA_CONSLUTA_COSTS_FACT(new.dtpr_fact,3,4);
    --raise exception 'Descuento % ', v_vlr_dsc;
    --
    --
    --Obtengo el valor total de la factura
    --
    OPEN c_vlr_total_fact(cast(v_fact_fact as int));
    FETCH c_vlr_total_fact INTO v_vlr_total_fact_co;
    CLOSE c_vlr_total_fact;
    --
    --Logica para que el dinero valla directo a la caja menor
    --
    OPEN c_sbcu_caja;
    FETCH c_sbcu_caja INTO v_sbcu_caja_cod;
    CLOSE c_sbcu_caja;
    --
    --Logica para la retencion en la fuente
    --
    IF p_retefuente = 'S' THEN
        --
        OPEN c_iva_precio;
        FETCH c_iva_precio INTO v_iva_precio;
        CLOSE c_iva_precio;
        --
        --Saco la base del iva
        v_auxiliar := 100.00;
        --
        v_auxiliar :=  (v_iva_precio / v_auxiliar)+1;
        --
        v_precio_base :=  (v_vlr_total_fact_co - v_vlr_dsc) /v_auxiliar;
        --
        v_vlr_retfuente := v_precio_base;
        v_vlr_retfuente := (v_vlr_retfuente * 2.5)/v_aux_porc;
        v_vlr_fin_tot := (v_vlr_total_fact_co - v_vlr_dsc) - v_vlr_retfuente;
        --
        --Inserto el valor de la retencion en la fuente
        --
        INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                     VALUES (v_idTrans_con, '135515' , v_vlr_retfuente, 'D');
        --
        UPDATE FA_TFACT
           SET FACT_RETEFUN = 'S',
           FACT_VLRRTFU = v_vlr_retfuente
         WHERE fact_fact = v_fact_fact
         ;
        --
    ELSE 
        --
        v_vlr_fin_tot := v_vlr_total_fact_co - v_vlr_dsc;
        --
    END IF;
    --
    --Logica para el redondeo de las cantidades a 50 y 100
    --
    IF mod(v_vlr_fin_tot,50) <> 0 THEN
        --
        v_ajuste_peso :=  v_aux_peso - mod(v_vlr_fin_tot,50);
        --
        INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                     VALUES (v_idTrans_con, '429581' , v_ajuste_peso, 'C');
        --
        v_vlr_fin_tot := v_vlr_fin_tot + v_ajuste_peso;
        --
    END IF;
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                     VALUES (v_idTrans_con, v_sbcu_caja_cod , v_vlr_fin_tot, 'D');
    --
    UPDATE fa_tfact
    SET fact_vlr_efectivo = v_vlr_total_fact_co,
    fact_ajpeso = v_ajuste_peso
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
                         p_clien, p_clien );
            
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
    --
    --
    UPDATE in_tpedi
       SET pedi_fact = v_fact_fact,
       pedi_esta = 'FA'
     WHERE pedi_pedi = p_idPedido
    ;
    --
    --Llamamos la funcion en donde determinamos la resolucion de facturacion y su consecutivo dentro de la resolucion
    --
    v_valida := FA_ASIGNA_RESOLUCION_FACTURA(cast(v_fact_fact as BIGINT),-1);
    --
    IF upper(v_valida) <> 'OK' THEN
        --
        RAISE EXCEPTION ' Error al encontrar la resolucion de facturacion % ',v_valida;
        --
    END IF;
    --
    RETURN 'Ok-'||cast(v_fact_fact as BIGINT);
    -- 
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_FACTURACION_X_PRECIO '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';