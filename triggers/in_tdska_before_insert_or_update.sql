--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_producto() RETURNS trigger AS $f_ins_producto$
    DECLARE
    --
    BEGIN
        --
        IF UPPER(TRIM(NEW.dska_barcod)) = 'NO APLICA' or UPPER(TRIM(NEW.dska_barcod)) = 'N/A' THEN
            --
            NEW.dska_barcod := null;
            --
        END IF;
        --
        RETURN NEW;
        --
    END;
$f_ins_producto$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_producto
    BEFORE INSERT OR UPDATE ON in_tdska
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_producto()
    ;