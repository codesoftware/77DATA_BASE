CREATE OR REPLACE FUNCTION FA_VERF_RESERVA_HABITACION (  
                                       p_tius           INT,
                                       p_fecha_ini      DATE,          
                                       p_num_dias       int,
                                       p_dsha_dsha      INT
                                      ) RETURNS VARCHAR AS $$
    DECLARE
    
    v_fecha_fin     DATE;
    
    c_verReserva CURSOR (fecha DATE) IS
    SELECT count(*)
      FROM in_trvha
     WHERE rvha_dsha = p_dsha_dsha
       AND fecha between rvha_fecha_ini and rvha_fecha_fin
       AND rvha_estado = 'R'
    ;
    
    v_count         INTEGER := 0;
    v_fecha_aux     DATE;
    v_count_rsv     INTEGER := 0;    
    
    BEGIN
    
    v_fecha_fin :=  p_fecha_ini+ p_num_dias;
    v_fecha_aux :=  p_fecha_ini;
    
    WHILE v_count <= p_num_dias LOOP
        
        v_fecha_aux = p_fecha_ini + v_count;        
        
        
        OPEN c_verReserva(v_fecha_aux);
        FETCH c_verReserva INTO v_count_rsv;
        CLOSE c_verReserva;
        
        IF v_count_rsv > 0 THEN 
            RETURN 'N';
        END IF;       
        
        v_count = v_count+1;
    
    END LOOP;
    
    RETURN 'S';

    END;
$$ LANGUAGE 'plpgsql';