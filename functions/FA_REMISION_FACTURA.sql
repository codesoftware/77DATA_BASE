--
--Funcion con la cual convierte una remision en una factura
--
CREATE OR REPLACE FUNCTION FA_REMISION_FACTURA (  
                                p_tius              BIGINT,
                                p_remi              BIGINT
                         )RETURNS VARCHAR AS $$
    DECLARE
        --
        --
    BEGIN
        --
        return 'Ok';
        --
    EXCEPTION WHEN OTHERS THEN
         return 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';