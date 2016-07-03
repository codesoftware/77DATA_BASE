--
--Funcion encargada de verificar la facura de compra temporal
--
CREATE OR REPLACE FUNCTION FA_REGISTRA_FACT_COMPRA_TMP(
							p_idfac_tmp			BIGINT
							} RETURNS VARCHAR AS $$
	DECLARE
		--
		--Cursor que consulta el valor ingresado  de la factura 
		--
		c_consultavalor_fac CURSOR IS
		SELECT facom_tmp_valor
		FROM fa_tfacom_tmp
		WHERE facom_tmp_facom = p_idfac_tmp;
		--
		--Cursor que consulta el valor de los productos 
		--
		c_consultavalor_prd CURSOR FOR
		SELECT fcprd_tmp_subt,fcprd_tmp_piva,fcprd_tmp_cant
		FROM fa_tfcprd_tmp 
		WHERE fcprd_tmp_facom = p_idfac_tmp;

	BEGIN 
	
	RETURN 'OK';
	
	 EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_REGISTRA_FACT_COMPRA_TMP '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';