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
		v_aplicar				VARCHAR(2):='';
		v_valorfa				NUMERIC(1000,10):=0;
		v_valajup				NUMERIC(1000,10):=0;
		v_valajfa				NUMERIC(1000,10):=0;
		v_cobrete				VARCHAR(2):='';
		
		--
		--Cursor que consulta el valor de los productos 
		--
		c_consultavalor_prd CURSOR FOR
		SELECT fcprd_tmp_subt,fcprd_tmp_piva,fcprd_tmp_cant
		FROM fa_tfcprd_tmp 
		WHERE fcprd_tmp_facom = p_facom_facom;
		
		--
		--Cursor que consulta los datos de la factura de compra
		--
		
		c_datos_fact CURSOR IS
		SELECT facom_tmp_porc,facom_tmp_valor,facom_tmp_cbret
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
		FETCH c_datos_fact INTO v_porcret,v_valorfa,v_cobrete;
		CLOSE c_datos_fact;
		
		OPEN c_consulta_prov;
		FETCH c_consulta_prov INTO v_baseret,v_aplicar;
		CLOSE c_consulta_prov;
		
		FOR prod IN c_consultavalor_prd LOOP
			v_subtotal := v_subtotal+(prod.fcprd_tmp_subt*prod.fcprd_tmp_cant);
			v_iva	:=v_iva+((prod.fcprd_tmp_piva /100::numeric)*prod.fcprd_tmp_subt*prod.fcprd_tmp_cant);
		END LOOP;

		v_retefuen  := (v_porcret/100::numeric)*v_subtotal;

		IF v_cobrete <>'S' THEN
		v_total 	:= v_subtotal+v_iva-v_retefuen;
		ELSE
		v_total 	:= v_subtotal+v_iva;
		END IF;
		--
		--consulta el valor del ajuste al peso parametrizado			
 
		v_valajfa :=   v_valorfa -v_total;

		
		UPDATE fa_tfacom_tmp SET facom_tmp_vliva = v_iva,facom_tmp_vlret = v_retefuen,facom_tmp_vlpr = v_subtotal,
				facom_tmp_vltot = v_total,facom_tmp_vlraj=v_valajfa 
				WHERE facom_tmp_facom = p_facom_facom;
		
		
	RETURN 'OK';
	
	 EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_REGISTRA_FACT_COMPRA_TMP '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';