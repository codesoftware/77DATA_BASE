--
-- Funcion con la cual cambiare los productos de una sede a otra
--
CREATE OR REPLACE FUNCTION IN_INSERTA_PROD_APORTE(   
                                            p_apor                  BIGINT,
                                            p_dska_cod_ext          varchar,
                                            p_cantidad              BIGINT,
                                            p_costo                 numeric,
                                            p_tius_tius             BIGINT
                                            ) RETURNS VARCHAR AS $$
    DECLARE
    --
    c_valida_prod CURSOR FOR 
    SELECT dska_dska 
      FROM in_tdska
     WHERE dska_cod_ext = p_dska_cod_ext
     ;
    --
    v_dska_dska         bigint :=0;
    --
    --Validacion adicional por si el producto no lo encuentra
    --
    c_val_prod_ad CURSOR FOR
    select dska_dska 
      from in_tdska, in_tmarca
     where dska_marca = marca_marca
        and upper(marca_nombre) ||'-'|| upper(dska_cod_ext) = UPPER(p_dska_cod_ext)
        ;
    --
    BEGIN
    --
    --
    IF p_cantidad <= 0 THEN
        --
        raise exception 'La cantidad no puede ser inferior ni igual a cero ';
        --
    END IF;
    --
    IF p_costo <= 0 THEN
        --
        raise exception 'El costo no puede ser inferior ni igual a cero ';
        --
    END IF;
    --
    OPEN c_valida_prod;
    FETCH c_valida_prod INTO v_dska_dska;
    CLOSE c_valida_prod;
    --
    IF v_dska_dska is null THEN
        --
        OPEN c_val_prod_ad;
        FETCH c_val_prod_ad INTO v_dska_dska;
        CLOSE c_val_prod_ad;
        --
        IF v_dska_dska is null THEN
            --
            RAISE EXCEPTION 'El producto referenciado con el codigo externo % no se encuentra en el sistema',p_dska_cod_ext; 
            --
        END IF        
        --
    END IF;
    --
    INSERT INTO in_tprap(
            prap_apor, prap_dska, prap_cant, prap_costo)
        VALUES (p_apor, v_dska_dska, p_cantidad, p_costo);
    --
    RETURN 'Ok';
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error IN_INSERTA_PROD_APORTE ' ||sqlerrm ;
    END;
$$ LANGUAGE 'plpgsql';