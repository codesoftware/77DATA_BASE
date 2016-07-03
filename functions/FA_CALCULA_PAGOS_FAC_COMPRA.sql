--
-- Funcion encargada de realizar el ingreso al inventario y la contabilizacion de los productos ya existentes en el sistema
--
CREATE OR REPLACE FUNCTION FA_CALCULA_PAGOS_FAC_COMPRA(  
                                                        p_facom_facom         BIGINT
                                                    ) RETURNS VARCHAR  AS $$
													
	DECLARE
		v_subtotal				NUMERIC(1000,10):=0;
		v_iva					NUMERIC(1000,10):=0;
		v_retefuen				NUMERIC(1000,10):=0;
		v_total					NUMERIC(1000,10):=0;
		v_porcret				NUMERIC(1000,10):=0;
		v_baseret				NUMERIC(1000,10):=0;
		v_aplicar				VARCHAR2(2):='';
		
		--
		--Cursor que consulta el valor de los productos 
		--
		c_consultavalor_prd CURSOR FOR
		SELECT fcprd_tmp_subt,fcprd_tmp_piva,fcprd_tmp_cant
		FROM fa_tfcprd_tmp 
		WHERE fcprd_tmp_facom = p_idfac_tmp;
		
		--
		--Cursor que consulta los datos de la factura de compra
		--
		
		c_datos_fact CURSOR IS
		SELECT facom_tmp_porc,facom_tmp_tprov
		FROM fa_tfacom_tmp
		WHERE facom_tmp_facom = p_facom_facom;
		
		--
		--Cursor que consulta la base de la retefuente 
		--
		c_consulta_prov	CURSOR IS
		SELECT COALESCE(retde_bpeso,0),prov_gcron
		FROM in_tprov,co_tretde,fa_tfacom_tmp
		WHERE facom_tmp_tprov = prov_prov
		AND prov_retde = retde_retde
		AND facom_tmp_facom= p_facom_facom;
		


	BEGIN 
	
		OPEN c_datos_fact;
		FETCH c_datos_fact INTO v_porcret;
		CLOSE c_datos_fact;
		
		OPEN c_consulta_prov;
		FETCH c_consulta_prov INTO v_baseret,v_aplicar;
		CLOSE c_consulta_prov;
		
		FOR prod IN c_consultavalor_prd LOOP
			v_subtotal := (v_subtotal+prod.fcprd_tmp_subt)*prod.fcprd_tmp_cant;
			v_iva	:=(v_iva+prod.fcprd_tmp_piva)*prod.fcprd_tmp_cant;
		END LOOP;
		IF v_aplicar = 'N'
			THEN
				v_retefuen  := v_porcret*v_subtotal;
			ELSE
				v_retefuen  :=0;
		END IF;
		
		v_total 	:= v_subtotal+v_iva-v_retefuen;
		
		
		
	RETURN 'OK';
	
	 EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_REGISTRA_FACT_COMPRA_TMP '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';