--
--Funcion con la cual se migra la informacion de las facturas de la base de datos 9777 a donde se corra esta funcion
--
CREATE OR REPLACE FUNCTION FN_MIGRACION_DATOS()
								RETURNS VARCHAR  AS $$
	DECLARE	
	--
	c_fact_dblink CURSOR FOR
	SELECT facturacion.*
    FROM dblink('dbname=Sigemco9777', 'SELECT fact_fact, fact_tius, fact_fec_ini, 
       fact_fec_cierre, fact_clien, fact_vlr_total, fact_vlr_iva, 
       fact_tipo_pago, fact_id_voucher,fact_cometarios, fact_estado, 
       fact_naturaleza, fact_devolucion, fact_original, fact_vlr_dcto, 
       fact_vlr_efectivo, fact_vlr_tarjeta, fact_cierre, fact_sede, 
       fact_pedi,fact_fechaex, fact_retefun, fact_vlrrtfu, 
       fact_ajpeso, fact_cons, fact_rsfa, fact_vlr_acobrar, 
       fact_vlr_abonos
		  FROM fa_tfact order by fact_fact;
		')
                AS facturacion(fact_fact bigint, fact_tius bigint,fact_fec_ini date, 
                fact_fec_cierre date,fact_clien bigint, fact_vlr_total numeric(1000,10),  fact_vlr_iva numeric(1000,10),
                fact_tipo_pago varchar(1),fact_id_voucher varchar(200),fact_cometarios varchar(1), fact_estado varchar(1),
                fact_naturaleza varchar(2), fact_devolucion varchar(1),  fact_original bigint,  fact_vlr_dcto numeric(1000,10), 
                fact_vlr_efectivo numeric(1000,10),fact_vlr_tarjeta numeric(1000,10),fact_cierre bigint,fact_sede bigint,
                fact_pedi bigint,fact_fechaex timestamp,fact_retefun varchar(200),fact_vlrrtfu numeric(1000,10),
                fact_ajpeso numeric(1000,10),fact_cons numeric(1000,10),fact_rsfa bigint,fact_vlr_acobrar numeric(1000,10),
                fact_vlr_abonos numeric(1000,10))
                ;
	--
	v_rta  	int := 0;
	--
	c_dtpr_dblink CURSOR FOR	
	SELECT productos.*
      FROM dblink('dbname=Sigemco9777', 'SELECT dtpr_dtpr, dtpr_dska, dtpr_fact, dtpr_fecha, dtpr_num_prod, dtpr_cant, 
       			dtpr_vlr_pr_tot, dtpr_vlr_uni_prod, dtpr_vlr_iva_tot, dtpr_vlr_iva_uni, 
       			dtpr_vlr_venta_tot, dtpr_vlr_venta_uni, dtpr_vlr_total, dtpr_desc, 
       			dtpr_con_desc, dtpr_valor_desc, dtpr_estado, dtpr_kapr, dtpr_dev_kapr, 
       			dtpr_utilidad, dska_cod_ext
       			FROM fa_tdtpr, in_tdska
       			where dtpr_dska = dska_dska;')
    as productos(dtpr_dtpr bigint, dtpr_dska bigint,dtpr_fact bigint, dtpr_fecha timestamp, dtpr_num_prod bigint,dtpr_cant bigint,
      dtpr_vlr_pr_tot numeric(50,6),dtpr_vlr_uni_prod numeric(50,6), dtpr_vlr_iva_tot numeric(50,6),dtpr_vlr_iva_uni numeric(50,6),
      dtpr_vlr_venta_tot numeric(50,6),dtpr_vlr_venta_uni numeric(50,6),dtpr_vlr_total numeric(50,6),dtpr_desc varchar(1),
      dtpr_con_desc varchar(1),dtpr_valor_desc numeric(50,6),dtpr_estado varchar(1),dtpr_kapr integer,dtpr_dev_kapr integer,
      dtpr_utilidad numeric(50,6),dska_cod_ext varchar(1000))
    ;
    --
    --Con el id del producto que se va ha migrar obtengo el codigo externo
    --
    c_dska_cod_ext CURSOR(vc_dska_dska bigint) FOR
    SELECT prod.* 
      FROM  dblink('dbname=Sigemco9777', 'select dska_cod_ext, dska_dska from in_tdska')
            as prod(dska_cod_ext varchar, dska_dska bigint)
     WHERE dska_dska = vc_dska_dska
    ;
    --
    v_dska_cod		varchar(400):='';
    --
    c_prod_migracion CURSOR FOR
    SELECT *
    FROM fa_tdtprMIG
    order by dtprmig_fact
    ;
    --
    c_valida_prod CURSOR(vc_dska_cod  varchar) FOR
    SELECT dska_dska,dska_cod_ext
      FROM in_tdska
     WHERE trim(upper(dska_cod_ext)) = trim(upper(vc_dska_cod))
     ;
    --
    v_dska_cod_destino 				varchar(1000) := '';
    --
    --Validacion adicional por si el producto no lo encuentra
    --
    c_val_prod_ad CURSOR(vc_dska_cod varchar) FOR
    select dska_dska 
      from in_tdska, in_tmarca
     where dska_marca = marca_marca
       and upper(dska_cod_ext) = upper(marca_nombre) ||'-'|| UPPER(vc_dska_cod)
        ;
    --
    --
    v_dska_destino   bigint;
    v_num_regis 	 bigint :=0;
    --
	BEGIN
	--
	--Borro los datos de la anterior migracion
	--
	delete from FA_TFACMIG;
	--
	delete from fa_tdtprMIG;
	--
	FOR item in c_fact_dblink LOOP
		--
		INSERT INTO FA_TFACMIG (factMIG_fact, 		factMIG_tius, 		factMIG_fec_ini, 	factMIG_fec_cierre, 
								factMIG_clien, 		factMIG_vlr_total, 	factMIG_vlr_iva, 	factMIG_tipo_pago, 
								factMIG_id_voucher, factMIG_cometarios, factMIG_estado,		factMIG_naturaleza, 
								factMIG_devolucion, factMIG_original,  	factMIG_vlr_dcto, 	factMIG_vlr_efectivo, 
								factMIG_vlr_tarjeta,factMIG_cierre, 	factMIG_sede,		factMIG_pedi, 
								factMIG_fechaex, 	factMIG_retefun, 	factMIG_vlrrtfu, 	factMIG_ajpeso, 
								factMIG_cons,	  	factMIG_rsfa, 		factMIG_vlr_acobrar,factMIG_vlr_abonos) 
						VALUES (item.fact_fact, 	item.fact_tius,  	item.fact_fec_ini,  item.fact_fec_cierre,
								item.fact_clien,    item.fact_vlr_total,item.fact_vlr_iva,  item.fact_tipo_pago,
								item.fact_id_voucher,item.fact_cometarios,item.fact_estado, item.fact_naturaleza,
								item.fact_devolucion,item.fact_original,item.fact_vlr_dcto, item.fact_vlr_efectivo,
								item.fact_vlr_tarjeta,item.fact_cierre ,item.fact_sede 	  , item.fact_pedi,
								item.fact_fechaex   ,item.fact_retefun ,item.fact_vlrrtfu , item.fact_ajpeso,
								item.fact_cons      ,item.fact_rsfa    ,item.fact_vlr_acobrar,item.fact_vlr_abonos );
		--
	END LOOP;
	--
	--Creo logica para los items de los productos de las facturas
	--
	FOR item in c_dtpr_dblink LOOP
		--
		INSERT INTO fa_tdtprMIG (	dtprMIG_dtpr, 			dtprMIG_dska, 			dtprMIG_fact, 			dtprMIG_fecha, 
									dtprMIG_num_prod, 		dtprMIG_cant, 			dtprMIG_vlr_pr_tot, 	dtprMIG_vlr_uni_prod, 
									dtprMIG_vlr_iva_tot, 	dtprMIG_vlr_iva_uni, 	dtprMIG_vlr_venta_tot, 	dtprMIG_vlr_venta_uni,
									dtprMIG_vlr_total, 		dtprMIG_desc, 			dtprMIG_con_desc, 		dtprMIG_valor_desc, 
									dtprMIG_estado, 		dtprMIG_kapr, 			dtprMIG_dev_kapr, 		dtprMIG_utilidad,
									dtprMIG_cod_ext) 
					     VALUES (	item.dtpr_dtpr, 		item.dtpr_dska, 		item.dtpr_fact, 		item.dtpr_fecha, 
									item.dtpr_num_prod, 	item.dtpr_cant, 		item.dtpr_vlr_pr_tot, 	item.dtpr_vlr_uni_prod, 
									item.dtpr_vlr_iva_tot, 	item.dtpr_vlr_iva_uni, 	item.dtpr_vlr_venta_tot,item.dtpr_vlr_venta_uni,
									item.dtpr_vlr_total, 	item.dtpr_desc, 		item.dtpr_con_desc, 	item.dtpr_valor_desc, 
									item.dtpr_estado, 		item.dtpr_kapr, 		item.dtpr_dev_kapr, 	item.dtpr_utilidad,
									item.dska_cod_ext);
		--
	END LOOP;
	--
	FOR item in c_prod_migracion LOOP
		--
		OPEN c_dska_cod_ext(item.dtprMIG_dska);
		FETCH c_dska_cod_ext INTO v_dska_cod;
		CLOSE c_dska_cod_ext;
		--
		--raise exception 'Codigo 9777 % ', v_dska_cod;
		--
		OPEN c_valida_prod(v_dska_cod);
		FETCH c_valida_prod INTO v_dska_destino, v_dska_cod_destino;
		CLOSE c_valida_prod;
		--
		v_num_regis := v_num_regis + 1;
		--
		IF v_dska_cod <> v_dska_cod_destino THEN
			--
			RAISE EXCEPTION 'Los codigos de los productos no conciden codigo origen: % codigo destino % ',v_dska_cod, v_dska_cod_destino;
			--
		END IF;
		--
		IF v_dska_destino <> item.dtprMIG_dska then
			--
			update fa_tdtprMIG
			   set dtprMIG_dska = v_dska_destino
			 where dtprMIG_dtpr = item.dtprMIG_dtpr
			   and dtprMIG_fact = item.dtprMIG_fact
			   ;
			--
		end if;
		--
		IF v_dska_destino is null THEN
			--
			--raise exception 'Codigo 9777 v_dska_cod: % item.dtprMIG_fact % ' , v_dska_cod, item.dtprMIG_fact;
			--
			OPEN c_val_prod_ad(v_dska_cod);
			FETCH c_val_prod_ad INTO v_dska_destino;
			CLOSE c_val_prod_ad;
			--
			IF v_dska_destino is null THEN
				--
				RAISE EXCEPTION 'El producto con el codigo externo en la base de datos que va a migrar no existe % en el ',v_dska_cod; 
				--
			END IF;
			--
			update fa_tdtprMIG
			   set dtprMIG_dska = v_dska_destino
			 where dtprMIG_dtpr = item.dtprMIG_dtpr
			   and dtprMIG_fact = item.dtprMIG_fact
			   ;
			--
			v_rta := v_rta +1;
			--
		END IF;
		--
	END LOOP;
	--
	RETURN 'Ok-' || v_rta || ' numero de registros validados por el codigo: ' || v_num_regis;
	--
	EXCEPTION 
		WHEN OTHERS THEN
		--
			 RETURN 'Error FN_MIGRACION_DATOS '|| sqlerrm;
		--
	END;
$$ LANGUAGE 'plpgsql';