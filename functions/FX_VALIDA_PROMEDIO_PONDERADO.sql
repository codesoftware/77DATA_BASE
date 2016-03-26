--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION FX_VALIDA_PROMEDIO_PONDERADO(
                                    p_idprod    BIGINT,
                                    p_vlrPrd    NUMERIC)RETURNS VARCHAR AS $$
                                    
    DECLARE
        --
        --Cursor con el cual se obtiene el promedio ponderado del producto en el momento de la creacion del pedido
        --
        c_prom_pond_prod cursor for
        select cepr_promedio_uni
          from in_tcepr
         where cepr_dska = p_idprod
         ;
        --
        v_prom_pond         numeric(1000,10) := 0;
        --
        --Cursor que obtiene el iva parametrizado
        --
        c_iva_precio CURSOR IS
        SELECT cast(para_valor as numeric)
          FROM em_tpara
         WHERE para_clave = 'IVAPRVENTA'
        ;
        --
        v_iva_precio        NUMERIC(1000,10) := 0;
        v_auxiliar          NUMERIC(1000,10) := 0;
        v_precio_base       NUMERIC(1000,10) := 0;
        --
        --
    BEGIN
        --
        OPEN c_prom_pond_prod;
        FETCH c_prom_pond_prod into v_prom_pond;
        CLOSE c_prom_pond_prod;
        --
        OPEN c_iva_precio;
        FETCH c_iva_precio INTO v_iva_precio;
        CLOSE c_iva_precio;
        --
        --Saco la base del iva
        --
        v_auxiliar := 100.00;
        --
        v_auxiliar :=  (v_iva_precio / v_auxiliar)+1;
        --
        v_precio_base :=  (p_vlrPrd) /v_auxiliar;
        --
        IF v_prom_pond >= v_precio_base THEN
            --
            RETURN 'Error : el precio que esta parametrizando es menor que el promedio ponderado del producto, revise en la consulta de productos';
            --
        ELSE
            --
            RETURN 'OK';
            --
        END IF;
        -- 
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'FX_VALIDA_PROMEDIO_PONDERADO ' || sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';
