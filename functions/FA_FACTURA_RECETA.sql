--
-- Funcion encargada de realizar la facturacion de una receta en particular
--
CREATE OR REPLACE FUNCTION FA_FACTURA_RECETA(  
                                                p_tius              INT,        --Id del usuario que esta registrando la venta del producto
                                                p_rece              INT,        --Id de la receta que se esta vendiendo
                                                p_sede              INT,        --Sede en la cual se esta vendiendo el producto
                                                p_cantidad          INT,        --Cantidad de productos que se vendieron
                                                p_idmvco            INT,        --Id de los movimientos contables que generar la transaccion
                                                p_fact              INT         --Id de facturacion    
                                            ) RETURNS VARCHAR  AS $$
    DECLARE
        --
        c_id_dtre CURSOR FOR
        SELECT COALESCE(MAX(DTRE_DTRE),0) +1
        FROM FA_TDTRE
        ;
        --
        v_dtre_dtre         INT :=  0;
        --
        c_precio_receta CURSOR FOR
        SELECT prre_precio
          FROM in_trece, in_tprre
         WHERE rece_rece = prre_rece
           AND prre_estado = 'A'
           AND rece_estado = 'A'
           AND rece_rece = p_rece
           AND prre_sede = p_sede
           ;
        --
        c_calcula_iva CURSOR (vc_valor NUMERIC) IS
        SELECT cast(para_valor as numeric) * 200
          FROM em_tpara
         WHERE upper(para_clave) = 'IVAPRVENTA'
         ;
        --
        c_costo_receta CURSOR FOR
        SELECT RECE_COSTO
          FROM IN_TRECE
         WHERE RECE_RECE = p_rece
        ;
        --
        v_iva_total         NUMERIC := 0;
        v_iva_unidad        NUMERIC := 0;
        --
        v_precio_unidad     NUMERIC := 0;
        v_precio_total      NUMERIC := 0;
        --
        v_venta_total       NUMERIC := 0;
        v_venta_unidad      NUMERIC := 0;
        --
        v_utilidad          NUMERIC := 0;
        --
        v_costo_rece        NUMERIC := 0;
        v_costo_tot_rece    NUMERIC := 0;
        --
        --Facturacion de los productos de la receta
        --
        --  
        --Valida si el movimiento de inventario para facturacion esta parametrizado
        --
        c_valida_movi_fact CURSOR FOR
        SELECT count(*)
          FROM in_tmvin
         WHERE mvin_venta = 'S'
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
        v_mvin_mvin             INT :=0;
        v_val_mvin_fact         INT := 0;
        v_sbcu_cod_prod         varchar(100) := '';
        --
        --Obtengo los productos asociados a la receta
        --
        c_prod_rece CURSOR FOR
        SELECT repr_cantidad, repr_dska
          FROM in_trepr
         WHERE repr_rece = p_rece
        ;
        --
        v_total_productos       INT := 0;
        v_prom_pond_prod        NUMERIC := 0;
        --
        --Cursor con el cual obtengo el valor del promedio pornderado del producto
        --
        c_prom_pond_prod CURSOR(vc_dska_dska INT) IS
        SELECT kapr_cost_saldo_uni
          FROM in_tkapr
         WHERE kapr_kapr = (select max(kapr_kapr) from in_tkapr where kapr_dska = vc_dska_dska)
        ;
        --
        v_rta_insrt_kar         VARCHAR(1000) := '';
        v_vlr_prom_pond         NUMERIC := 0;
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
        -- Cursor con el cual encuentro el id del movimiento de inventario
        --
        c_kapr_kapr CURSOR (vc_expresion varchar) IS
        SELECT cast(kapr_kapr as int)
          FROM (
               SELECT regexp_split_to_table(vc_expresion, '-') kapr_kapr
               offset 1) as tabla
        ;
        --
        v_kapr_kapr     NUMERIC  :=0;
        --
    BEGIN
        --raise exception 'parametro %, %, %, %, %, %',p_tius,p_rece,p_sede,p_cantidad,p_idmvco,p_fact;
        --
        OPEN c_id_dtre;
        FETCH c_id_dtre INTO v_dtre_dtre;
        CLOSE c_id_dtre;
        --
        --Obtengo el precio de una receta
        --
        OPEN c_precio_receta;
        FETCH c_precio_receta INTO v_precio_unidad;
        CLOSE c_precio_receta;
        --
        v_precio_total := v_precio_unidad * p_cantidad;
        --
        OPEN c_calcula_iva(v_precio_unidad);
        FETCH c_calcula_iva INTO v_iva_unidad;
        CLOSE c_calcula_iva;
        --
        OPEN c_calcula_iva(v_precio_total);
        FETCH c_calcula_iva INTO v_iva_total;
        CLOSE c_calcula_iva;
        --
        v_venta_unidad := v_iva_unidad + v_precio_unidad;
        --
        v_venta_total := v_iva_total + v_precio_total;
        --
        OPEN c_costo_receta;
        FETCH c_costo_receta INTO v_costo_rece;
        CLOSE c_costo_receta;
        --
        v_costo_tot_rece := v_costo_rece * p_cantidad;
        --
        v_utilidad := v_precio_total - v_costo_tot_rece; 
        --
        --raise exception 'v_costo_tot_rece %, v_costo_rece: % , p_cantidad: % , p_rece: %',v_costo_tot_rece,v_costo_rece,p_cantidad, p_rece;
        INSERT INTO fa_tdtre(
            dtre_dtre, dtre_rece, dtre_fact, dtre_cant, dtre_vlr_re_tot, 
            dtre_vlr_uni_rece, dtre_vlr_iva_tot, dtre_vlr_iva_uni, dtre_vlr_venta_tot, 
            dtre_vlr_venta_uni, dtre_vlr_total, dtre_desc, dtre_utilidad)
                    VALUES (v_dtre_dtre, p_rece, p_fact, p_cantidad, v_costo_tot_rece, 
                            v_costo_rece, v_iva_total, v_iva_unidad , v_venta_total, 
                            v_venta_unidad, v_venta_total, 'N', v_utilidad );
        --
        --Realizamos la logica para la facturacion de productos asociados
        --
        --Verificamos si existe el movimiento de inventario para facturacion
        --
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
        --Ciclo en el cual se registra la salida y la contabilizacion de cada
        --producto de las recetas
        --
        FOR producto IN c_prod_rece
        LOOP
            --
            v_total_productos := producto.repr_cantidad * p_cantidad;
            --
            OPEN c_prom_pond_prod(producto.repr_dska);
            FETCH c_prom_pond_prod INTO v_prom_pond_prod;
            CLOSE c_prom_pond_prod;
            --
            --
            --Realizamos la salida del inventario del producto 
            --
            v_rta_insrt_kar := IN_FINSERTA_PROD_KARDEX(producto.repr_dska,
                                                       v_mvin_mvin,
                                                       p_tius,
                                                       v_total_productos,
                                                       0,
                                                       p_sede                                                   
                                                       );
            --
            IF upper(v_rta_insrt_kar) NOT LIKE '%OK%' THEN
                --
                RAISE EXCEPTION 'Error al hacer la salida de inventario. Con la receta con codigo 3-%, % ',p_rece, v_rta_insrt_kar ;
                --            
            END IF;
            --
            v_vlr_prom_pond := v_prom_pond_prod * v_total_productos; 
            --
            --Obtengo la subcuenta del producto
            --
            OPEN c_cod_sbcu(producto.repr_dska);
            FETCH c_cod_sbcu INTO v_sbcu_cod_prod;
            CLOSE c_cod_sbcu;
            --
            --Insercion para que se contabilice la salida del producto
            --
            INSERT INTO co_ttem_mvco(
                    tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
            VALUES (p_idmvco, v_sbcu_cod_prod , v_vlr_prom_pond , 'C');
            --
            --Insercion para la entrada de costo de ventas
            --
            INSERT INTO co_ttem_mvco(
                    tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
            VALUES (p_idmvco, '613535' , v_vlr_prom_pond , 'D');
            --
            --Registro la insercion en tabla de relacion de recetas, productos y kardex
            --
            OPEN c_kapr_kapr(v_rta_insrt_kar);
            FETCH c_kapr_kapr INTO v_kapr_kapr;
            CLOSE c_kapr_kapr;
            --
            INSERT INTO fa_trrka(
                            rrka_dtre, rrka_rece, rrka_dska, rrka_kapr)
            VALUES (v_dtre_dtre, p_rece, producto.repr_dska, v_kapr_kapr);
            --
        END LOOP;
        --
        RETURN 'Ok';
        -- 
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_FACTURA_RECETA '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';