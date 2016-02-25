--
-- Trigger el cual se encargara de crear en el conteo los productos que deben ir en el conteo automaticamente
--
CREATE OR REPLACE FUNCTION f_inserta_prod_def_conteo() RETURNS trigger AS $f_inserta_prod_def_conteo$
    DECLARE
    --
    --Cursor con el cual obtengo los productos que se deben  ingresar en el conteo automaticamente
    --
    c_prod_aut CURSOR FOR
    SELECT dska_dska
      FROM in_tdska
     WHERE dska_inicont = 'S'
     ;
    --
    --Valida si el conteo tiene productos contados
    --
    c_prod_cont CURSOR FOR
    SELECT count(*)
      FROM IN_TECOP
     WHERE ecop_copr = NEW.copr_copr
    ;
    --
    v_prod_cont         bigint:= 0;
    --
    BEGIN
        --
        IF NEW.COPR_ESTADO = 'A' THEN
            --
            OPEN c_prod_cont;
            FETCH c_prod_cont INTO v_prod_cont;
            CLOSE c_prod_cont;
            -- 
            IF v_prod_cont  = 0 THEN
                --
                FOR prod IN c_prod_aut LOOP
                    --
                    INSERT INTO in_tecop(ecop_ecop, ecop_copr, ecop_dska, ecop_valor)
                    VALUES((select coalesce(max(ecop_ecop),0) +1 from in_tecop),new.copr_copr, prod.dska_dska, 0);
                    --
                END LOOP;
                --
            END IF;
            --
        END IF;
        --
        RETURN NEW;        
        --
    END;
$f_inserta_prod_def_conteo$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_copr 
    AFTER INSERT OR UPDATE ON in_tcopr
    FOR EACH ROW
    EXECUTE PROCEDURE f_inserta_prod_def_conteo()
    ;