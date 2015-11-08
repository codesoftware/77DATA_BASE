-- Funcion con la cual se eliminara el registro de cambio de contraeña
-- asumiendo que si el usuario ingreso con la contreña actual no nesecita la nueva contraseña;

CREATE FUNCTION US_FELIM_CONTRA_AUX (   p_user      varchar(50)) RETURNS varchar AS'
    BEGIN
    
    UPDATE us_ttius
    SET tius_contra_futura = null,
        tius_cambio_contra = ''N''
    WHERE tius_usuario = p_user
    ;
    
    RETURN ''OK'';
      EXCEPTION WHEN OTHERS THEN
         RETURN ''Err'';
    END;
'LANGUAGE 'plpgsql';