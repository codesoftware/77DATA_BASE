--
--Funcion con la cual convierte una remision en una factura
--
CREATE OR REPLACE FUNCTION FA_REMISION_FACTURA (  
                                p_tius              BIGINT,
                                p_remi              BIGINT
                         )RETURNS VARCHAR AS $$
    DECLARE
        --
        v_secuencia     bigint :=  0;
        --
        c_detalle CURSOR IS
        SELECT drem_dska, drem_cantid, 0 descuento, drem_precio
          FROM in_tdrem
         WHERE drem_remi = p_remi
         ;
        --
        v_rta       varchar(1000) := '';
        --
        c_remision CURSOR IS
        SELECT remi_clien,remi_sede
          FROM in_tremi
         WHERE remi_remi = p_remi
         ;
        --
        v_clien     bigint := 0;
        v_sede      bigint := 0;
        --
        -- Cursor con el cual encuentro el id de la factura
        --
        c_fact_fact CURSOR (vc_expresion varchar) IS
        SELECT cast(kapr_kapr as bigint)
          FROM (
               SELECT regexp_split_to_table(vc_expresion, '-') kapr_kapr
               offset 1) as tabla
        ;
        --
        v_fact_fact         bigint:= 0;
        --
        c_idTemporal CURSOR IS
        SELECT coalesce(max(tem_fact),0) + 1
          FROM CO_TTEM_FACT
          ;
        --
        v_id_tem            bigint := 0;
        --
    BEGIN
        --
        OPEN c_remision;
        FETCH c_remision INTO v_clien,v_sede;
        CLOSE c_remision;
        --
        v_secuencia := cast(nextval('co_temp_tran_factu_sec')as int);
        --
        FOR prod IN c_detalle 
        LOOP
            --
            OPEN c_idTemporal;
            FETCH c_idTemporal into v_id_tem;
            CLOSE c_idTemporal;
            --
            INSERT INTO co_ttem_fact(
                            tem_fact,tem_fact_trans, tem_fact_dska, tem_fact_cant, tem_fact_dcto, 
                            tem_fact_pruni)
            VALUES (v_id_tem,v_secuencia , prod.drem_dska, prod.drem_cantid, prod.descuento, 
                        prod.drem_precio);
            --
            v_id_tem := 0;
            --
        END LOOP;
        --
        v_rta := FA_FACTURACION_X_PRECIO(
                                            p_tius,
                                            v_clien,
                                            v_secuencia,   
                                            v_sede,   
                                            cast('N/A' as varchar),
                                            cast(0 as bigint),
                                            cast(0 as bigint),
                                            cast(0 as bigint),
                                            cast('N' as varchar)
                                         );
        --
        IF upper(v_rta) like '%OK%' then
            --
            OPEN c_fact_fact(v_rta);
            FETCH c_fact_fact into v_fact_fact;
            CLOSE c_fact_fact;
            --
            UPDATE in_tremi
               SET remi_estado = 'FA',
                   remi_fact = v_fact_fact
            WHERE remi_remi = p_remi
            ;
            -- 
            return 'OK-'||v_fact_fact;
            --
        ELSE
            --
            raise exception 'Error FA_REMISION_FACTURA: %' ,v_rta ;
            --
        END IF;
        --
        
        --
    EXCEPTION WHEN OTHERS THEN
         return 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';