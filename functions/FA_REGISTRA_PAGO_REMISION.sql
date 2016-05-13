--    
--Funcion que realiza la cancelacion de la factura
--
CREATE OR REPLACE FUNCTION FA_REGISTRA_PAGO_REMISION(
                                p_tius                  INT,
                                p_fact                  INT,
                                p_valor                 NUMERIC(1000,10) ,
                                p_tipoPag               VARCHAR,
                                p_pagaTodo              VARCHAR
                                )RETURNS VARCHAR AS $$
    DECLARE
        --
        --Cursor con el cual identifico si la factura tiene algun pago anteriormente realizado
        --
        c_busca_pagos CURSOR FOR
        SELECT count(*)
          FROM fa_tpgrm
         WHERE pgrm_fact = p_fact
         ;
        --
        v_cont_pagos    bigint;
        --
        v_pgrm_pgrm     bigint;
        --
        c_id_pgrm CURSOR FOR
        SELECT MAX(pgrm_pgrm) + 1
          FROM fa_tpgrm
          ;
        --
        c_datos_fact CURSOR FOR
        SELECT fact_clien, fact_vlr_acobrar
          FROM fa_tfact
         WHERE fact_fact = p_fact
        ;
        --
        v_cliente           bigint;
        v_vlr_acobrar       numeric(1000,10) := 0;
        --
        c_remi_remi CURSOR FOR
        SELECT remi_remi
          FROM in_tremi
         WHERE remi_fact = p_fact
         ;
        --
        v_remi      bigint;
        --
        v_estado_pago           varchar(2):= '';
        --
        c_id_pagos CURSOR FOR
        SELECT pgrm_pgrm
          FROM fa_tpgrm
         WHERE pgrm_fact = p_fact
         ;
        --
        v_valor_dt_pag      numeric(1000,10) := 0;
        --
        v_idTrans_con           BIGINT := 0;
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
        c_sbcu_factura  CURSOR(vc_temIdTrans INT) IS
        SELECT tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza
          FROM co_ttem_mvco
         WHERE tem_mvco_trans = vc_temIdTrans
         ;
        --
        --Obtiene el id de una subcuenta basandose en el codigo de la misma
        --
        c_sbcu_sbcu CURSOR(vc_sbcu_codigo VARCHAR) IS
        SELECT sbcu_sbcu
          FROM co_tsbcu
         WHERE sbcu_codigo = vc_sbcu_codigo
         ;
        --
        v_sbcu_sbcu             BIGINT := 0;
        --
        v_sum_deb               NUMERIC(1000,10):=0;
        v_sum_cre               NUMERIC(1000,10):=0;
        --
    BEGIN
        --
        OPEN c_busca_pagos;
        FETCH c_busca_pagos INTO v_cont_pagos;
        CLOSE c_busca_pagos;
        --
        OPEN c_datos_fact;
        FETCH c_datos_fact INTO v_cliente,v_vlr_acobrar;
        CLOSE c_datos_fact;
        --
        OPEN c_remi_remi;
        FETCH c_remi_remi INTO v_remi;
        CLOSE c_remi_remi;
        --
        IF v_vlr_acobrar < p_valor and p_pagaTodo = 'N'  THEN
            --
            RAISE EXCEPTION 'El valor a cancelar no puede ser mayor al valor de la deuda';
            --
        END IF;
        --
        IF p_pagaTodo = 'S' THEN
            --
            v_estado_pago   := 'PT';
            v_valor_dt_pag  := v_vlr_acobrar;
            --
        ELSE
            --
            v_estado_pago   := 'PP';
            v_valor_dt_pag  := p_valor;
            --
        END IF;
        --
        IF v_cont_pagos = 0 THEN
            --
            --Registramos el primer pago
            --
            OPEN c_id_pgrm;
            FETCH c_id_pgrm INTO v_pgrm_pgrm;
            CLOSE c_id_pgrm;
            --
            INSERT INTO fa_tpgrm (pgrm_pgrm,pgrm_clien,pgrm_fact,pgrm_remi,pgrm_estado,pgrm_vlrdeuda)
                          VALUES (v_pgrm_pgrm,v_cliente,p_fact,v_remi,v_estado_pago,v_vlr_acobrar);
            --
        ELSE
            --
            OPEN c_id_pagos;
            FETCH c_id_pagos INTO v_pgrm_pgrm;
            CLOSE c_id_pagos;
            --
        END IF;
        --
        --Cursor con el cual obtengo el id de movimientos contables
        --
        OPEN c_sec_tem_mvco;
        FETCH c_sec_tem_mvco INTO v_idTrans_con;
        CLOSE c_sec_tem_mvco;
        --
        INSERT INTO co_ttem_mvco(
                    tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                    VALUES (v_idTrans_con, '138020' , v_valor_dt_pag, 'C');
        --
        INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                     VALUES (v_idTrans_con, '110501' , v_vlr_fin_tot, 'D');
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
                             'pgrm', v_pgrm_pgrm,
                             v_cliente, '1' );
                
            END LOOP;
        --
        ELSE
            --
            RAISE EXCEPTION 'Las sumas de las cuentas al facturar no coinciden por favor contactese con el administrador Debitos %, Creditos %',v_sum_deb,v_sum_cre;
            --
        END IF;
        --
        INSERT INTO fa_tdpgr(dpgr_pgrm,dpgr_estado,dpgr_tipopago,dpgr_valor,dpgr_mvcot)
              VALUES(v_pgrm_pgrm,'P',p_tipoPag,v_valor_dt_pag,v_vlr_acobrar,v_idTrans_con);
        --
        UPDATE fa_tfact
           SET fact_vlr_acobrar = (fact_vlr_acobrar-v_vlr_acobrar),
               fact_vlr_abonos = v_vlr_acobrar
         WHERE fact_fact = p_fact;
        --
    RETURN 'OK';

    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_REGISTRA_PAGO_REMISION '|| sqlerrm;
    END;
    $$ LANGUAGE 'plpgsql';     