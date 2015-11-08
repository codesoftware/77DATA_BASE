CREATE OR REPLACE 
FUNCTION FA_CREA_FACTURA (  
                            ptius       int,
                            pclien      int                                      
                         ) RETURNS VARCHAR  AS $$
    DECLARE
    
    v_vlr_total     NUMERIC  :=0;
    v_vlr_iva       NUMERIC  :=0;
    v_fact_fact     Varchar(10);
    
    c_id_fact CURSOR FOR
    select coalesce(max(fact_fact),0)
      from fa_tfact
     where fact_tius = ptius
     and fact_clien = pclien
     ;
     
    BEGIN
    
    INSERT INTO FA_TFACT(fact_tius, fact_clien,fact_vlr_total,fact_vlr_iva)
    VALUES (ptius,pclien,v_vlr_total,v_vlr_iva)
    ;
    
    OPEN c_id_fact;
    FETCH c_id_fact INTO v_fact_fact;
    CLOSE c_id_fact;
    
    RETURN 'Ok-'||v_fact_fact;
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';