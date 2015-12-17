-- Función con la cual realizara las actualizaciones de los perfiles

CREATE OR REPLACE FUNCTION US_FINSERT_PERFIL (   
                                            p_nombre      varchar(500), 
                                            p_descri      varchar(500),
                                            p_estado      varchar(1)
                                            ) RETURNS varchar AS $$
    BEGIN
    
    
    INSERT INTO US_TPERF(perf_nomb,perf_desc,perf_estado)
    VALUES(upper(p_nombre),p_descri,p_estado)
    ;    
    
    RETURN 'OK';
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Err';
    END;
$$ LANGUAGE 'plpgsql';