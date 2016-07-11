--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_suma_detalles() RETURNS trigger AS $f_suma_detalles$
    DECLARE
        --
        --Cursor con el cual sumo el total de los detalles de los gastos
        --
        c_suma_detalles_d CURSOR FOR
        SELECT sum(dgas_valor)
          FROM im_tdgas
         WHERE dgas_gast = NEW.dgas_gast
           AND dgas_natu = 'D'
         ;
        --
        c_suma_detalles_c CURSOR FOR
        SELECT sum(dgas_valor)
          FROM im_tdgas
         WHERE dgas_gast = NEW.dgas_gast
           AND dgas_natu = 'C'
         ;
        --
        v_valor_gast_d        NUMERIC(1000,10) := 0;
        v_valor_gast_c        NUMERIC(1000,10) := 0;
        --
    BEGIN
        --
        OPEN c_suma_detalles_d;
        FETCH c_suma_detalles_d INTO v_valor_gast_d;
        CLOSE c_suma_detalles_d;
        --
        OPEN c_suma_detalles_c;
        FETCH c_suma_detalles_c INTO v_valor_gast_c;
        CLOSE c_suma_detalles_c;
        --
        UPDATE im_tgast
           SET gast_valor  = (v_valor_gast_d-v_valor_gast_c)
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