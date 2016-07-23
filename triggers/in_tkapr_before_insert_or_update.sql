--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_kapr_negativos() RETURNS trigger AS $f_ins_kapr_negativos$
    DECLARE
        --
        --
    BEGIN
        --
        IF NEW.kapr_cant_saldo < 0 THEN 
            --
            RAISE EXCEPTION 'El movimiento que esta generando da como resultado un saldo negativo lo cual no es permitido el codigo del producto es: 1-%', NEW.kapr_dska;
            --
        END IF;
        --
        --Actualiza la tabla con el nuevo promedio ponderado del producto en la tabla de los productos de las recetas        
        --
        UPDATE IN_TREPR
           SET REPR_PROMEDIO = NEW.kapr_cost_saldo_uni
         WHERE repr_dska = NEW.KAPR_DSKA
         ;
        --
        RETURN NEW;        
        --
    END;
$f_ins_kapr_negativos$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_kapr
    AFTER INSERT OR UPDATE ON in_tkapr
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_kapr_negativos()
    ;