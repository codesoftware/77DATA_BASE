CREATE OR REPLACE FUNCTION US_FACTUALIZA_USUARIO (   
                                            p_nombre      varchar(50), 
                                            p_apellido    varchar(50),
                                            p_cedula      varchar(50),
                                            p_correo      varchar(1),
                                            p_fecha_nac   date,
                                            p_perf_id     int,
                                            p_estado      varchar(50),
                                            p_usuario     varchar(50),
                                            p_sede        int
                                            ) RETURNS VARCHAR AS $$
    DECLARE 
    
    c_pers CURSOR FOR
    select pers_pers
    from us_tpers, us_ttius
    where tius_pers = pers_pers
    and upper(tius_usuario) = upper(p_usuario)
    ;
    
    v_pers_pers    int;
                                            
    BEGIN
    
    UPDATE us_ttius
    SET tius_estado = p_estado
    , tius_perf = p_perf_id
    , tius_sede = p_sede
    WHERE tius_usuario = p_usuario
    ;
    
    OPEN c_pers;
    FETCH c_pers INTO v_pers_pers;
    CLOSE c_pers;
    
    IF v_pers_pers is not null  or v_pers_pers = 0 THEN
    
        UPDATE US_TPERS 
        SET pers_nombre = upper(p_nombre)
        , pers_apellido = upper(p_apellido)
        , pers_cedula = p_cedula
        , pers_fecha_nac = p_fecha_nac
        , pers_email =  p_correo
        WHERE pers_pers = v_pers_pers
        ;   
    ELSE 
        RETURN 'Error al encontrar el usuario a actualizar';
    END IF;   
    
    RETURN 'OK';
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Err';
    END;
$$ LANGUAGE 'plpgsql';