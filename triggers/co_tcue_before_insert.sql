--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_cuenta() RETURNS trigger AS $f_ins_cuenta$
    DECLARE
        
        c_grupo CURSOR FOR
        SELECT grup_grup
          FROM co_tgrup
         WHERE grup_codigo = NEW.cue_grup
         ;
    
        v_grup_grup             NUMERIC :=0;
        
    BEGIN
        
        OPEN c_grupo;
        FETCH c_grupo INTO v_grup_grup; 
        CLOSE c_grupo;        
        
        NEW.cuen_grup := v_grup_grup;
        
        RETURN NEW;
        
        
    END;
$f_ins_cuenta$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_cuenta
    BEFORE INSERT OR UPDATE ON co_tcuen
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_cuenta()
    ;