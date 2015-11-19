--
--Funcion encargada de Realizar el cierre del conteo 
--(Todos los calculos y los inserts de los productos que no se contaron)
--

CREATE OR REPLACE FUNCTION IN_OBTIENEEXIS_PROD_SEDE(  
                                                p_sede_sede         int,                                                        
                                                p_dska_dska         int
                                           ) RETURNS NUMERIC  AS $$
    DECLARE
        --
        --Cursor utilizado para obtener los ingresos de un producto por sede
        --
        c_ingresos CURSOR FOR
        SELECT coalesce(sum(kapr_cant_mvto),0)
          FROM in_tmvin, in_tkapr   
         WHERE mvin_natu = 'I'      
           AND mvin_mvin = kapr_mvin
           AND kapr_sede = p_sede_sede
           AND kapr_dska = p_dska_dska
           ;
        --
        --Cursor utilizado para obtener los egresos de un producto por sede
        --
        c_egresos CURSOR FOR
        SELECT coalesce(sum(kapr_cant_mvto),0)
          FROM in_tmvin, in_tkapr   
         WHERE mvin_natu = 'E'
           AND mvin_mvin = kapr_mvin
           AND kapr_sede = p_sede_sede
           AND kapr_dska = p_dska_dska
           ;
        --
        --Variables utilizadas para los ingresos y los egresos
        --
        v_ingresos          numeric(15,6):=0; 
        v_egresos           numeric(15,6):=0;
        v_total             numeric(15,6):=0;
        --
    BEGIN
        --
        OPEN c_ingresos;
        FETCH c_ingresos INTO v_ingresos;
        CLOSE c_ingresos;
        --
        OPEN c_egresos;
        FETCH c_egresos INTO v_egresos;
        CLOSE c_egresos;
        --
        v_total := v_ingresos - v_egresos;
        --
        RETURN v_total;
        --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';