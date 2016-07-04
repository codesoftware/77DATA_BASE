--
--funcion que realiza la solicitud
--
CREATE OR REPLACE function IM_FEJECUTAIMPORTACION(
                  p_tius         bigint,
                  p_impo         bigint,
                  p_sede         bigint default 2
                  ) RETURNS VARCHAR AS $$
    DECLARE
    --
    c_valida_trm_tasa CURSOR  FOR
    SELECT impo_trm,  impo_tazaprom, impo_estado
      FROM im_timpo
     WHERE impo_impo = p_impo
      ;
    --
    --Obtengo el id de la tabla temporal de movimientos contables
    --
    c_sec_contabilidad CURSOR IS
    SELECT CAST(nextval('co_temp_movi_contables') AS INT)
    ;
    v_trm               numeric(1000,10) := 0; 
    v_taza              numeric(1000,10) := 0;
    v_estado            varchar(10) := '';
    --
    v_valida            varchar(1000) := '';
    --
    --Cursor con el cual obtengo los productos de la importacion
    --
    c_prod_impo CURSOR FOR
    SELECT prim_prim, prim_dska, prim_cant, prim_vlrdolar, prim_vlrpestrm, 
       prim_vlrpestzprom
      FROM im_tprim
     WHERE prim_impo = p_impo 
      ;
    --
    --Cursor para obtener el codigo de la subcuenta
    --
    c_sbcu_prod CURSOR(vc_dska_dska  bigint) FOR
    SELECT sbcu_codigo
      FROM in_tdska, co_tsbcu
      WHERE sbcu_sbcu = dska_sbcu
       AND dska_dska = vc_dska_dska
       ;
     --
     v_sbcu_prod                     VARCHAR(500)     := '';
     --
     v_sec_cont                      BIGINT :=0;
     --
     v_valor_prod                       numeric(1000,10):= 0;
     v_valor_total                      numeric(1000,10):= 0;
     --
     v_mvin_mvin                        bigint:=0;
     --
     c_mvin CURSOR FOR
     SELECT mvin_mvin
       FROM in_tmvin
      WHERE MVIN_CODIGO = 'IMPO'
     ;
    --
    v_rta_insrt_kar             varchar(1000):= '';
    --
    --
    --Obtiene debitos ingresados por el usuario
    --
    c_deb_usua CURSOR(vc_idTrans  bigint) FOR
    SELECT coalesce(sum(cast(tem_mvco_valor as numeric)),0)
      FROM co_ttem_mvco
     WHERE tem_mvco_naturaleza = 'D'
       AND tem_mvco_trans = vc_idTrans
    ;
    --
    --Obtiene creditos por el usuario por el usuario
    --
    c_cre_usua CURSOR(vc_idTrans  bigint) FOR
    SELECT coalesce(sum(cast(tem_mvco_valor as numeric)),0)
      FROM co_ttem_mvco
     WHERE tem_mvco_naturaleza = 'C'
       AND tem_mvco_trans = vc_idTrans
    ;
    --
    v_debitos               NUMERIC(1000,10) :=0;
    v_creditos              NUMERIC(1000,10) :=0;
    --
    -- Obtiene el identificador del tipo de documento 
    --
    c_id_ttido CURSOR FOR
    SELECT tido_tido
      FROM co_ttido
     WHERE upper(tido_nombre) = 'IMPORTA'
    ;
    --
    v_tipoDocumento     BIGINT := 0;
    --
    --Cursor necesario para la realizacion de los movimientos contables
    --
    c_movi_cont CURSOR (vc_idTrans  bigint)FOR
    SELECT sbcu_sbcu,cast(tem_mvco_valor as numeric) valor,tem_mvco_naturaleza natu,TEM_MVCO_PROV prov
      FROM co_ttem_mvco, co_tsbcu
     WHERE tem_mvco_sbcu = sbcu_codigo
       AND tem_mvco_trans = vc_idTrans
       ;
    --
    v_prov_prov         bigint;
    --
    --Cursor con el cual obtengo el proveedor internacional de la importacion
    --
    c_pvin_cont CURSOR FOR
    SELECT impo_pvin
      FROM im_timpo
     WHERE impo_impo = p_impo
     ;
    --
    v_pvin              bigint := 0;
    --
    v_auco_auco         bigint := 0;
    --
    c_dtgas CURSOR FOR
    SELECT count(*)
      FROM im_timpo, im_tgast, im_tdgas
     WHERE gast_impo = impo_impo
       AND gast_gast = dgas_gast
       ;
    --
    v_dtgas         bigint := 0;
    --
    --Consultamos los gastos de la importacion
    --
    c_gasto_impo CURSOR FOR
    SELECT gast_gast,gast_prov
      FROM im_tgast
     WHERE gast_impo = p_impo
     ;
    --
    v_gast_gast         bigint := 0 ;
    --
    c_valida_dgast CURSOR(vc_gast   bigint) FOR
    SELECT count(*)
      FROM im_tdgas
     WHERE dgas_gast = vc_gast
     ;
    --
    v_val_dgas                  BIGINT :=0;
    --
    v_total_gasto               NUMERIC(1000,10):= 0;
    --
    c_detalle_gasto CURSOR(vc_gast  bigint) FOR
    SELECT dgas_valor, auco_auco, sbcu_sbcu, sbcu_codigo
      FROM im_tdgas, co_tauco, co_tsbcu
     WHERE dgas_gast = vc_gast
       AND dgas_auco = auco_auco
       AND auco_sbcu = sbcu_sbcu
       ;
    --
    BEGIN
    --
    OPEN c_dtgas;
    FETCH c_dtgas into v_dtgas;
    CLOSE c_dtgas;
    --
    IF v_dtgas = 0 THEN 
        --
        raise exception 'Error la importacion no tiene asociado ningun gasto o los gastos no tienen detalle operacion no valida';
        --
    END IF;
    --
    OPEN c_valida_trm_tasa;
    FETCH c_valida_trm_tasa into v_trm,v_taza,v_estado;
    CLOSE c_valida_trm_tasa;
    --
    OPEN c_pvin_cont;
    FETCH c_pvin_cont into v_pvin;
    CLOSE c_pvin_cont;
    --
    IF v_estado <> 'C' THEN
        --
        RAISE EXCEPTION 'La importacion debe tener el estado activo, imposible realizar el proceso';
        --
    END IF;
    --
    IF v_trm is null OR  v_taza is null THEN
        --
        RAISE EXCEPTION 'La taza promedio de la importacion no puede ser nula por favor ingresela ';
        --
    ELSE
        --
        v_valida := im_convierte_dolares_importacion(p_impo,v_trm,v_taza);
        --
    END IF;
    --
    OPEN c_sec_contabilidad;
    FETCH c_sec_contabilidad INTO v_sec_cont;
    CLOSE c_sec_contabilidad;
    --
    OPEN c_mvin;
    FETCH c_mvin INTO v_mvin_mvin;
    CLOSE c_mvin;
    --
    FOR prod in c_prod_impo LOOP
        --
        v_valor_prod := prod.prim_vlrpestzprom*prod.prim_cant;
        --
        --Se realiza el ingreso de lo productos
        --
        --Insertamos el kardex de productos
        --
        v_rta_insrt_kar := IN_FINSERTA_PROD_KARDEX(prod.prim_dska,
                                               v_mvin_mvin,
                                               p_tius,
                                               prod.prim_cant,
                                               v_valor_prod,
                                               p_sede                                                   
                                               );
        --
        IF upper(v_rta_insrt_kar) NOT LIKE '%OK%' THEN
            --
            raise exception ' Error al realizar el ingreso de productos en la importacion % ',v_rta_insrt_kar;
            --
        END IF;
        --
        OPEN c_sbcu_prod(prod.prim_dska);
        FETCH c_sbcu_prod INTO v_sbcu_prod;
        CLOSE c_sbcu_prod;
        --
        --Insercion de la cuenta de inventario de cada producto de la factura de compra
        --
        INSERT INTO co_ttem_mvco(
                                tem_mvco_trans, 
                                tem_mvco_sbcu, 
                                tem_mvco_valor, 
                                tem_mvco_naturaleza)
        VALUES (v_sec_cont,
                v_sbcu_prod, 
                v_valor_prod, 
                'D')
                ;
        --
        v_valor_total := v_valor_prod + v_valor_total;
        --
    END LOOP;
    --
    --Realizo el pago con la cuenta puente
    --
    INSERT INTO co_ttem_mvco(
                                            tem_mvco_trans, 
                                            tem_mvco_sbcu, 
                                            tem_mvco_valor, 
                                            tem_mvco_naturaleza)
                    VALUES (v_sec_cont,
                            '790505', 
                            v_valor_total, 
                            'C');
    --
    --Inicio contabilidad
    --
    OPEN c_deb_usua(v_sec_cont);
    FETCH c_deb_usua INTO v_debitos;
    CLOSE c_deb_usua;
    --
    OPEN c_cre_usua(v_sec_cont);
    FETCH c_cre_usua INTO v_creditos;
    CLOSE c_cre_usua;
    --
    IF v_creditos = v_debitos THEN
        --
        OPEN c_id_ttido;
        FETCH c_id_ttido INTO v_tipoDocumento;
        CLOSE c_id_ttido;   
        --
        FOR movi IN c_movi_cont(v_sec_cont)
        LOOP
            --
            v_auco_auco := CO_BUSCA_AUXILIAR_X_TIDO(movi.sbcu_sbcu,'impo');
            --
            INSERT INTO co_tmvco(mvco_trans, 
                         mvco_sbcu, mvco_naturaleza, 
                         mvco_tido, mvco_valor, 
                         mvco_lladetalle, mvco_id_llave, 
                         mvco_tercero, mvco_tipo, mvco_auco )
                    VALUES ( v_sec_cont, 
                          movi.sbcu_sbcu , movi.natu, 
                          v_tipoDocumento, movi.valor,
                          'impo', p_impo,
                          v_pvin, 3, v_auco_auco );
            --
            
            --
        END LOOP;
        --
    ELSE
        --
        RAISE EXCEPTION 'La suma de los debitos: % y los creditos: % no coinciden.', v_creditos,  v_debitos;
        --
    END IF;
    --        
    DELETE FROM co_ttem_mvco
    WHERE tem_mvco_trans = v_sec_cont;
    --
    UPDATE IM_TIMPO
       SET impo_idTrans_co = v_sec_cont
     WHERE IMPO_IMPO = p_impo
     ;
    --
    --Inicio de contabilizacion de 
    --
    --OPEN c_sec_contabilidad;
    --FETCH c_sec_contabilidad INTO v_sec_cont;
    --CLOSE c_sec_contabilidad;
    --
    FOR gasto IN c_gasto_impo LOOP
        --
        OPEN c_valida_dgast(gasto.gast_gast);
        FETCH c_valida_dgast INTO v_val_dgas;
        CLOSE c_valida_dgast;
        --
        IF v_val_dgas = 0 THEN 
            --
            raise exception 'Error el gasto no tiene detalle de gasto lo cual no es permitido';
            --
        END IF;
        --
        v_total_gasto := 0; 
        --
        OPEN c_sec_contabilidad;
        FETCH c_sec_contabilidad INTO v_sec_cont;
        CLOSE c_sec_contabilidad;
        --
        
        FOR detalle IN c_detalle_gasto(gasto.gast_gast) LOOP
            --
            v_total_gasto := v_total_gasto + detalle.dgas_valor;
            --
            INSERT INTO co_ttem_mvco(
                                tem_mvco_trans, 
                                tem_mvco_sbcu, 
                                tem_mvco_valor, 
                                tem_mvco_naturaleza
                                )
                            VALUES (v_sec_cont,
                                    detalle.sbcu_codigo, 
                                    detalle.dgas_valor, 
                                    'D'
                                    )
                                    ;
            --
        END LOOP;
        --
        INSERT INTO co_ttem_mvco(
                                tem_mvco_trans, 
                                tem_mvco_sbcu, 
                                tem_mvco_valor, 
                                tem_mvco_naturaleza)
                            VALUES (v_sec_cont,
                                    '220501', 
                                    v_total_gasto, 
                                    'C')
                                    ;
        --
        --Inicio contabilidad
        --
        OPEN c_deb_usua(v_sec_cont);
        FETCH c_deb_usua INTO v_debitos;
        CLOSE c_deb_usua;
        --
        OPEN c_cre_usua(v_sec_cont);
        FETCH c_cre_usua INTO v_creditos;
        CLOSE c_cre_usua;
        --
        IF v_creditos = v_debitos THEN
            --
            OPEN c_id_ttido;
            FETCH c_id_ttido INTO v_tipoDocumento;
            CLOSE c_id_ttido;   
            --
            FOR movi IN c_movi_cont(v_sec_cont)
            LOOP
                --
                v_prov_prov := movi.prov;
                --
                IF  v_prov_prov is null THEN
                    --
                    v_prov_prov := 0;
                    --
                END IF;
                --
                --v_auco_auco := CO_BUSCA_AUXILIAR_X_TIDO(movi.sbcu_sbcu,'impo');
                --
                INSERT INTO co_tmvco(mvco_trans, 
                             mvco_sbcu, mvco_naturaleza, 
                             mvco_tido, mvco_valor, 
                             mvco_lladetalle, mvco_id_llave, 
                             mvco_tercero, mvco_tipo, mvco_auco )
                        VALUES ( v_sec_cont, 
                                movi.sbcu_sbcu , movi.natu, 
                                v_tipoDocumento, movi.valor,
                                'gaim', gasto.gast_gast,
                                gasto.gast_prov, 2,0 );
                --
                
                --
            END LOOP;
            --
        ELSE
            --
            RAISE EXCEPTION 'La suma de los debitos: % y los creditos: % no coinciden.', v_creditos,  v_debitos;
            --
        END IF;
        --
        DELETE FROM co_ttem_mvco
        WHERE tem_mvco_trans = v_sec_cont;
        --
        UPDATE im_tgast
           SET gast_tran_mvco = v_sec_cont
         WHERE gast_gast =  gasto.gast_gast
        ;
        --
    END LOOP;
    --
    UPDATE im_timpo
      SET impo_estado = 'X'
     WHERE impo_impo = p_impo
     ;
    --
    RETURN 'OK';
    --
    EXCEPTION WHEN 
        OTHERS THEN
            --
            return 'Error IM_FEJECUTAIMPORTACION ' || sqlerrm;
    END;
    $$ LANGUAGE 'plpgsql';