-- Function: in_finsert_cierre_diario(date, integer, integer)

-- DROP FUNCTION in_finsert_cierre_diario(date, integer, integer);

CREATE OR REPLACE FUNCTION in_finsert_cierre_diario(p_cfecha date, p_usuar integer, p_sede integer)
  RETURNS character varying AS
$BODY$
                                                    
    DECLARE 
        --
        rta                 varchar(10) := 'Err';
        vlr_iva             NUMERIC(15,5) := 0;
        vrl_tot             NUMERIC(15,5) := 0;
        vlr_cie             NUMERIC(15,5) := 0;
        v_cierre_cierre     INT           := 0;
        --
        --Cursor que me verifica si el cierre ya se hizo en esa fecha
        --
        c_verifica_cierre CURSOR FOR 
        SELECT CASE
                WHEN COUNT(*) > 0 THEN 'SI'
                WHEN COUNT(*) < 0 THEN 'NO'
            END 
        FROM ad_tcier 
        WHERE cier_fech = p_cfecha
		AND cier_sede = p_sede
        ;
        --
        --Cursor que me trae le valor maximo del cierre
        --
        c_valorMaximo CURSOR FOR
        SELECT COALESCE(MAX(CIER_CIER) , 0) 
          FROM AD_TCIER
        ;
        --
        --Cursor encargado de traer las facturas del dia en el cual se quiere hacer el cierre
        --
        c_traeFactura CURSOR FOR
        SELECT fact_fact,fact_vlr_total,fact_vlr_iva 
          FROM fa_tfact 
         WHERE fact_fec_ini =  p_cfecha
		 and fact_sede = p_sede
        ;
        
        c_traeDatos CURSOR FOR
        SELECT sum(fact_vlr_total),sum(fact_vlr_iva)
          FROM fa_tfact 
         WHERE fact_fec_ini =  p_cfecha
		 and fact_sede = p_sede
         ;
         
    BEGIN 
        --
        OPEN c_verifica_cierre;
        FETCH c_verifica_cierre INTO rta;
        CLOSE c_verifica_cierre;
        --
        IF rta = 'SI' THEN
            --
            RAISE EXCEPTION 'Error el cierre ya existe en la fecha % ' , p_cfecha;
            --
        END IF; 
        --
        OPEN c_traeDatos;
        FETCH c_traeDatos INTO vrl_tot,vlr_iva;
        CLOSE c_traeDatos;
        
        OPEN c_valorMaximo;
        FETCH c_valorMaximo INTO v_cierre_cierre;
        CLOSE c_valorMaximo;
        --
        v_cierre_cierre := v_cierre_cierre + 1 ;
        --
        IF vlr_iva is null THEN 
        --
            vlr_iva := 0;            
        --        
        END IF;
        --
        IF vrl_tot is null THEN 
        --
            vrl_tot := 0;            
        --        
        END IF;
        --
        INSERT INTO  ad_tcier (CIER_CIER,CIER_FECH,CIER_USUA,CIER_VLRI,CIER_VLRT,CIER_VLRC,CIER_SEDE,CIER_ESTADO)
        VALUES (v_cierre_cierre,p_cfecha,p_usuar,vlr_iva,vrl_tot,(vlr_iva+vrl_tot),p_sede,'A')
        ;
        --
        UPDATE fa_tfact 
           SET fact_cierre = v_cierre_cierre 
         WHERE fact_fec_ini = p_cfecha
        ;
        --
        RETURN 'Ok';
    --
    EXCEPTION WHEN OTHERS THEN
               RETURN 'ERROR IN_FINSERT_CIERRE_DIARIO ' || SQLERRM;        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION in_finsert_cierre_diario(date, integer, integer)
  OWNER TO postgres;

