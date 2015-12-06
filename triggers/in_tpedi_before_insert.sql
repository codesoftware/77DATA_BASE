--
-- Trigger con el cual si la fecha llega nula en la insercion de pedido el la inserta
--
CREATE OR REPLACE FUNCTION f_ins_pedido() RETURNS trigger AS $f_ins_pedido$
    DECLARE
        
        
        
    BEGIN
        
        IF NEW.pedi_fech is null THEN
            --
            NEW.pedi_fech  :=   now();
            --
        END IF;
        
        RETURN NEW;
        
        
    END;
$f_ins_pedido$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_pedido
    BEFORE INSERT OR UPDATE ON in_tpedi
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_pedido()
    ;