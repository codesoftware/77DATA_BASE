--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_auxiliarcontable() RETURNS trigger AS $f_ins_auxiliarcontable$
    DECLARE
        
        c_codigo CURSOR FOR
        SELECT cast(sbcu_codigo as varchar)
          FROM co_tsbcu
         WHERE sbcu_sbcu = NEW.auco_sbcu
           ;
    
        v_codigo           varchar(10);
        v_dummy             int;
        
    BEGIN
        --
        OPEN c_codigo;
        FETCH c_codigo INTO v_codigo; 
        CLOSE c_codigo;        
        --
        IF CAST(NEW.AUCO_CODI AS INT) <10 THEN
            --
            NEW.AUCO_CODI = '0'||CAST(NEW.AUCO_CODI AS INT);
            --
        END IF;
        --
        v_codigo = v_codigo||NEW.AUCO_CODI;
        --
        NEW.AUCO_CODI := v_codigo;
        --
        RETURN NEW;        
        --
    END;
$f_ins_auxiliarcontable$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_auxiliarcontable
    BEFORE INSERT ON co_tauco
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_auxiliarcontable()
    ;