--
-- Trigger el cual se encargara de mantener acutalizada los acumulados de la factura
--
CREATE OR REPLACE FUNCTION f_upd_dtpr_dtpr() RETURNS trigger AS $f_upd_dtpr_dtpr$
    DECLARE
        --
        v_dtpr_dtpr             NUMERIC;
        --
        --
        --Cursor con el cual obtengo el id de la tabla fa_tdtpr (Detalles de facturacion de productos)
        --
        c_dtpr_dtpr CURSOR FOR
        SELECT coalesce(max(dtpr_dtpr),0) + 1
          from fa_tdtpr
        ;
        --
    BEGIN
        --
        IF NEW.dtpr_dtpr is null THEN
            --
            --Cursor el cual obtiene el id para el ingreso de detalles de facturacion
            --
            OPEN c_dtpr_dtpr;
            FETCH c_dtpr_dtpr INTO v_dtpr_dtpr;
            CLOSE c_dtpr_dtpr;
            --
            new.dtpr_dtpr := v_dtpr_dtpr;
            --            
        END IF;
        
        return NEW;
        
    END;
$f_upd_dtpr_dtpr$ LANGUAGE plpgsql;


CREATE TRIGGER f_upd_dtpr_dtpr
    BEFORE INSERT OR UPDATE ON fa_tdtpr
    FOR EACH ROW
    EXECUTE PROCEDURE f_upd_dtpr_dtpr()
    ;