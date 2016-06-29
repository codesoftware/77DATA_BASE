--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_suma_detalles() RETURNS trigger AS $f_suma_detalles$
    DECLARE
        --
        --Cursor con el cual sumo el total de los detalles de los gastos
        --
        c_suma_detalles CURSOR FOR
        SELECT sum(dgas_valor)
          FROM im_tdgas
         WHERE dgas_gast = NEW.dgas_gast
         ;
        --
        v_valor_gast        NUMERIC(1000,10) := 0;
        --
    BEGIN
        --
        OPEN c_suma_detalles;
        FETCH c_suma_detalles INTO v_valor_gast;
        CLOSE c_suma_detalles;
        --
        UPDATE im_tgast
           SET gast_valor  = v_valor_gast
         WHERE gast_gast =  NEW.dgas_gast
         ;
        --
        RETURN NEW;        
        --
    END;
$f_suma_detalles$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_dgas
    AFTER INSERT OR UPDATE ON im_tdgas
    FOR EACH ROW
    EXECUTE PROCEDURE f_suma_detalles()
    ;