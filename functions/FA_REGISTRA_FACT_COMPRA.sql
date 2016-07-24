--
-- Funcion encargada de realizar el ingreso al inventario y la contabilizacion de los productos ya existentes en el sistema
--
CREATE OR REPLACE FUNCTION FA_REGISTRA_FACT_COMPRA (  
                                                        p_facom_facom         BIGINT
                                                    ) RETURNS VARCHAR  AS $$
    DECLARE
        --
        --Obtengo el id de la tabla temporal de movimientos contables
        --
        c_sec_contabilidad CURSOR IS
        SELECT CAST(nextval('co_temp_movi_contables') AS INT)
        ;
        --
        --Cursor con el cual obtengo la informacion basica de la factura de compra(productos adquiridos)
        --
        c_facCom CURSOR IS
        SELECT fcprd_cant, fcprd_subt, fcprd_dska, fcprd_piva,facom_sede, facom_tius,facom_tprov,facom_ajus
          FROM FA_TFACOM, fa_tfcprd
         WHERE facom_facom = fcprd_facom
           and fcprd_esta = 'A'
           and facom_facom = p_facom_facom
           ;
        --
        c_estado CURSOR IS
        select upper(facom_estad)
          from fa_tfacom
         where facom_facom = p_facom_facom
         ;
        --
        v_estado                        varchar(10):= '';
        --
        v_proveedor                     bigint:=0;
        v_vlr_iva_total                 NUMERIC(1000,10):= 0;
        v_aux                           NUMERIC(1000,10):= 0;
        --
        v_sec_cont                      BIGINT :=0;
        --
        v_sbcu_prod                     VARCHAR(500)     := '';
		v_auxcont						BIGINT				:=0;
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
        v_vlr_subtotal          numeric(1000,10) := 0;
        --
        --Cursor con el cual obtengo los pagos que realizo el cliente para pagar su factura
        --
        c_creditos  CURSOR FOR
        SELECT sbcu_codigo, fpago_valor
          FROM FA_TFPAGO, co_tsbcu
         WHERE fpago_facom = p_facom_facom
           AND fpago_tsbcu = sbcu_sbcu
           ;
        --
        --Cursor en el cual obtengo la retencion en la fuente de 
        --
        c_retefuente CURSOR FOR
        select facom_vlret
          from fa_tfacom
         where facom_facom = p_facom_facom
         ;
        --
        v_vlr_retefuente            numeric(1000,10) := 0;
        --
        v_rta_insrt_kar             varchar(1000):= '';
        --
        c_mvin CURSOR FOR
        SELECT mvin_mvin
          FROM in_tmvin
         WHERE MVIN_CODIGO = 'INFC'
         ;
        --
        v_mvin_mvin                     bigint:=0;
        v_ajustepeso                    varchar(2) :='';
        v_valorajuste                   numeric(1000,10) :=0;
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
        --Cursor necesario para la realizacion de los movimientos contables
        --
        c_movi_cont CURSOR (vc_idTrans  bigint)FOR
        SELECT sbcu_sbcu,cast(tem_mvco_valor as numeric) valor,tem_mvco_naturaleza natu
          FROM co_ttem_mvco, co_tsbcu
         WHERE tem_mvco_sbcu = sbcu_codigo
           AND tem_mvco_trans = vc_idTrans
           ;
        --
        -- Obtiene el identificador del tipo de documento 
        --
        c_id_ttido CURSOR FOR
        SELECT tido_tido
          FROM co_ttido
         WHERE upper(tido_nombre) = 'FACTCOMPRA'
        ; 
        --
        v_tipoDocumento     BIGINT := 0;
        --
        c_valida_rtfte CURSOR FOR
        SELECT count(*)
          FROM co_tsbcu
         WHERE sbcu_codigo = '236501'
         ;
        --
        --
        --Cursor el cual verifica si existe la subcuenta para los ajustes al peso
        --
        c_ajustePeso CURSOR FOR
        SELECT count(*)
        FROM co_tsbcu
        WHERE sbcu_codigo = '429581'
        ;
        --
        v_valida_rtft   bigint:= 0;
        v_valida_basica varchar(4000) :='';
        v_val_ajustepeso            BIGINT :=0;
        --
    BEGIN
        --
        OPEN c_ajustePeso;
        FETCH c_ajustePeso INTO v_val_ajustepeso;
        CLOSE c_ajustePeso;
        --
        IF v_val_ajustepeso <> 1 THEN
            --
            RAISE EXCEPTION 'Error cuenta de ajuste al peso 429581 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
            --
        END IF;
        --
        OPEN c_estado;
        FETCH c_estado INTO v_estado;
        CLOSE c_estado;
        --
        IF v_estado = 'F' THEN
            --
            raise exception 'La factura que intenta ingresar ya ha sido ingresada anteriormente ingrese por favor realice el ingreso desde NSIGEMCO ';
            --
        END IF;
        --
        OPEN c_valida_rtfte;
        FETCH c_valida_rtfte INTO v_valida_rtft;
        CLOSE c_valida_rtfte;
        --
        IF v_valida_rtft = 0 THEN
            --
            RAISE EXCEPTION ' POR FAVOR INGRESE LA SUBCUENTA 236501 ENCARGADA DE ALMACENAR LA RETENCION EN LA FUENTE E INTENTE DE NUEVO';
            --
        END IF;
        --
        open c_mvin;
        fetch c_mvin into v_mvin_mvin;
        close c_mvin;
        --
        OPEN c_sec_contabilidad;
        FETCH c_sec_contabilidad INTO v_sec_cont;
        CLOSE c_sec_contabilidad;
        --
        v_aux := 100.00;
        --
        FOR prod IN c_facCom LOOP
            --
			--raise exception 'tius %',prod.facom_tius;
			--
            v_proveedor := prod.facom_tprov;
            --
            v_vlr_iva_total := v_vlr_iva_total + ((prod.fcprd_piva*(prod.fcprd_subt*prod.fcprd_cant))/v_aux);
            --
            v_vlr_subtotal := v_vlr_subtotal + prod.fcprd_subt;
            
            v_ajustepeso :=prod.facom_ajus;
            --
            OPEN c_sbcu_prod(prod.fcprd_dska);
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
                    (prod.fcprd_subt*prod.fcprd_cant), 
                    'D')
                    ;
            --
            --Insertamos el kardex de productos
            --
            v_rta_insrt_kar := IN_FINSERTA_PROD_KARDEX(prod.fcprd_dska,
                                                   v_mvin_mvin,
                                                   prod.facom_tius,
                                                   prod.fcprd_cant,
                                                   prod.fcprd_subt*prod.fcprd_cant,
                                                   prod.facom_sede                                                   
                                                   );
            --
            IF upper(v_rta_insrt_kar) NOT LIKE '%OK%' THEN
                --
                raise exception ' factura de compra % ',v_rta_insrt_kar;
                --
            END IF;
            --
        END LOOP;
        --
        FOR pagos IN c_creditos LOOP
            --
            INSERT INTO co_ttem_mvco(
                                            tem_mvco_trans, 
                                            tem_mvco_sbcu, 
                                            tem_mvco_valor, 
                                            tem_mvco_naturaleza)
                    VALUES (v_sec_cont,
                            pagos.sbcu_codigo, 
                            pagos.fpago_valor, 
                            'C');
            --
        END LOOP;
        --
        open c_retefuente;
        fetch c_retefuente into v_vlr_retefuente;
        close c_retefuente;
        --
        INSERT INTO co_ttem_mvco(
                                tem_mvco_trans, 
                                tem_mvco_sbcu, 
                                tem_mvco_valor, 
                                tem_mvco_naturaleza)
                    VALUES (v_sec_cont,
                            '240801', 
                            v_vlr_iva_total, 
                            'D');
        --
        IF v_vlr_retefuente <> 0 THEN
            --
            INSERT INTO co_ttem_mvco(
                                tem_mvco_trans, 
                                tem_mvco_sbcu, 
                                tem_mvco_valor, 
                                tem_mvco_naturaleza)
                    VALUES (v_sec_cont,
                            '236501', 
                            v_vlr_retefuente, 
                            'C');
            --
        END IF;
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
        IF v_ajustepeso = 'S' AND v_creditos <> v_debitos THEN 
            --
            v_valorajuste := v_creditos - v_debitos;
            --
            IF v_valorajuste > 0 THEN
                --
                INSERT INTO co_ttem_mvco(
                        tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                            VALUES (v_sec_cont, '429581' , v_valorajuste, 'D');
                --
            ELSE
                --
                INSERT INTO co_ttem_mvco(
                        tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                            VALUES (v_sec_cont, '429581' , ((v_valorajuste)*-1), 'C');
                --
            END IF;            
        --
        END IF;
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
			v_auxcont := CO_BUSCA_AUXILIAR_X_TIDO(movi.sbcu_sbcu,'facom');
                INSERT INTO co_tmvco(mvco_trans, 
                             mvco_sbcu, mvco_naturaleza, 
                             mvco_tido, mvco_valor, 
                             mvco_lladetalle, mvco_id_llave, 
                             mvco_tercero, mvco_tipo,mvco_auco)
                        VALUES ( v_sec_cont, 
                              movi.sbcu_sbcu , movi.natu, 
                              v_tipoDocumento, movi.valor,
                              'fctc', p_facom_facom,
                              v_proveedor, 2,v_auxcont);
                --
            END LOOP;
            --
        ELSE          
            RAISE EXCEPTION 'La suma de los debitos: % y los creditos: % no coinciden.', v_creditos,  v_debitos;
        END IF;
        --        
        DELETE FROM co_ttem_mvco
        WHERE tem_mvco_trans = v_sec_cont;
        --
        UPDATE fa_tfacom
           SET facom_estad = 'F'
         WHERE facom_facom = p_facom_facom
         ;
        --
        RETURN 'Ok';
        --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_REGISTRA_FACT_COMPRA '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';