--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_kapr_negativos() RETURNS trigger AS $f_ins_kapr_negativos$
    DECLARE
        --Cursor el cual valida si exite el producto en los consolidados de existencias
        c_exist_cepr CURSOR FOR
        SELECT count(*)
          FROM in_tcepr
         WHERE cepr_dska = NEW.KAPR_DSKA
         ;
        --
        v_exist_cepr    int := 0;
        --
        --Cursor con el cual evaluo si existe un producto en la tabla consolidada de existencias por sede
        --
        c_ex_prod_sede CURSOR FOR
        SELECT eprs_eprs
          FROM in_teprs
         WHERE eprs_dska = NEW.KAPR_DSKA
           AND eprs_sede = NEW.KAPR_SEDE
           ;
        --
        c_cursor_mvto_inv CURSOR FOR
        SELECT mvin_natu
         FROM in_tmvin
         WHERE mvin_mvin = NEW.KAPR_MVIN
         ;
        --
        v_ext_pr_sede   bigint := 0;
        v_natuMovi      varchar(2) := '';
        --
        v_mvto_cant_total   bigint:= 0;
    BEGIN
        --
        IF NEW.kapr_cant_saldo < 0 THEN 
            --
            RAISE EXCEPTION 'El movimiento que esta generando da como resultado un saldo negativo lo cual no es permitido con el siguiente codigo 1-%', NEW.kapr_dska;
            --
        END IF;
        --
        --Actualiza la tabla con el nuevo promedio ponderado del producto en la tabla de los productos de las recetas        
        --
        UPDATE IN_TREPR
        SET REPR_PROMEDIO = NEW.kapr_cost_saldo_uni
        WHERE repr_dska = NEW.KAPR_DSKA
        ;
        --
        OPEN c_exist_cepr;
        FETCH c_exist_cepr INTO v_exist_cepr;
        CLOSE c_exist_cepr;
        --
        IF v_exist_cepr = 0 THEN
        --
            INSERT INTO in_tcepr(
                        cepr_dska, cepr_existencia, cepr_promedio_uni, cepr_promedio_total)
            VALUES ( NEW.KAPR_DSKA, NEW.kapr_cant_saldo, NEW.kapr_cost_saldo_uni, NEW.kapr_cost_saldo_tot);
        --
        ELSE
        --
            UPDATE in_tcepr
               SET cepr_existencia = NEW.kapr_cant_saldo,
               cepr_promedio_uni = NEW.kapr_cost_saldo_uni,
               cepr_promedio_total = NEW.kapr_cost_saldo_tot
             WHERE cepr_dska = NEW.KAPR_DSKA
             ;
        --
        END IF;
        --
        OPEN c_ex_prod_sede;
        FETCH c_ex_prod_sede INTO v_ext_pr_sede;
        CLOSE c_ex_prod_sede;
        --
        IF v_ext_pr_sede is null THEN 
            --
            INSERT INTO IN_TEPRS(eprs_dska,eprs_existencia,eprs_sede)
            VALUES(NEW.KAPR_DSKA, NEW.KAPR_CANT_MVTO,NEW.KAPR_SEDE);
            --
        ELSE
            --
            OPEN c_cursor_mvto_inv;
            FETCH c_cursor_mvto_inv INTO v_natuMovi;
            CLOSE c_cursor_mvto_inv;
            --
            IF upper(v_natuMovi) = 'E' then
                --
                v_mvto_cant_total := NEW.KAPR_CANT_MVTO * (-1);
                --
            ELSE
                --
                v_mvto_cant_total := NEW.KAPR_CANT_MVTO;
                --
            END IF;
            --
            UPDATE IN_TEPRS
               SET eprs_existencia = eprs_existencia + v_mvto_cant_total
             WHERE eprs_eprs = v_ext_pr_sede
               AND eprs_dska = NEW.KAPR_DSKA
             ;
        END IF;
        --
        RETURN NEW;        
        --
    END;
$f_ins_kapr_negativos$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS f_ins_kapr ON in_tkapr;

CREATE TRIGGER f_ins_kapr
    AFTER INSERT OR UPDATE ON in_tkapr
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_kapr_negativos()
    ;