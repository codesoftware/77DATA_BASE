--
-- Funcion con la cual controlaremos que solo halla un registro activo por cada producto
--
CREATE OR REPLACE FUNCTION f_cont_est_preciosProd() RETURNS trigger AS $f_cont_est_preciosProd$
    DECLARE
    
    c_activos CURSOR FOR
    SELECT count(*) 
      FROM in_tprpr
     WHERE prpr_dska = NEW.prpr_dska
       AND prpr_sede = NEW.prpr_sede
     ;
     
     v_precios_activos      NUMERIC := 0;
    
    BEGIN
    
        OPEN c_activos;
        FETCH c_activos INTO v_precios_activos;
        CLOSE c_activos;
        
        
        IF v_precios_activos <> 0 THEN
            
            UPDATE in_tprpr
               SET prpr_estado = 'I'
             WHERE prpr_dska = NEW.prpr_dska
               AND prpr_sede = NEW.prpr_sede
             ;

             RETURN NEW;
             
             COMMIT;
        END IF;    
        
        RETURN NEW;        
        
        EXCEPTION 
        WHEN OTHERS THEN
    
    END;
$f_cont_est_preciosProd$ LANGUAGE plpgsql;



CREATE TRIGGER f_cont_est_preciosProd
    BEFORE INSERT ON IN_TPRPR
    FOR EACH ROW
    EXECUTE PROCEDURE f_cont_est_preciosProd();