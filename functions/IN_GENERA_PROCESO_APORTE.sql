    --
-- Funcion con la cual cambiare los productos de una sede a otra
--
CREATE OR REPLACE FUNCTION IN_GENERA_PROCESO_APORTE(   
                                            p_apor              BIGINT,
                                            p_auco              BIGINT,
                                            p_tius              BIGINT
                                            ) RETURNS VARCHAR AS $$
    DECLARE
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
    --
    c_sbcu_factura  CURSOR(vc_temIdTrans INT) IS
    SELECT tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza
      FROM co_ttem_mvco
     WHERE tem_mvco_trans = vc_temIdTrans
     ;
    --
    --
    --Obtiene el id de una subcuenta basandose en el codigo de la misma
    --
    c_sbcu_sbcu CURSOR(vc_sbcu_codigo VARCHAR) IS
    SELECT sbcu_sbcu
      FROM co_tsbcu
     WHERE sbcu_codigo = vc_sbcu_codigo
     ;
    --
    v_sum_deb               NUMERIC(1000,10):=0;
    v_sum_cre               NUMERIC(1000,10):=0;
    v_sbcu_sbcu             BIGINT := 0;
    v_auxcont               bigint := 0;
    --
    c_auco cursor for
    select count(*)
      from co_tauco
     where auco_codi like '3105%'
    ;
    --
    v_valida_auco           bigint := 0;
    --
    --Funcion con la cual obtengo los productos del aporte
    --
    c_prod_aporte cursor for
    SELECT prap_dska, prap_cant, prap_costo, apor_sede, prap_prap, apor_soci
      FROM in_tprap, em_tapor
     WHERE prap_apor = p_apor
     and apor_apor = prap_apor
     ;
    --
    v_vlr_apor              numeric (1000,10):=0;
    --
    --Consultas del movimiento de inventario de ingreso de aportes
    --
    c_mvIn_aporte CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE MVIN_CODIGO = 'INAP'
     ;
    --
    v_mvin_mvin             bigint    :=0;
    --
    v_rta_insrt_kar           VARCHAR(500) := '';
    --
    c_sbcu_prod    CURSOR (vc_dska bigint ) IS
    SELECT sbcu_codigo
      FROM in_tcate,in_tdska, co_tsbcu
     WHERE dska_cate = cate_cate
        and dska_dska = vc_dska
        and cate_sbcu = sbcu_sbcu
    ;
    --
    v_sbcu_prod            varchar :=0;
    --
    --
    --Cursor el cual sirve para obtener el id temporal de transaccion para la tabla temporal
    --de movimientos contables
    --
    c_sec_tem_mvco CURSOR FOR
    SELECT nextval('co_temp_movi_contables') 
    ;
    --
    v_idTrans_con           BIGINT := 0;
    v_kapr_kapr             BIGINT := 0;
    --
    c_sbcu_codigo CURSOR FOR
    select sbcu_codigo
      from co_tauco, co_tsbcu
     where auco_sbcu = sbcu_sbcu
       and auco_auco  = p_auco
       ;
    --
    v_sbcu_codigo           varchar(10):= '';
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
    v_apor_soci         bigint :=0;
    --
    --Cursor con el cual valido si la subcuenta es igual a la subcuenta
    --
    c_valida_auco_sbcu CURSOR(vc_sbcu_sbcu   bigint) FOR
    SELECT COUNT(*)
      FROM co_tauco
     WHERE auco_sbcu = vc_sbcu_sbcu
       AND auco_auco = p_auco
       ;
    --
    v_valida_subcu_auco         bigint := 0;
    --
    BEGIN
    --
    --Validacion de la informacion
    --
    OPEN c_auco;
    FETCH c_auco INTO v_valida_auco;
    CLOSE c_auco;
    --
    IF v_valida_auco = 0 THEN
        --
        raise exception 'La subcuenta proporcionada no corresponde a un cuenta valida (Debe pertenecer a la cuenta 3105)';
        --
    END IF;
    --
    UPDATE em_tapor
       SET apor_auco = p_auco
     WHERE apor_apor = p_apor
     ;
    --
    --
    OPEN c_mvIn_aporte;
    FETCH c_mvIn_aporte INTO v_mvin_mvin;
    CLOSE c_mvIn_aporte;
    --
    IF v_mvin_mvin IS NULL THEN
        --
        RAISE EXCEPTION 'No existe Movimiento de Inventario Parametrizado para las compras de mercancia';
        --
    END IF;
    --
    --Busco el id de la contabilidad
    --
    OPEN c_sec_tem_mvco;
    FETCH c_sec_tem_mvco INTO v_idTrans_con;
    CLOSE c_sec_tem_mvco;
    --
    FOR prod IN c_prod_aporte LOOP
        --
        v_apor_soci := prod.apor_soci;
        --
        v_rta_insrt_kar := IN_FINSERTA_PROD_KARDEX(prod.prap_dska,
                                                   v_mvin_mvin,
                                                   p_tius,
                                                   prod.prap_cant,
                                                   (prod.prap_costo * prod.prap_cant) ,
                                                   prod.apor_sede                                                   
                                                   );
        IF upper(v_rta_insrt_kar) LIKE '%OK%' THEN
            --
            v_vlr_apor := v_vlr_apor + (prod.prap_costo * prod.prap_cant); 
            --
            OPEN c_kapr_kapr(v_rta_insrt_kar);
            FETCH c_kapr_kapr INTO v_kapr_kapr;
            CLOSE c_kapr_kapr;
            --
        ELSE
            --
            RAISE EXCEPTION 'Error al realizar el movimiento de inventario: % ',v_rta_insrt_kar ;
            --
        END IF;
        --
        --Busco la subcuenta corresapondiente al producto
        --
        OPEN c_sbcu_prod(prod.prap_dska);
        FETCH c_sbcu_prod INTO v_sbcu_prod;
        CLOSE c_sbcu_prod;
        --
        --
        INSERT INTO co_ttem_mvco(
                                            tem_mvco_trans, 
                                            tem_mvco_sbcu, 
                                            tem_mvco_valor, 
                                            tem_mvco_naturaleza)
                    VALUES (v_idTrans_con,
                            v_sbcu_prod, 
                            (prod.prap_costo * prod.prap_cant), 
                            'D');
        --
        UPDATE in_tprap
           SET prap_kapr = v_kapr_kapr
         WHERE prap_prap = prod.prap_prap
         ;
         --
    END LOOP;
    --
    UPDATE em_tapor
       SET apor_valor = v_vlr_apor,
       apor_estado = 'X'
     WHERE apor_apor = p_apor
    ;
    --
    OPEN c_sbcu_codigo;
    FETCH c_sbcu_codigo INTO v_sbcu_codigo;
    CLOSE c_sbcu_codigo;
    --
    INSERT INTO co_ttem_mvco(
                                            tem_mvco_trans, 
                                            tem_mvco_sbcu, 
                                            tem_mvco_valor, 
                                            tem_mvco_naturaleza)
                    VALUES (v_idTrans_con,
                            v_sbcu_codigo, 
                            v_vlr_apor, 
                            'C');
    --
    OPEN c_sum_debitos(v_idTrans_con);
    FETCH c_sum_debitos INTO v_sum_deb;
    CLOSE c_sum_debitos;
    --
    OPEN c_sum_creditos(v_idTrans_con);
    FETCH c_sum_creditos INTO v_sum_cre;
    CLOSE c_sum_creditos;
    --
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
            IF v_sbcu_sbcu is null THEN
                --
                raise exception 'La subcuenta con el codigo % no tiene referencia en la tabla de subcuentas ', movi.tem_mvco_sbcu;
                --
            END IF;
            --
            OPEN c_valida_auco_sbcu(v_sbcu_sbcu);
            FETCH c_valida_auco_sbcu INTO v_valida_subcu_auco;
            CLOSE c_valida_auco_sbcu;
            --
            IF v_valida_subcu_auco = 0 THEN
                --
                v_auxcont := CO_BUSCA_AUXILIAR_X_TIDO(v_sbcu_sbcu,'apor');
                --
            ELSE
                --
                v_auxcont := CO_BUSCA_AUXILIAR_X_TIDO(v_sbcu_sbcu,'apor',cast(p_auco as varchar) );
                --
            END IF;
            --
            --
            IF movi.tem_mvco_naturaleza = 'C' THEN
                --
                v_auxcont := p_auco;
                --
            END IF;
            --
            INSERT INTO co_tmvco(mvco_trans, 
                                 mvco_sbcu, mvco_naturaleza, 
                                 mvco_tido, mvco_valor, 
                                 mvco_lladetalle, mvco_id_llave, 
                                 mvco_tercero, mvco_tipo,mvco_auco)
                VALUES ( v_idTrans_con, 
                         v_sbcu_sbcu, movi.tem_mvco_naturaleza, 
                         6, cast(movi.tem_mvco_valor as NUMERIC),
                         'apor', p_apor,
                         v_apor_soci, 4, v_auxcont );
            
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
    RETURN 'Ok';
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error IN_GENERA_PROCESO_APORTE ' ||sqlerrm ;
    END;
$$ LANGUAGE 'plpgsql';