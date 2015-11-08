--
-- Trigger el cual se encargara de mantener acutalizada los acumulados de la factura
--
CREATE OR REPLACE FUNCTION f_upd_valor_factura_servicios() RETURNS trigger AS $f_upd_valor_factura_servicios$
    DECLARE
    
        v_valor_iva             NUMERIC :=0;
        v_valor_productos       NUMERIC :=0;
        
    BEGIN
        
        v_valor_iva := FA_CONSLUTA_COSTS_FACT(new.dtsv_fact,3,3);
        
        v_valor_productos := FA_CONSLUTA_COSTS_FACT(new.dtsv_fact,3,2);
        
        UPDATE fa_tfact
        SET fact_vlr_total = v_valor_productos,
        fact_vlr_iva = v_valor_iva
        WHERE fact_fact = new.dtsv_fact
        ;
        
        return null;
        
    END;
$f_upd_valor_factura_servicios$ LANGUAGE plpgsql;


CREATE TRIGGER f_upd_valor_factura_servicios
    AFTER INSERT OR UPDATE ON fa_tdtsv
    FOR EACH ROW
    EXECUTE PROCEDURE f_upd_valor_factura_servicios()
    ;