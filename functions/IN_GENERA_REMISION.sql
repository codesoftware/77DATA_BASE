--
--Funcion con la cual realizo la generacion de una remision basandome en un pedido previamente creado por un usuario
--
CREATE OR REPLACE FUNCTION IN_GENERA_REMISION(
                                p_idPedido        BIGINT,
                                p_idTius          BIGINT) RETURNS varchar AS $$

    DECLARE 
    --
    --
    BEGIN
    --
    RETURN 'Ok';
    --
    EXCEPTION WHEN 
        OTHERS THEN
            --
            RETURN 'Error ' || sqlerrm;
            --
END;
$$ LANGUAGE 'plpgsql';
