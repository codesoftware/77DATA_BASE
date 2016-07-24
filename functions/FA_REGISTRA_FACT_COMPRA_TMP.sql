--
--Funcion encargada de verificar la facura de compra temporal
--
CREATE OR REPLACE FUNCTION FA_REGISTRA_FACT_COMPRA_TMP(
                            p_idfac_tmp            BIGINT
                            ) RETURNS VARCHAR AS $$
    DECLARE
    v_valajus                NUMERIC(1000,10) :=0;
    v_parajus                NUMERIC(1000,10) :=0;
    v_funcion                VARCHAR(1000):= '';
    v_cbretedf                VARCHAR(1000):= '';
    v_ajus                    VARCHAR(1000):='N';
    v_consec                  BIGINT   :=0;
    v_valorf                NUMERIC(1000,10):=0;
    v_plazo                    BIGINT    :=0;
    v_tius                     varchar := 0 ;
    v_cdsbc                    BIGINT    :=0;

    --
    --Cursor que consulta el valor parametrizado del valor ajuste al peso
    --
    c_consulta_ajuste CURSOR IS
    select CAST(PARA_VALOR AS NUMERIC)
    FROM EM_TPARA 
    WHERE PARA_CLAVE = 'VALORAJUSTEPESO';
    
    
    --
    --Cursor que consulta los datos de la factura de compra temporal
    --
    c_traedatos_fact CURSOR IS
    select facom_tmp_vlraj,facom_tmp_cbret,facom_tmp_valor,facom_tmp_plaz
    FROM fa_tfacom_tmp WHERE
    facom_tmp_facom = p_idfac_tmp;
    --

    --
    --Cursor que valida si la subcuenta de cuentas por pagar exista
    --
    c_validasubxpagar CURSOR IS
    SELECT COALESCE(sbcu_sbcu,0)
    FROM co_tsbcu
    WHERE sbcu_codigo = '233501';
    --
    v_val_proc              varchar(1000):= '';
    --
    BEGIN 
    --llama la funcion que actualiza los parametros
    v_funcion := FA_CALCULA_PAGOS_FAC_COMPRA(p_idfac_tmp);
    
    OPEN c_consulta_ajuste;
    FETCH c_consulta_ajuste INTO v_parajus;
    CLOSE c_consulta_ajuste;
    
    OPEN c_validasubxpagar;
    FETCH c_validasubxpagar INTO v_cdsbc;
    CLOSE c_validasubxpagar;
    
    OPEN c_traedatos_fact;
    FETCH c_traedatos_fact INTO v_valajus,v_cbretedf,v_valorf,v_plazo;
    CLOSE c_traedatos_fact;    
    
    IF v_cdsbc = 0 THEN
        RAISE EXCEPTION 'Error: no existe la subcuenta de cuentas por pagar  233501';
    END IF;
    --verifica si se realiza cobro de retefuente, si no , deja ese valor en 0

    IF v_cbretedf IS NULL OR v_cbretedf='N'  THEN 
        
         UPDATE fa_tfacom_tmp
         SET facom_tmp_vlret = 0
         WHERE 
         facom_tmp_facom = p_idfac_tmp;
    
    END IF;
    
    IF v_funcion = 'OK' THEN
        --
        -- verifica si realiza correctamente los calculos 
        --
        IF v_valajus > 0 then
                IF (v_valajus - v_parajus) > 0 THEN
                    RAISE EXCEPTION 'El valor del ajuste al peso supera el valor parametrizado %',v_parajus;
                END IF;
            
        ELSIF v_valajus < 0 THEN
            IF (v_valajus + v_parajus) < 0 THEN
                RAISE EXCEPTION 'El valor del ajuste al peso supera el valor parametrizado %',(v_parajus*-1);
            END IF;
        END IF;

        IF v_valajus BETWEEN (v_parajus*-1) AND v_parajus OR v_valajus=0.0  THEN 
            
            IF v_valajus <> 0 then
            v_ajus := 'S';    
            END IF;
            
            v_consec := nextval('fa_tfacom_facom_facom_seq'::regclass);
        
            INSERT INTO FA_TFACOM (    FACOM_FACOM,    FACOM_FECHA,    FACOM_FEREC,    FACOM_NUFAC,
                                    FACOM_VALOR,    FACOM_VLIVA,    FACOM_VLRET,
                                    FACOM_TPROV,    FACOM_ESTAD,    FACOM_TIUS,        FACOM_PLAZ,
                                    FACOM_SEDE,        FACOM_FECRE,    FACOM_AJUS,        FACOM_RTIMG)
                            SELECT     v_consec,        FACOM_TMP_FECHA,FACOM_TMP_FEREC,FACOM_TMP_NUFAC,
                                    (FACOM_TMP_VALOR-FACOM_TMP_VLIVA-FACOM_TMP_VLRET),FACOM_TMP_VLIVA,FACOM_TMP_VLRET,
                                    FACOM_TMP_TPROV,'C',            FACOM_TMP_TIUS,    FACOM_TMP_PLAZ,
                                    FACOM_TMP_SEDE,    now(),            v_ajus,            ' ' 
                             FROM FA_TFACOM_TMP 
                             WHERE     facom_tmp_facom = p_idfac_tmp
                             ;
            
            INSERT INTO FA_TFCPRD (FCPRD_FACOM,FCPRD_DSKA,FCPRD_CANT,FCPRD_SUBT,FCPRD_IVA,FCPRD_PIVA,FCPRD_TOTA,FCPRD_ESTA,FCPRD_FECH)
            SELECT v_consec,FCPRD_TMP_DSKA,FCPRD_TMP_CANT,FCPRD_TMP_SUBT,FCPRD_TMP_IVA,FCPRD_TMP_PIVA,FCPRD_TMP_TOTA,'A',NOW() FROM FA_TFCPRD_TMP
            WHERE FCPRD_TMP_FACOM = p_idfac_tmp;
            

            
            INSERT INTO FA_TFPAGO(FPAGO_FACOM,FPAGO_TPAGO,FPAGO_VALOR,FPAGO_TSBCU,FPAGO_FECHA,FPAGO_ESTAD,FA_DPAGO)
                        VALUES   (v_consec,    'Credito'      ,v_valorf     ,    v_cdsbc ,        NOW(),'A', v_plazo); 
                        
            --
            --Elimina los datos de la factura temporal
            
                        
            DELETE FROM FA_TFCPRD_TMP
            WHERE FCPRD_TMP_FACOM = p_idfac_tmp;
            --
            DELETE FROM FA_TFACOM_TMP
            WHERE facom_tmp_facom = p_idfac_tmp;
            --
            v_val_proc := FA_REGISTRA_FACT_COMPRA(v_consec);
            --
            IF UPPER(v_val_proc) <> 'OK' THEN
                --
                RAISE EXCEPTION ' Error % ', v_val_proc;
                --
            END IF;
            
            RETURN v_val_proc;
            --
        ELSE
            --
            RAISE EXCEPTION 'Error, los pagos no coinciden, verifique en el boton ver detalle';
            --
        END IF;
        --
    ELSE 
        --
        RAISE EXCEPTION 'Error %',v_funcion;
        --
    END IF;
    --
    RETURN 'OK';
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_REGISTRA_FACT_COMPRA_TMP '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';