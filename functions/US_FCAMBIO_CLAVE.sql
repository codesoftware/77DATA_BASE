-- Funcion con la cual realizara el cambio de contraseña principasl
-- con el usuario y la clave

CREATE OR REPLACE FUNCTION US_FCAMBIO_CLAVE (   p_user      varchar(50), 
                                     p_contra    varchar(50)) RETURNS varchar AS $$
    BEGIN
    
    UPDATE us_ttius
    SET tius_contra_act = p_contra,
        tius_cambio_contra = 'N',
        tius_contra_futura = null
    WHERE upper(tius_usuario) = upper(p_user)
    ;
    
    RETURN 'OK';
    
    EXCEPTION 
    WHEN OTHERS THEN
         RETURN 'Err';
    END;
$$ LANGUAGE 'plpgsql';