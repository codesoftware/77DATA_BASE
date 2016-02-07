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
        SELECT fcprd_cant, fcprd_subt, fcprd_dska, fcprd_piva
          FROM FA_TFACOM, fa_tfcprd
         WHERE facom_facom = fcprd_facom
           and fcprd_esta = 'A'
           and facom_facom = p_facom_facom
           ;
        --
        v_vlr_iva_total                 NUMERIC(1000,10):= 0;
        v_aux                           NUMERIC(1000,10):= 0;
        --
        v_sec_cont                      BIGINT :=0;
        --
        v_sbcu_prod                     VARCHAR(500)     := '';
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
    BEGIN
        --
        OPEN c_sec_contabilidad;
        FETCH c_sec_contabilidad INTO v_sec_cont;
        CLOSE c_sec_contabilidad;
        --
        v_aux := 100.00;
        --
        FOR prod IN c_facCom LOOP
            --
            v_vlr_iva_total := v_vlr_iva_total + ((prod.fcprd_piva*(prod.fcprd_subt*prod.fcprd_cant))/v_aux);
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
                    prod.fcprd_subt, 
                    'D')
                    ;
            
        END LOOP;
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
        RETURN 'Ok';
        --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';