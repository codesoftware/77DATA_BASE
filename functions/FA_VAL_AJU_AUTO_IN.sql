--
-- Funcion con la cual se valida si el inventario si puede ser ajustado o no
--
CREATE OR REPLACE FUNCTION FA_VAL_AJU_AUTO_IN (  
                                p_copr              BIGINT,
                                            ) RETURNS VARCHAR  AS $$
    DECLARE
    --
    --Funcion con la cual se obtiene el estado del conteo
    --
    c_estado_copr  CURSOR FOR
    SELECT copr_estado
      FROM in_tcopr
     WHERE copr_copr = p_copr
     ;
    --
    v_estado_copr       varchar(200):= '';
    --
    BEGIN
    --
    OPEN  c_estado_copr;
    fetch c_estado_copr INTO v_estado_copr;
    close c_estado_copr;
    --
    IF v_estado_copr <> 'X' THEN 
        --
        RAISE EXCEPTION 'El conteo que intenta ejecutar se encuenta en un estado diferente a cerrado por favor cierrelo e intente de nuevo';
        --
    END IF;
    --
    EXCEPTION WHEN OTHERS THEN
         p_excepcion := 'Error FA_VAL_AJU_AUTO_IN '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';