--
-- Funcion con la cual desactivo una servicio y su reservacion
--
CREATE OR REPLACE FUNCTION FA_ELIMINA_PRODUCTOSXDTPR(   
                                            p_fact_fact     INT,
                                            p_dtpr_dtpr     INT,
                                            p_tius_tius     INT         --Identificador de la tabla de usuarios
                                            ) RETURNS VARCHAR AS $$
    DECLARE    
    
    v_rta_kardex      varchar(500) := '';
    v_cont_fact       INTEGER;
    v_vetor_rta       text[];
    v_kapr_kapr       INTEGER :=0;
    --
    --Cursor el cual verifica si la factura existe    
    --
    c_existe_fact CURSOR FOR
    SELECT count(*)
      FROM fa_tfact
     WHERE fact_fact = p_fact_fact
     ;
    
    v_mov_inv_dev_clie    INTEGER := 1; --Movimento de inventario el cual referencia devolucion de un cliente
    
    --
    -- Cursor el cual obtiene los datos del movimiento de inventario que implico la venta del producto
    --
    c_datos_movi CURSOR FOR
    SELECT kapr_cost_mvto_tot,dtpr_dska,kapr_cant_mvto
      FROM fa_tdtpr, in_tkapr
     WHERE dtpr_dtpr = p_dtpr_dtpr
       AND dtpr_kapr = kapr_kapr
        
     ;
    --Costo que le costo a la empresa la venta
    v_cost_movInventario    NUMERIC;
    --Identificador del producto con el cual se creo la compra
    v_dska_dska             INT;
    --Cantidad de productos del inventario
    v_cant_prod             INT;
    
    BEGIN
    
    OPEN c_existe_fact;
    FETCH c_existe_fact INTO v_cont_fact;
    CLOSE c_existe_fact;
    
    IF v_cont_fact = 1 THEN
    
        OPEN c_datos_movi;
        FETCH c_datos_movi INTO v_cost_movInventario,v_dska_dska,v_cant_prod;
        CLOSE c_datos_movi;
        
        v_rta_kardex := IN_FINSERTA_PROD_KARDEX(
                                                v_dska_dska,
                                                v_mov_inv_dev_clie,
                                                p_tius_tius,
                                                v_cant_prod,
                                                v_cost_movInventario
                                            );
                                            
        IF v_rta_kardex NOT LIKE 'ERR%' THEN
        
            v_vetor_rta := regexp_split_to_array(v_rta_kardex,'-');
            
            v_kapr_kapr := to_number(v_vetor_rta[2],'99999999');
            
            UPDATE fa_tdtpr
               SET dtpr_estado = 'C',
            dtpr_dev_kapr = v_kapr_kapr
             WHERE dtpr_fact = p_fact_fact
               AND dtpr_dtpr =p_dtpr_dtpr
               ;
               
        ELSE
            --Retorna el error que devuelve la funcion que retorna el 
            RETURN v_rta_kardex;
        END IF;
        
    ELSE
    
        RETURN 'Factura ingresada inexistente ';
        
    END IF;
    --
    RETURN 'Ok';
    --
    EXCEPTION WHEN OTHERS THEN
            RETURN 'Error '||SQLERRM;
    END;
$$ LANGUAGE 'plpgsql';