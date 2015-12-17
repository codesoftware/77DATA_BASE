CREATE OR REPLACE FUNCTION US_FACTUALIZA_PERFIL (   
                                            p_nombre      varchar(500), 
                                            p_descri      varchar(500),
                                            p_estado      varchar(1),
                                            p_id          bigint
                                            ) RETURNS VARCHAR AS $$
    BEGIN
    
    UPDATE US_TPERF
    SET perf_nomb = upper(p_nombre),
        perf_desc = p_descri,
        perf_estado = p_estado
    WHERE perf_perf = p_id
    ;       
    
    RETURN 'OK';
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Err';
    END;
$$ LANGUAGE 'plpgsql';