--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_teprs_negativos() RETURNS trigger AS $f_ins_teprs_negativos$
    DECLARE
        --
        --
    BEGIN
        --
        IF NEW.eprs_existencia < 0 THEN 
            --
            RAISE EXCEPTION ' f_ins_teprs_negativos El movimiento que esta generando da como resultado un saldo negativo en la sede lo cual no es permitido el codigo del producto es: 1-%', NEW.eprs_dska;
            --
        END IF;
        --
        RETURN NEW;        
        --
    END;
$f_ins_teprs_negativos$ LANGUAGE plpgsql;
--
CREATE TRIGGER f_ins_eprs
    AFTER INSERT OR UPDATE ON IN_TEPRS
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_teprs_negativos()
    ;