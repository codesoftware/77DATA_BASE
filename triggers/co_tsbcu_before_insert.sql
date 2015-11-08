--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_sbcuenta() RETURNS trigger AS $f_ins_sbcuenta$
    DECLARE
        
        c_codigo CURSOR FOR
        SELECT cast(cuen_codigo as varchar)
          FROM co_tclas, co_tgrup, co_tcuen
         WHERE clas_clas = grup_clas
           AND grup_grup = cuen_grup
           AND cuen_cuen = NEW.sbcu_cuen
           ;
    
        v_codigo           varchar(10);
        v_dummy             int;
        
    BEGIN
        --
        OPEN c_codigo;
        FETCH c_codigo INTO v_codigo; 
        CLOSE c_codigo;        
        --
        IF CAST(NEW.sbcu_codigo AS INT) <10 THEN
            --
            NEW.sbcu_codigo = '0'||CAST(NEW.sbcu_codigo AS INT);
            --
        END IF;
        --
        v_codigo = v_codigo||NEW.sbcu_codigo;
        --
        NEW.sbcu_codigo := v_codigo;
        --
        RETURN NEW;        
        --
    END;
$f_ins_sbcuenta$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_sbcuenta
    BEFORE INSERT ON co_tsbcu
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_sbcuenta()
    ;