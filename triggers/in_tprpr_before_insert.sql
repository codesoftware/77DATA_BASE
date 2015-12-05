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
    --
     v_precios_activos      NUMERIC := 0;
    --
    c_iva_precio CURSOR IS
    SELECT cast(para_valor as numeric)
      FROM em_tpara
     WHERE para_clave = 'IVAPRVENTA'
    ;
    --
    v_iva_precio                numeric(50,6) := 0;
    --
    v_auxiliar                  numeric(50,6) := 100.00;
    --
    v_precio                    numeric(50,6) := 100.00;
    --
    v_total                     numeric(50,6) := 100.00;
    --
    BEGIN
        --
        OPEN c_activos;
        FETCH c_activos INTO v_precios_activos;
        CLOSE c_activos;
        --
        OPEN c_iva_precio;
        FETCH c_iva_precio INTO v_iva_precio;
        CLOSE c_iva_precio;
        --
        v_precio := NEW.prpr_precio;
        --
        v_auxiliar := (NEW.prpr_precio * v_iva_precio)/v_auxiliar;
        --
        v_total := v_auxiliar + v_precio;
        --
        NEW.PRPR_PREMSIVA := round(v_total);
        --
        IF v_precios_activos <> 0 THEN
            
            UPDATE in_tprpr
               SET prpr_estado = 'I'
             WHERE prpr_dska = NEW.prpr_dska
               AND prpr_sede = NEW.prpr_sede
             ;

             RETURN NEW;
             
             COMMIT;
        END IF;            
        --
        RETURN NEW;        
        --
        EXCEPTION 
        WHEN OTHERS THEN
    
    END;
$f_cont_est_preciosProd$ LANGUAGE plpgsql;



CREATE TRIGGER f_cont_est_preciosProd
    BEFORE INSERT ON IN_TPRPR
    FOR EACH ROW
    EXECUTE PROCEDURE f_cont_est_preciosProd();