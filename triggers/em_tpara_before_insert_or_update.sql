--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_actualiza_iva_compra() RETURNS trigger AS $f_actualiza_iva_compra$
    DECLARE

    BEGIN
        
        IF NEW.PARA_CLAVE = 'IVAPR' THEN
            --
            UPDATE co_tsbft
               SET sbft_porcentaje = cast(NEW.para_valor as int)
             WHERE SBFT_SBCU_CODIGO = '240801'
             ;
            --
        END IF;
        --
        RETURN NEW;
        --
    END;
$f_actualiza_iva_compra$ LANGUAGE plpgsql;


CREATE TRIGGER f_actualiza_iva_compra
    BEFORE INSERT OR UPDATE ON em_tpara
    FOR EACH ROW
    EXECUTE PROCEDURE f_actualiza_iva_compra()
    ;