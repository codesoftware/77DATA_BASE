CREATE OR REPLACE FUNCTION FN_MIGRACION_77()
								RETURNS VARCHAR  AS $$
	DECLARE
	
	--
    --Cursor el cual sirve para obtener el id temporal de transaccion para la tabla temporal
    --de movimientos contables
    --
    c_sec_tem_mvco CURSOR FOR
    SELECT nextval('co_temp_movi_contables') 
    ;
	--
	--Cursor con el cual obtengo los datos de la factura de migracion
	--
	c_cons_fact_migr CURSOR FOR
	SELECT factMIG_fact,factMIG_tius,factMIG_fec_ini,factMIG_clien,factMIG_vlr_total,factMIG_vlr_iva,factMIG_sede
	FROM FA_TFACMIG;
	--
	--cursor con el cual obtengo los datos de los productos
	--
	c_cons_prod_migt(v_fact_fact BIGINT) CURSOR FOR
	SELECT dtprMIG_dska,dtprMIG_cant,dtprMIG_vlr_uni_prod
	FROM fa_tdtprMIG 
	WHERE dtprMIG_fact = v_fact_fact;
	--
	--variables
	v_idTrans_con           BIGINT := 0;
		BEGIN
		

		 FOR fact IN c_cons_fact_migr
		 LOOP
		 	--
			--Insertar facturas
			INSERT INTO FA_TFACT(fact_fact		   ,  fact_tius	    		,  fact_fec_ini		   , 
								fact_clien		   , fact_vlr_total		   	, fact_vlr_iva		   ,)
                     VALUES (	fact.factMIG_fact  , fact.factMIG_tius      ,  fact.factMIG_fec_ini, 
								fact.factMIG_clien , fact.factMIG_vlr_total , fac.factMIG_vlr_iva   )
							;
			--
			--Cursor con el cual obtengo el id de movimientos contables
			--
			OPEN c_sec_tem_mvco;
			FETCH c_sec_tem_mvco INTO v_idTrans_con;
			CLOSE c_sec_tem_mvco;				
			--
			--Recorre los productos de la factura			
			FOR prod IN  c_cons_prod_migt(fact.factMIG_fact)
			LOOP
				        v_rta_fact_prod := FN_FACTPROD_MIGRACION_77(
                                                fact.factMIG_tius,
                                                prod.dtprMIG_dska,
                                                fac.factMIG_sede,
                                                prod.dtprMIG_cant,
                                                v_idTrans_con,
                                                cast(fact.factMIG_fact as int),
                                                prod.dtprMIG_vlr_uni_prod
                                                );
			END LOOP;		
		 
		 END LOOP;
	
		EXCEPTION WHEN OTHERS THEN
			 RETURN 'Error FA_REGISTRA_FACT_COMPRA '|| sqlerrm;
		END;
$$ LANGUAGE 'plpgsql';
	
	
	