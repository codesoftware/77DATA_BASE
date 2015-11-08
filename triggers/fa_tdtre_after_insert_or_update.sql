--
-- Trigger el cual se encargara de mantener acutalizada los acumulados de la factura
--
CREATE OR REPLACE FUNCTION f_upd_valor_factura_recetas() RETURNS trigger AS $f_upd_valor_factura_recetas$
    DECLARE
    
        v_valor_iva             NUMERIC :=0;
        v_valor_productos       NUMERIC :=0;
        v_valor_dcto            NUMERIC :=0;
        
    BEGIN
        
        v_valor_iva := FA_CONSLUTA_COSTS_FACT(new.dtre_fact,4,3);
        
        v_valor_productos := FA_CONSLUTA_COSTS_FACT(new.dtre_fact,4,2);
        
        v_valor_dcto := FA_CONSLUTA_COSTS_FACT(new.dtre_fact,4,4);
        
        UPDATE fa_tfact
           SET fact_vlr_total = v_valor_productos,
               fact_vlr_iva = v_valor_iva,
               fact_vlr_dcto = v_valor_dcto
        WHERE fact_fact = new.dtre_fact
        ;
        
        return null;
        
    END;
$f_upd_valor_factura_recetas$ LANGUAGE plpgsql;


CREATE TRIGGER f_upd_valor_factura_recetas
    AFTER INSERT OR UPDATE ON fa_tdtre
    FOR EACH ROW
    EXECUTE PROCEDURE f_upd_valor_factura_recetas()
    ;