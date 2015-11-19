--
-- Funcion con la cual apruebo la creacion de una factura
--
CREATE OR REPLACE FUNCTION FA_CONFIRMA_FACTURA(   
                                            p_fact_fact     INT
                                            ) RETURNS VARCHAR AS $$
    DECLARE
        
        c_existe_Fact cursor for
        select count(*)
        from fa_tfact
        where fact_fact = p_fact_fact
        ;
        
        v_cont_exp          int := 0;
       
    BEGIN
    
    OPEN c_existe_Fact;
    FETCH c_existe_Fact INTO v_cont_exp;
    CLOSE c_existe_Fact;
    
    IF v_cont_exp = 1 THEN
        
        UPDATE fa_tfact
           SET fact_estado = 'U'
         WHERE fact_fact = p_fact_fact
        ;
        
    ELSE 
        --
        RETURN 'Error la factura no existe';
        --
    END IF; 
    --
    RETURN 'Ok';
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error ' ||sqlerrm ;
    END;
$$ LANGUAGE 'plpgsql';