CREATE OR REPLACE FUNCTION FA_RESERVA_HABITACION (  
                                       p_tius           INT,
                                       p_fecha_ini      DATE,          
                                       p_num_dias       int,
                                       p_dsha_dsha      INT,
                                       p_clien          INT
                                      ) RETURNS VARCHAR AS $$
    DECLARE
    --Variable con la cual sabre si la habitacion esta disponible o no
    v_verf_reservacion      VARCHAR;
    
    v_rvha_rvha    INT  := 0;
    
    c_rvha CURSOR FOR
    SELECT max(rvha_rvha)
      FROM in_trvha
     WHERE rvha_dsha = p_dsha_dsha
     ;
    
    
    BEGIN
    
    v_verf_reservacion  := FA_VERF_RESERVA_HABITACION(
                                                    p_tius,
                                                    p_fecha_ini,
                                                    p_num_dias,
                                                    p_dsha_dsha
                                                );
                                                
    IF upper(v_verf_reservacion) = 'S' THEN
    
        INSERT INTO in_trvha(
            rvha_dsha, rvha_clien, rvha_fecha_ini, 
            rvha_fecha_fin, rvha_num_dias, rvha_fecha_venci, 
            rvha_tius)
        VALUES (
            p_dsha_dsha, p_clien, p_fecha_ini, 
            p_fecha_ini+p_num_dias, p_num_dias, p_fecha_ini-2,
            p_tius);  
        
        OPEN c_rvha;
        FETCH c_rvha INTO v_rvha_rvha;
        CLOSE c_rvha;
        RETURN ''||v_rvha_rvha;
        
    ELSE 
    
        RETURN 'Error la habitacion la cual desea facturar no esta disponible en el rango de fechas';
    
    END IF;
    
    EXCEPTION 
        WHEN OTHERS THEN
        
        RETURN 'Error '|| sqlerrm;
        
 END;
$$ LANGUAGE 'plpgsql';
    
    