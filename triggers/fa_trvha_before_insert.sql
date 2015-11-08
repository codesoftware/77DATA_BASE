    

CREATE OR REPLACE FUNCTION f_control_reserva() RETURNS trigger AS $f_control_reserva$
    DECLARE
    
    c_reservas CURSOR FOR
    SELECT count(*) 
      FROM in_trvha
    WHERE rvha_dsha = NEW.rvha_dsha
     AND NEW.rvha_fecha_ini between rvha_fecha_ini and rvha_fecha_fin
     ;
     
     v_reserva      NUMERIC := 0;
     v_fecha_fin    DATE;
     v_fecha_ven    DATE;
    
    BEGIN
        
        v_fecha_fin := NEW.rvha_fecha_ini + NEW.rvha_num_dias;
        
        NEW.rvha_fecha_fin := v_fecha_fin; 
        
        IF NEW.rvha_estado IS NULL THEN
            
            NEW.rvha_estado := 'R';
            
        END IF;
        
        IF NEW.rvha_estado = 'R' THEN
                    
            v_fecha_ven  :=  v_fecha_fin - 1;
            NEW.rvha_fecha_venci := v_fecha_ven;
            NEW.rvha_confirmada  := 'N';
            
        END IF;
    
        OPEN c_reservas;
        FETCH c_reservas INTO v_reserva;
        CLOSE c_reservas;
        
        IF v_reserva > 0 THEN
            RAISE EXCEPTION '% Error Ya existen reservas para esos dias en los cuales quiere reservar ',NEW.rvha_fecha_ini ;
        END IF;
        
        IF NOW() > NEW.rvha_fecha_ini THEN
            RAISE EXCEPTION '% Error Las reservaciones no se pueden hacer en fechas anteriores a la actual', NEW.rvha_fecha_ini;
        END IF;
        
        RETURN NEW;
    
    END;
$f_control_reserva$ LANGUAGE plpgsql;


CREATE TRIGGER f_control_reserva
    BEFORE INSERT ON in_trvha
    FOR EACH ROW
    EXECUTE PROCEDURE f_control_reserva();