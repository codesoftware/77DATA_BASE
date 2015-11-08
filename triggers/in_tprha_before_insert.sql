--
-- Funcion con la cual controlaremos que solo halla un registro activo por cada habitacion
--
CREATE OR REPLACE FUNCTION f_cont_est_precios() RETURNS trigger AS $f_cont_est_precios$
    DECLARE
    
    c_activos CURSOR FOR
    SELECT count(*) 
      FROM in_tprha
     WHERE prha_dsha = NEW.prha_dsha
     ;
     
     v_precios_activos      NUMERIC := 0;
    
    BEGIN
    
        OPEN c_activos;
        FETCH c_activos INTO v_precios_activos;
        CLOSE c_activos;
        
        
        IF v_precios_activos <> 0 THEN
            
            UPDATE in_tprha
               SET prha_estado = 'I'
             WHERE prha_dsha = NEW.prha_dsha
             ;

             RETURN NEW;
             
             COMMIT;
        END IF;    
        
        RETURN NEW;        
        
        EXCEPTION 
        WHEN OTHERS THEN
    
    END;
$f_cont_est_precios$ LANGUAGE plpgsql;



CREATE TRIGGER f_cont_est_precios
    BEFORE INSERT ON IN_TPRHA
    FOR EACH ROW
    EXECUTE PROCEDURE f_cont_est_precios();