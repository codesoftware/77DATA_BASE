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
	c_cons_prod_migt CURSOR (v_fact_fact BIGINT)  IS
	SELECT dtprMIG_dska,dtprMIG_cant,dtprMIG_vlr_uni_prod,factMIG_vlr_iva,factMIG_vlr_total
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
    SELECT fact_vlr_total, 
      FROM fa_tfact
     WHERE fact_fact = vc_fact_fact
     ;
    --
    --Cursor con el cual se obtiene el id de la subcuenta de la caja menor
    --
    c_sbcu_caja CURSOR FOR
    SELECT sbcu_codigo
      FROM em_tsede, co_tsbcu
     WHERE sede_sede = p_sede
       AND sbcu_sbcu = sede_sbcu_caja
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
    --
    --Variables necesarias para la validacion de subcuentas
    --
    v_val_iva_generado          bigint :=0;
    v_val_costo_ventas          bigint :=0;
    v_val_mercancias_mm         bigint :=0;
    v_val_descuentos            bigint :=0;
    v_val_caja_menor            bigint :=0;
		BEGIN
		

		 FOR fact IN c_cons_fact_migr
		 LOOP
		 	--
			--Insertar facturas
			INSERT INTO FA_TFACT(fact_fact		   ,  fact_tius	    		,  fact_fec_ini		   , 
								fact_clien		   , fact_vlr_total		   	, fact_vlr_iva		   )
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
                                                prod.dtprMIG_vlr_uni_prod,
                                                prod.dtprMIG_vlr_iva_tot,
                                                prod.dtprMIG_vlr_iva_uni,
                                                prod.dtprMIG_vlr_total,
                                                prod.dtpr_vlr_venta_tot,
                                                prod.dtprMIG_utilidad	
                                                );
			END LOOP;

			OPEN c_vlr_iva_fact(cast(v_fact_fact as int));
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
		    OPEN c_sbcu_caja;
		    FETCH c_sbcu_caja INTO v_sbcu_caja_cod;
		    CLOSE c_sbcu_caja;		
		 
		 END LOOP;

    --
	
		EXCEPTION WHEN OTHERS THEN
			 RETURN 'Error FA_REGISTRA_FACT_COMPRA '|| sqlerrm;
		END;
$$ LANGUAGE 'plpgsql';
	
	
	