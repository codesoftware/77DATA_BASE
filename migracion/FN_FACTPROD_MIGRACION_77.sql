--
-- Funcion encargada de realizar toda la facturacion del sistema
--
CREATE OR REPLACE FUNCTION FN_FACTPROD_MIGRACION_77(  
                                                p_tius          BIGINT,        --Id del usuario que esta registrando la venta del producto
                                                p_dska          BIGINT,        --Id del producto que se esta vendiendo
                                                p_sede          BIGINT,        --Sede en la cual se esta vendiendo el producto
                                                p_cantidad      BIGINT,        --Cantidad de productos que se vendieron
                                                p_idmvco        BIGINT,        --Id de los movimientos contables que generar la transaccion
                                                p_fact          BIGINT,        --Id de facturacion 
                                                p_precio        NUMERIC(1000,10),
                                                v_vlr_iva_tot   NUMERIC(1000,10),
                                                v_vlr_iva_uni   NUMERIC(1000,10),
                                                v_vlr_uni_fact   NUMERIC(1000,10),
                                                v_vlr_tot_fact_iva  NUMERIC(1000,10),
                                                v_utilidad_prod     NUMERIC(1000,10)

                                            ) RETURNS VARCHAR  AS $$
	DECLARE
	    --
    
    v_existencias           NUMERIC(1000,10) := 0;
    v_exis_total            NUMERIC(1000,10) := 0;
    v_valida_ex             VARCHAR(1000):='';
    v_iva_precio            NUMERIC(1000,10) := 0;
    v_auxiliar              NUMERIC(1000,10) := 100.000;
    v_mvin_mvin             INT :=0;
    v_val_mvin_fact         INT := 0;
    v_kapr_kapr             NUMERIC(1000,10)  :=0;
    v_rta_insrt_kar         VARCHAR(500) := '';
    v_dtpr_dtpr             NUMERIC(1000,10);
    v_vlr_prom_pond         NUMERIC(1000,10)   := 0;
    v_vlr_prom_pond_tot     NUMERIC(1000,10) := 0;
    v_sbcu_cod_prod         varchar(100) := '';

    --
    --Cursor con el cual obtengo las existencias de la sede
    --
    c_exit_x_sede CURSOR IS
    SELECT eprs_existencia
      FROM in_teprs
     WHERE eprs_dska = p_dska
       AND eprs_sede = p_sede
       ;
    --
    --Cursor con el cual obtengo las existencias totales de un producto
    --
    c_exist_total CURSOR IS
    SELECT cepr_existencia
      FROM in_tcepr
     WHERE cepr_dska = p_dska
     ;

    --
    --Cursor que obtiene el iva parametrizado
    --
    c_iva_precio CURSOR IS
    SELECT cast(para_valor as numeric)
      FROM em_tpara
     WHERE para_clave = 'IVAPRVENTA'
    ;

    --
    --Moviento de inventario parametrizado para la venta de productos
    --
    c_mvin_venta CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_venta = 'S'
     ;
    --  
    --Valida si el movimiento de inventario para facturacion esta parametrizado
    --
    c_valida_movi_fact CURSOR FOR
    SELECT count(*)
      FROM in_tmvin
     WHERE mvin_venta = 'S'
     ;
    --
    -- Cursor con el cual encuentro el id del movimiento de inventario
    --
    c_kapr_kapr CURSOR (vc_expresion varchar) IS
    SELECT cast(kapr_kapr as int)
      FROM (
           SELECT regexp_split_to_table(vc_expresion, '-') kapr_kapr
           offset 1) as tabla
    ;
    --
    --Cursor con el cual obtengo el id de la tabla fa_tdtpr (Detalles de facturacion de productos)
    --
    c_dtpr_dtpr CURSOR FOR
    SELECT coalesce(max(dtpr_dtpr),0) + 1
      from fa_tdtpr
    ;

     --
    --Cursor con el cual obtengo el valor del promedio pornderado del producto
    --
    c_prom_pond_prod CURSOR(vc_dska_dska INT) IS
    SELECT kapr_cost_mvto_uni, kapr_cant_saldo,kapr_cost_saldo_tot 
    --SELECT kapr_cost_saldo_uni, kapr_cant_saldo,kapr_cost_saldo_tot -- Se cambia por que en el caso de que se venda la ultima existencia todos los valores daran en ceros
      FROM in_tkapr
     WHERE kapr_kapr = (select max(kapr_kapr) from in_tkapr where kapr_dska = vc_dska_dska)
    ;
    --
    --Obtiene el codico de la subcuenta para un producto
    --
    c_cod_sbcu CURSOR (vc_dska_dska  INT) IS
    SELECT sbcu_codigo
      FROM co_tsbcu, in_tdska
     WHERE dska_dska = vc_dska_dska
       AND sbcu_sbcu = dska_sbcu
     ;     

	
	BEGIN
	
    OPEN c_exit_x_sede;
    FETCH c_exit_x_sede INTO v_existencias;
    CLOSE c_exit_x_sede;
    --
    --verifica las existencias en la sede
    IF v_existencias < p_cantidad OR v_existencias IS NULL THEN
        RAISE EXCEPTION 'cantidad %,% 11111 dska: % p_fact: %',p_cantidad,v_existencias,p_dska, p_fact;

        OPEN c_exist_total;
        FETCH c_exist_total INTO v_exis_total;
        CLOSE c_exist_total;

         IF v_exis_total > p_cantidad THEN

            v_valida_ex := IN_VALIDA_EXISTENCIAS(p_dska); 

            OPEN c_exist_total;
            FETCH c_exist_total INTO v_exis_total;
            CLOSE c_exist_total;

            IF v_exis_total > p_cantidad THEN
                --
                RAISE EXCEPTION 'En la sede en la cual esta facturando no hay las cantidades suficientes pero en el resto de la empresa si hay suficientes para satisfacer la compra, cantidad total de productos con codigo: 1-% , cantidades totales: % ',p_dska, v_exis_total;
                --
            ELSE
                --
                RAISE EXCEPTION 'No existe la cantidad de productos suficientes del producto con el codigo 1-% Las cantidades en toda la empresa actualmente son: % ', p_dska,v_exis_total;
                --
            END IF;
            ELSE
            --
            RAISE EXCEPTION 'No existe la cantidad de productos suficientes del producto con el codigo 1-% Las cantidades en toda la empresa actualmente son: % ', p_dska,v_exis_total;

         END IF;    
    END IF;
    --
    --Calculo la base del iva con el iva parametrizado previamente
    --
    OPEN c_iva_precio;
    FETCH c_iva_precio INTO v_iva_precio;
    CLOSE c_iva_precio;

    OPEN c_prom_pond_prod(p_dska);
    FETCH c_prom_pond_prod INTO v_vlr_prom_pond;
    CLOSE c_prom_pond_prod;
    --
    p_precio := (v_auxiliar * p_precio) / (v_auxiliar + v_iva_precio);

    OPEN c_valida_movi_fact;
    FETCH c_valida_movi_fact INTO v_val_mvin_fact;
    CLOSE c_valida_movi_fact;
    --
    IF v_val_mvin_fact <> 1 THEN
        --
        RAISE EXCEPTION 'No existe ningun movimiento de inventario que referencie la facturacion de productos';
        --
    ELSE
        --
        OPEN c_mvin_venta;
        FETCH c_mvin_venta INTO v_mvin_mvin;
        CLOSE c_mvin_venta;

    END IF;
    --
    --Realizamos la salida del inventario del producto 
    --
    v_rta_insrt_kar := IN_FINSERTA_PROD_KARDEX(p_dska,
                                               v_mvin_mvin,
                                               p_tius,
                                               p_cantidad,
                                               0,
                                               p_sede                                                   
                                               );

    IF upper(v_rta_insrt_kar) NOT LIKE '%OK%' THEN
        --
        RAISE EXCEPTION 'Error al hacer la salida de inventario. % ', v_rta_insrt_kar ;
        --
    ELSE
        --
        OPEN c_kapr_kapr(v_rta_insrt_kar);
        FETCH c_kapr_kapr INTO v_kapr_kapr;
        CLOSE c_kapr_kapr;
        --
    END IF;
        OPEN c_dtpr_dtpr;
        FETCH c_dtpr_dtpr INTO v_dtpr_dtpr;
        CLOSE c_dtpr_dtpr;


       INSERT INTO fa_tdtpr(
            dtpr_dtpr, dtpr_dska, dtpr_fact, 
            dtpr_num_prod, dtpr_cant, dtpr_vlr_pr_tot, 
            dtpr_vlr_uni_prod, dtpr_vlr_iva_tot, dtpr_vlr_iva_uni, 
            dtpr_vlr_venta_tot, dtpr_vlr_venta_uni, dtpr_vlr_total, 
            dtpr_desc, dtpr_kapr,dtpr_valor_desc,dtpr_utilidad,dtpr_con_desc)
        VALUES (
            v_dtpr_dtpr, p_dska, p_fact, 
            0, p_cantidad, p_precio*p_cantidad, 
            p_precio, v_vlr_iva_tot, v_vlr_iva_uni, 
            v_vlr_tot_fact_iva, v_vlr_uni_fact, v_vlr_tot_fact_iva,
            'N', v_kapr_kapr,0,v_utilidad_prod, 'N');

    OPEN c_cod_sbcu(p_dska);
    FETCH c_cod_sbcu INTO v_sbcu_cod_prod;
    CLOSE c_cod_sbcu;

     --
    --Calculo el promedio ponderado total de todos los productos
    --
    v_vlr_prom_pond_tot := v_vlr_prom_pond * p_cantidad;   
    
	
     --
    --Insercion para que se contabilice la salida del producto
    --

    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (p_idmvco, v_sbcu_cod_prod , v_vlr_prom_pond_tot , 'C');
    --
    --Insercion para la entrada de costo de ventas
    --
    INSERT INTO co_ttem_mvco(
            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
    VALUES (p_idmvco, '613535' , v_vlr_prom_pond_tot , 'D');
    --  
    RETURN 'OK';
	
	EXCEPTION WHEN OTHERS THEN
      RETURN 'Error FA_FACTURA_PRODUCTO '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';