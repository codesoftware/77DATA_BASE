--
-- Funcion encargada de realizar toda la facturacion del sistema
--
CREATE OR REPLACE FUNCTION FA_FACTURA_PRODUCTO(  
                                                p_tius          INT,        --Id del usuario que esta registrando la venta del producto
                                                p_dska          INT,        --Id del producto que se esta vendiendo
                                                p_sede          INT,        --Sede en la cual se esta vendiendo el producto
                                                p_cantidad      INT,        --Cantidad de productos que se vendieron
                                                p_idmvco        INT,        --Id de los movimientos contables que generar la transaccion
                                                p_fact          INT         --Id de facturacion    
                                            ) RETURNS VARCHAR  AS $$
    DECLARE
    --
    --Variable utilizada para almacenar la respuesta de la salida de inventario
    --
    v_rta_insrt_kar         VARCHAR(500) := '';
    --
    --Variable en la cual se almacenara el movimiento de inventario que se encuentra parametrizado para las ventas
    --
    v_mvin_mvin             INT :=0;
    v_val_mvin_fact         INT := 0;
    --
    v_vlr_prom_pond         NUMERIC(15,6)   := 0;
    v_precio_prod           NUMERIC(15,6)   := 0;
    v_utilidad_prod         NUMERIC(15,6)   := 0;
    v_dtpr_dtpr             NUMERIC;
    v_vlr_total_fact        NUMERIC(15,6)   :=0;
    v_vlr_iva_tot           NUMERIC(15,6)   :=0;
    v_vlr_iva_uni           NUMERIC(15,6)   :=0;
    v_vlr_tot_fact_iva      NUMERIC(15,6)   :=0;
    v_vlr_uni_fact_iva      NUMERIC(15,6)   :=0;
    --
    v_kapr_kapr     NUMERIC  :=0;
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
    --Cursor en el cual obtengo el valor parametrizado para el  producto en la sede en la cual fue comprado
    --
    c_precio_prod CURSOR(vc_dska_dska  INT)IS
    SELECT prpr_precio
      FROM in_tprpr
     WHERE prpr_estado = 'A'
       and prpr_dska = vc_dska_dska
       and prpr_sede = p_sede
       ;
    --
    --Cursor con el cual obtengo el id de la tabla fa_tdtpr (Detalles de facturacion de productos)
    --
    c_dtpr_dtpr CURSOR FOR
    SELECT coalesce(max(dtpr_dtpr),0) + 1
      from fa_tdtpr
    ;       
    --
    --Cursor con el cual se calcula el valor del iva parametrizado
    --
    c_calc_iva CURSOR(vc_valor  NUMERIC)IS
    SELECT (cast(para_valor as numeric) *vc_valor) / 100 vlrIva
    FROM em_tpara where para_clave = 'IVAPRVENTA'
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
    --
    --Cursor con el cual obtengo el valor del promedio pornderado del producto
    --
    c_prom_pond_prod CURSOR(vc_dska_dska INT) IS
    SELECT kapr_cost_saldo_uni, kapr_cant_saldo,kapr_cost_saldo_tot
      FROM in_tkapr
     WHERE kapr_kapr = (select max(kapr_kapr) from in_tkapr where kapr_dska = vc_dska_dska)
    ;
    --
    v_sbcu_cod_prod         varchar(100) := '';
    --
    v_vlr_prom_pond_tot     NUMERIC := 0;
    --
    v_prom_pond             NUMERIC := 0;
    v_prom_pond_tot         NUMERIC := 0;
    --
    BEGIN
    --
    --Validacion de existencia de movimientos de inventario referenciando facturacion
    --
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
        --
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
    --
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
    --
    --Obtiene el precio de venta del producto
    --
    OPEN c_precio_prod(p_dska);
    FETCH c_precio_prod INTO v_precio_prod;
    CLOSE c_precio_prod;
    --
    --Obtengo el valor del promedio ponderado del producto
    --
    OPEN c_prom_pond_prod(p_dska);
    FETCH c_prom_pond_prod INTO v_vlr_prom_pond;
    CLOSE c_prom_pond_prod;
    --
    --Realiza el calculo de utilidad del que dejara el producto
    --
    v_utilidad_prod := v_precio_prod - v_vlr_prom_pond;
    v_utilidad_prod := v_utilidad_prod * p_cantidad;
    --
    IF v_utilidad_prod < 0 THEN
        --
        RAISE EXCEPTION 'La venta del producto produce una perdida  mayor a 500 pesos lo cual no es permitido exactamente de: % ',v_utilidad_prod ;
        --
    END IF;
    --
    --Cursor el cual obtiene el id para el ingreso de detalles de facturacion
    --
    OPEN c_dtpr_dtpr;
    FETCH c_dtpr_dtpr INTO v_dtpr_dtpr;
    CLOSE c_dtpr_dtpr;
    --
    --Calculo del precio que pagara el cliente por el producto sin iva
    --
    v_vlr_total_fact := p_cantidad * v_precio_prod;
    --
    OPEN c_calc_iva(v_vlr_total_fact);
    FETCH c_calc_iva INTO v_vlr_iva_tot;
    CLOSE c_calc_iva;
    --
    OPEN c_calc_iva(v_precio_prod);
    FETCH c_calc_iva INTO v_vlr_iva_uni;
    CLOSE c_calc_iva;
    --
    --Calculamos el valor total de la factura con iva y el precio total de los productos
    --
    v_vlr_tot_fact_iva := v_vlr_total_fact + v_vlr_iva_tot;
    --
    v_vlr_uni_fact_iva := v_precio_prod + v_vlr_iva_uni;
    --
    v_prom_pond_tot := p_cantidad * v_prom_pond;
    --
    INSERT INTO fa_tdtpr(
            dtpr_dtpr, dtpr_dska, dtpr_fact, 
            dtpr_num_prod, dtpr_cant, dtpr_vlr_pr_tot, 
            dtpr_vlr_uni_prod, dtpr_vlr_iva_tot, dtpr_vlr_iva_uni, 
            dtpr_vlr_venta_tot, dtpr_vlr_venta_uni, dtpr_vlr_total, 
            dtpr_desc, dtpr_kapr,dtpr_valor_desc,dtpr_utilidad)
        VALUES (
            v_dtpr_dtpr, p_dska, p_fact, 
            0, p_cantidad, v_prom_pond_tot, 
            v_prom_pond, v_vlr_iva_tot, v_vlr_iva_uni, 
            v_vlr_tot_fact_iva, v_vlr_uni_fact_iva, v_vlr_tot_fact_iva,
            'N', v_kapr_kapr,0,v_utilidad_prod );
    --
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
    RETURN 'Ok';
    -- 
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_FACTURA_PRODUCTO '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';