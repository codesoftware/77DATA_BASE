--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_upd_repr() RETURNS trigger AS $f_ins_upd_repr$
    DECLARE
        --
        --Cursor el cual suma todos los promedios ponderados
        --
        c_sum_promedios CURSOR FOR
        SELECT sum(repr_promedio*repr_cantidad)
         FROM in_trepr
        WHERE repr_rece = NEW.repr_rece
        ;
        --
        v_sum_promedios             numeric(50,6) := 0;
        --
    BEGIN
        --
        --Obtengo la suma de los productos
        --
        OPEN c_sum_promedios;
        FETCH c_sum_promedios INTO v_sum_promedios;
        CLOSE c_sum_promedios;
        --
        UPDATE in_trece
           SET rece_promedio = v_sum_promedios
         WHERE rece_rece = NEW.repr_rece
        ;
        --
        RETURN NEW;        
        --
    END;
$f_ins_upd_repr$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_upd_repr
    AFTER INSERT OR UPDATE ON in_trepr
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_upd_repr()
    ;