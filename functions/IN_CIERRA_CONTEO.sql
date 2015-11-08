--
--Funcion encargada de Realizar el cierre del conteo 
--(Todos los calculos y los inserts de los productos que no se contaron)
--

CREATE OR REPLACE FUNCTION IN_CIERRA_CONTEO(  
                                                p_copr_copr         INT                                                        
                                           ) RETURNS VARCHAR  AS $$
    DECLARE
        --
        --Cursor encargado de obtener todos los productos del sistema
        --
        c_productos CURSOR FOR
        SELECT dska_dska
          FROM in_tdska
          ;
        --
        c_conteo CURSOR (vc_dska_dska int) IS
        select ecop_ecop, ecop_valor
          from in_tecop
         where ecop_dska = vc_dska_dska
           and ecop_copr = p_copr_copr
           ;
        --
        v_ecop_ecop             int := 0;
        v_ecop_valor            int := 0;
        v_exist_prod            numeric(15,5) := 0;
        --
        --Cursor utilizado para saber sobre que sede se esta realizando el conteo
        --
        c_sede_conteo CURSOR FOR
        SELECT copr_sede
          FROM in_tcopr
         WHERE copr_copr = p_copr_copr
          ;
        --
        v_sede_sede         int := 0;
        v_diferencia        NUMERIC(15,6) := 0;
        --
    BEGIN
        --
        OPEN c_sede_conteo;
        FETCH c_sede_conteo INTO v_sede_sede;
        CLOSE c_sede_conteo;
        --
        FOR prod IN c_productos
        LOOP
            --
            v_exist_prod := IN_OBTIENEEXIS_PROD_SEDE(v_sede_sede,prod.dska_dska); 
            --
            OPEN c_conteo(prod.dska_dska);
            FETCH c_conteo INTO v_ecop_ecop,v_ecop_valor;
            CLOSE c_conteo;
            --
            IF v_ecop_ecop IS NULL THEN  
                --
               INSERT INTO in_tecop(
                            ecop_ecop, ecop_copr, ecop_dska, ecop_valor, ecop_existencias, 
                            ecop_diferencia)
                    VALUES ((select coalesce(max(ecop_ecop),0) + 1 from in_tecop), 
                                p_copr_copr, 
                                prod.dska_dska,
                                0,
                                v_exist_prod, 
                                v_exist_prod);
                --
            ELSE
                --
                v_diferencia :=  v_exist_prod - v_ecop_valor;
                --
                UPDATE in_tecop
                   SET ecop_diferencia = v_diferencia,
                   ecop_existencias = v_exist_prod
                 WHERE ecop_ecop = v_ecop_ecop
                 ;
            END IF;
            --            
        END LOOP;        
        --
        UPDATE in_tcopr
           SET copr_estado = 'X',
           copr_fec_fin = now()
         WHERE copr_copr = p_copr_copr
         ;
        --
        RETURN 'Ok';
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';