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
	SELECT factMIG_fact,factMIG_tius,factMIG_fec_ini,factMIG_clien,factMIG_vlr_total,factMIG_vlr_iva,factMIG_sede,
	factMIG_retefun,factMIG_vlrrtfu,factMIG_ajpeso
	FROM FA_TFACMIG where factMIG_fact = 2555;
	--
	--cursor con el cual obtengo los datos de los productos
	--
	c_cons_prod_migt CURSOR (v_fact_fact BIGINT)  IS
	SELECT dtprMIG_dska,dtprMIG_cant,dtprMIG_vlr_uni_prod,dtprMIG_vlr_iva_uni,dtprMIG_vlr_venta_tot,dtprMIG_vlr_iva_tot,dtprMIG_vlr_total,dtprMIG_utilidad	
	FROM fa_tdtprMIG 
	WHERE dtprMIG_fact = v_fact_fact;
	--
	--
    --Cursor con el cual obtenemos el valor total del iva de la factura
    --
    c_vlr_iva_fact CURSOR(vc_fact_fact INT) FOR
    SELECT fact_vlr_iva
      FROM fa_tfact
     WHERE fact_fact = vc_fact_fact
     ;
    --
    --Cursor con el cual obtnemos el valor de la factura sin iva
    --
    c_vlr_total_fact_sin_iva CURSOR(vc_fact_fact INT) FOR
    SELECT fact_vlr_total 
      FROM fa_tfact
     WHERE fact_fact = vc_fact_fact
     ;
    --
    --Cursor con el cual se obtiene el id de la subcuenta de la caja menor
    --
    c_sbcu_caja CURSOR  (p_sede BIGINT) FOR
    SELECT sbcu_codigo
      FROM em_tsede, co_tsbcu
     WHERE sede_sede = p_sede
       AND sbcu_sbcu = sede_sbcu_caja
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
	--variables
	v_idTrans_con           BIGINT := 0;
	v_rta_fact_prod			VARCHAR(500)='';
	v_valor_iva_fact        NUMERIC(1000,10) := 0;
    v_vlr_total_factura     NUMERIC(1000,10) := 0;
    v_vlr_total_fact_co     NUMERIC(1000,10) := 0;
    --
    --Variables utilizadas para los valores principales de facturacion
    --
    v_vlr_total     NUMERIC(1000,10)  :=0;
    v_vlr_iva       NUMERIC(1000,10)  :=0;
    v_vlr_retfuente NUMERIC(1000,10)  :=0;
    v_sbcu_caja_cod     varchar(10):= '';
    v_valida            varchar(4000) := '';
    --
    --Variables necesarias para la validacion de subcuentas
    --
    v_val_iva_generado          bigint :=0;
    v_val_costo_ventas          bigint :=0;
    v_val_mercancias_mm         bigint :=0;
    v_val_descuentos            bigint :=0;
    v_val_caja_menor            bigint :=0;
    v_sum_deb               NUMERIC(1000,10):=0;
    v_sum_cre               NUMERIC(1000,10):=0;
    v_sbcu_sbcu             BIGINT := 0;
	v_valida_basica         varchar(4000)   := '';
		BEGIN
		

		 FOR fact IN c_cons_fact_migr
		 LOOP
		 	--
			--Insertar facturas
			INSERT INTO FA_TFACT(fact_fact		   ,  fact_tius	    		,  fact_fec_ini		   , 
								fact_clien		   , fact_vlr_total		   	, fact_vlr_iva,
								fact_sede		   ,fact_retefun 			,fact_vlrrtfu)
                     VALUES (	fact.factMIG_fact  , fact.factMIG_tius      ,  fact.factMIG_fec_ini, 
								fact.factMIG_clien , fact.factMIG_vlr_total , fact.factMIG_vlr_iva,
								fact.factMIG_sede  ,fact.factMIG_retefun       ,fact.factMIG_vlrrtfu	 )
							;
			v_valida_basica := FA_VAL_CON_FACTU(fact.factMIG_sede);	
			IF UPPER(v_valida_basica) <> 'OK' THEN
				--
				RAISE EXCEPTION ' %', v_valida_basica;
				--
			END IF;			
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
                                                fact.factMIG_sede,
                                                prod.dtprMIG_cant,
                                                v_idTrans_con,
                                                cast(fact.factMIG_fact as int),
                                                prod.dtprMIG_vlr_uni_prod,
                                                prod.dtprMIG_vlr_iva_tot,
                                                prod.dtprMIG_vlr_iva_uni,
                                                prod.dtprMIG_vlr_total,
                                                prod.dtprMIG_vlr_total,
                                                prod.dtprMIG_utilidad	
                                                );
			END LOOP;
			IF v_rta_fact_prod = 'OK' THEN

			OPEN c_vlr_iva_fact(cast(fact.factMIG_fact as int));
		    FETCH c_vlr_iva_fact INTO v_valor_iva_fact;  
		    CLOSE c_vlr_iva_fact;

		     INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
		    VALUES (v_idTrans_con, '240802' , v_valor_iva_fact , 'C');
		    --


		    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    		VALUES (v_idTrans_con, '413535' , v_vlr_total_factura , 'C');

    		--
		    --Logica para que el dinero valla directo a la caja menor
		    --
		    OPEN c_sbcu_caja(fact.factMIG_sede);
		    FETCH c_sbcu_caja INTO v_sbcu_caja_cod;
		    CLOSE c_sbcu_caja;

		    IF fact.factMIG_retefun = 'S' THEN
		    --
		    --inserta movimiento contable de retefuente
		    --
		     INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                     VALUES (v_idTrans_con, '135515' , fact.factMIG_vlrrtfu, 'D');
	        --
	        --actualiza la factura la retefuente
	        --
	        UPDATE FA_TFACT
	           SET FACT_RETEFUN = 'S',
	           FACT_VLRRTFU = v_vlr_retfuente
	         WHERE fact_fact = fact.factMIG_fact
	         ;

		    END IF;

		    IF fact.factMIG_ajpeso <> 0 THEN
		    	  INSERT INTO co_ttem_mvco(
            	  tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                  VALUES (v_idTrans_con, '429581' , fact.factMIG_ajpeso, 'C');
		    END IF;

		        INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                     VALUES (v_idTrans_con, v_sbcu_caja_cod , fact.factMIG_vlr_total, 'D');

		    UPDATE fa_tfact
		    SET fact_vlr_efectivo =  fact.factMIG_vlr_total,
		    fact_ajpeso = fact.factMIG_ajpeso
		    WHERE fact_fact = fact.factMIG_fact ;

		  	OPEN c_sum_debitos(v_idTrans_con);
		    FETCH c_sum_debitos INTO v_sum_deb;
		    CLOSE c_sum_debitos;
		    --
		    OPEN c_sum_creditos(v_idTrans_con);
		    FETCH c_sum_creditos INTO v_sum_cre;
		    CLOSE c_sum_creditos;

		    IF v_sum_deb = v_sum_cre THEN
		       FOR movi IN c_sbcu_factura(v_idTrans_con) 
		       LOOP
		       		  OPEN c_sbcu_sbcu(movi.tem_mvco_sbcu);
			          FETCH c_sbcu_sbcu INTO v_sbcu_sbcu;
			          CLOSE c_sbcu_sbcu;

			     INSERT INTO co_tmvco(mvco_trans, 
                                 mvco_sbcu, mvco_naturaleza, 
                                 mvco_tido, mvco_valor, 
                                 mvco_lladetalle, mvco_id_llave, 
                                 mvco_tercero, mvco_tipo)
                VALUES ( v_idTrans_con, 
                         v_sbcu_sbcu , movi.tem_mvco_naturaleza, 
                         2, cast(movi.tem_mvco_valor as NUMERIC),
                         'fact', fact.factMIG_fact,
                         p_clien, p_clien );      

		    	END LOOP;
			 ELSE
			        --
			        RAISE EXCEPTION 'Las sumas de las cuentas al facturar no coinciden por favor contactese con el administrador Debitos %, Creditos %',v_sum_deb,v_sum_cre;
		    END IF;   
    --   
    	 --
    v_valida := FA_ASIGNA_RESOLUCION_FACTURA(cast(fact.factMIG_fact as BIGINT),-1);
    --
    IF upper(v_valida) <> 'OK' THEN
        --
        RAISE EXCEPTION ' Error al encontrar la resolucion de facturacion % ',v_valida;
        --
    END IF;	
	ELSE
	RAISE EXCEPTION '%',v_rta_fact_prod;
	END IF;
		 
		 END LOOP;

    --
        RETURN 'Ok-'||cast(fact.factMIG_fact as BIGINT);	
	
		EXCEPTION WHEN OTHERS THEN
			 RETURN 'Error FN_MIGRACION_77 '|| sqlerrm;
		END;
$$ LANGUAGE 'plpgsql';
	
	
	