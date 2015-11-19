-- Funcion la cual se encargara de ingresar los detalles del inventario de cada producto

CREATE OR REPLACE FUNCTION FA_REGISTRA_VENTA_PROD (  
                                                    p_id_producto     INTEGER ,         -- Identificador unico del producto (DSKA_DSKA) al cual se le realizara el movimiento de inventario
                                                    p_fact_fact       INTEGER ,         -- Identificador del la factura a la cual se le añadira el movimiento
                                                    p_cant            INTEGER ,         -- Cantidad de productos a registrar
                                                    p_usuario         INTEGER          -- Usuario que registro la venta
                                                    ) RETURNS VARCHAR AS $$
DECLARE
    --Variable en la cual se almacenara la respuesta al ingresar el movimiento de inventario (Venta).
    v_rta_kardex      varchar(500) := '';
    --Variable con la cual obtendre el valor de movimiento de inventario de venta.
    v_mov_inv_venta   INTEGER := 4;
    v_vetor_rta       text[];
    --
    v_cont_fact       INTEGER;
    --
    --Identificador del kardex
    v_kapr_kapr       INTEGER :=0;
    --Cursor el cual verifica si la factura existe    
    c_existe_fact CURSOR FOR
    SELECT count(*)
      FROM fa_tfact
     WHERE fact_fact = p_fact_fact
     ;
     --Cursor con el cual obtengo el valor que le dare a la llave primaria de la ta tabla fa_tdtpr
     c_dtpr_dtpr CURSOR FOR
     SELECT coalesce(max(dtpr_dtpr),0)+ 1 as dtpr_dtpr
       FROM fa_tdtpr
         ;
    v_dtpr_dtpr     INTEGER  := 0;
    --
    --Valores de venta de los productos
    --
    v_valor_uni         numeric(50,6) := 0;
    v_valor_iva         numeric(50,6) := 0;
    v_valor_prod        numeric(50,6) := 0; --Valor del producto bruto sin el cobro del iva
    v_valor_total       numeric(50,6) := 0;
    --
    --Cursor con el cual obtenemos el precio parametrizado el cual en el momento 
    --de adicionar el producto esta parametrizado
    --
    c_precio_prod CURSOR FOR
    SELECT prpr_precio 
      FROM in_tprpr
     WHERE prpr_estado = 'A'
       AND prpr_dska = p_id_producto
       ;
    --
    --Cursor el cual obtendra el valor del iva del producto
    --
    c_iva_prod CURSOR FOR
    SELECT CASE 
            WHEN upper(trim(dska_iva)) = 'N' THEN 0
            ELSE coalesce(dska_porc_iva,0)
           END porc_iva
      FROM in_tdska
     WHERE dska_dska = p_id_producto
     ;
BEGIN
    
    OPEN c_existe_fact;
    FETCH c_existe_fact INTO v_cont_fact;
    CLOSE c_existe_fact;
    
    OPEN c_precio_prod;
    FETCH c_precio_prod INTO v_valor_uni;
    CLOSE c_precio_prod;
    
    IF v_cont_fact = 1  AND  v_valor_uni IS NOT NULL THEN
    
        v_rta_kardex := IN_FINSERTA_PROD_KARDEX(
                                                p_id_producto,
                                                v_mov_inv_venta,
                                                p_usuario,
                                                p_cant,
                                                null
                                            );
        IF v_rta_kardex NOT LIKE 'ERR%' THEN
        
            v_vetor_rta := regexp_split_to_array(v_rta_kardex,'-');
            
            v_kapr_kapr := to_number(v_vetor_rta[2],'99999999');
            
            OPEN c_dtpr_dtpr;
            FETCH c_dtpr_dtpr INTO v_dtpr_dtpr;
            CLOSE c_dtpr_dtpr;
            
            OPEN c_iva_prod;
            FETCH c_iva_prod INTO v_valor_iva;
            CLOSE c_iva_prod;    
            
            v_valor_prod := v_valor_uni* p_cant;
            
            v_valor_iva :=  (v_valor_iva * v_valor_uni)/100;
            v_valor_iva :=  v_valor_iva * p_cant;
            
            v_valor_total := v_valor_prod + v_valor_iva;
            
            INSERT INTO fa_tdtpr(
                        dtpr_dtpr, dtpr_dska, dtpr_fact, 
                        dtpr_num_prod, dtpr_cant, dtpr_valor_pr, 
                        dtpr_valor_iva, dtpr_vl_uni_prod,dtpr_valor_venta, 
                        dtpr_desc, dtpr_kapr)
            VALUES (v_dtpr_dtpr, p_id_producto, p_fact_fact,
                    p_cant, p_cant, v_valor_prod , 
                    v_valor_iva, v_valor_uni, v_valor_total, 
                    'N',v_kapr_kapr);
            
        ELSE  
            --Retorna el error que devuelve la funcion que retorna el 
            RETURN v_rta_kardex;            
            
        END IF;
    ELSE
        
        IF v_valor_uni IS NULL THEN
            RETURN 'El producto al cual le quiere registrar la venta no tiene parametrizado el precio';
        ELSE
            RETURN 'Factura ingresada inexistente ';
        END IF;
    
        
        
    END IF;
    
    return 'Ok';
    
EXCEPTION WHEN OTHERS THEN
               RETURN 'ERR' || ' Error postgres: ' || SQLERRM;
       END;
$$ LANGUAGE 'plpgsql';