-- Funcion con la cual realizara el update sobre la tabla us_ttius para poder ingresar
-- con la clave auxiliar cuando el ususario a olvidado su clave

CREATE OR REPLACE FUNCTION US_FINSERT_CONTRA_AUX (   p_user      varchar(50), 
                                          p_contra    varchar(50)) RETURNS varchar AS $$
    BEGIN
    
    UPDATE us_ttius
    SET tius_contra_futura = p_contra,
        tius_cambio_contra = 'S'
    WHERE tius_usuario = p_user
    ;
    
    RETURN 'OK';
      EXCEPTION WHEN OTHERS THEN
         RETURN 'Err';
    END;
$$ LANGUAGE 'plpgsql';