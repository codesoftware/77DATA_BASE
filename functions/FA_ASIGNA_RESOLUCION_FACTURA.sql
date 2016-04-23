--
-- Funcion con la cual se validan las precondiciones necesarias para facturar como lo son 
--
CREATE OR REPLACE FUNCTION FA_ASIGNA_RESOLUCION_FACTURA (  
                                p_fact                  BIGINT,
                                p_rsfa                  BIGINT
                         )RETURNS VARCHAR AS $$
    DECLARE
        --
        --Cursor con el cual identifico la resolucion de facturacion que corresponde a la sede
        --
        c_resolucion CURSOR FOR
        SELECT rsfa_rsfa
          FROM fa_tfact, em_tsede, fa_trsfa
         WHERE fact_fact = p_fact
           AND sede_sede = fact_sede
           AND sede_rsfa = rsfa_rsfa
           ;
        --
        c_resol_esp CURSOR IS
        SELECT count(*)
          FROM fa_trsfa
         WHERE rsfa_rsfa = p_rsfa
         ;
        --
        c_dat_resolucion CURSOR (vc_rsfa bigint)IS
        SELECT rsfa_consec, rsfa_inicon
          FROM fa_trsfa
         WHERE rsfa_rsfa = vc_rsfa
         ;
        --
        v_rsfa                  bigint;
        v_aux                   bigint  := 0;
        v_futuro_cons           NUMERIC(1000,10)    := 0;
        v_inicon                NUMERIC(1000,10)    := 0;
        --
        v_consecutivo_fact      NUMERIC(1000,10)    := 0;
    BEGIN
        --
        --Evaluo si la resolucion de facturacion es automatica o no
        --En caso de que sea automatica el parametro p_rsfa debe ser -1
        --
        IF p_rsfa = -1 THEN
            --
            OPEN c_resolucion;
            FETCH c_resolucion INTO v_rsfa;
            CLOSE c_resolucion;
            --
            IF v_rsfa is null THEN
                --
                RAISE EXCEPTION ' La resolucion de facturacion referenciada no existe automatica ';
                --
            END IF;
            --
        ELSE
            --
            OPEN c_resol_esp;
            FETCH c_resol_esp INTO v_aux;
            CLOSE c_resol_esp;
            --
            IF v_aux = 0 THEN
                --
                RAISE EXCEPTION ' La resolucion de facturacion referenciada no existe fija';
                --
            END IF;
            --
            v_rsfa := p_rsfa;
            --
        END IF;
        --
        OPEN c_dat_resolucion(v_rsfa);
        FETCH c_dat_resolucion INTO v_futuro_cons,v_inicon;
        CLOSE c_dat_resolucion;
        --
        v_consecutivo_fact := v_futuro_cons + v_inicon + 1;
        --
        UPDATE fa_tfact
           SET fact_rsfa = v_rsfa,
               fact_cons = v_consecutivo_fact
         WHERE fact_fact = p_fact
         ;        
        --
        --raise exception 'v_rsfa 22222 % ' ,v_rsfa; 
        UPDATE fa_trsfa
           SET rsfa_consec = (v_futuro_cons + 1)
         WHERE rsfa_rsfa = v_rsfa
         ;
        --
    RETURN 'Ok';
    -- 
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_ASIGNA_RESOLUCION_FACTURA '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';