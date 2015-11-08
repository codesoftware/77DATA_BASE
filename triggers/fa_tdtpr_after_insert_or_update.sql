--
-- Trigger el cual se encargara de mantener acutalizada los acumulados de la factura
--
CREATE OR REPLACE FUNCTION f_upd_valor_factura_productos() RETURNS trigger AS $f_upd_valor_factura_productos$
    DECLARE
    
        v_valor_iva             NUMERIC :=0;
        v_valor_productos       NUMERIC :=0;
        v_valor_dcto            NUMERIC :=0;
        
    BEGIN
        
        v_valor_iva := FA_CONSLUTA_COSTS_FACT(new.dtpr_fact,3,3);
        
        v_valor_productos := FA_CONSLUTA_COSTS_FACT(new.dtpr_fact,3,2);
        
        v_valor_dcto := FA_CONSLUTA_COSTS_FACT(new.dtpr_fact,3,4);
        
        UPDATE fa_tfact
        SET fact_vlr_total = v_valor_productos,
        fact_vlr_iva = v_valor_iva,
        fact_vlr_dcto = v_valor_dcto
        WHERE fact_fact = new.dtpr_fact
        ;
        
        return null;
        
    END;
$f_upd_valor_factura_productos$ LANGUAGE plpgsql;


CREATE TRIGGER f_upd_valor_factura_productos
    AFTER INSERT OR UPDATE ON fa_tdtpr
    FOR EACH ROW
    EXECUTE PROCEDURE f_upd_valor_factura_productos()
    ;