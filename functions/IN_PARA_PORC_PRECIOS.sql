--
-- Funcion con la cual se parametrizan los porcentajes de precios dependiendo la parametrizacion del sistema
--
CREATE OR REPLACE FUNCTION IN_PARA_PORC_PRECIOS (  
                                    p_sede              BIGINT,
                                    p_tius              BIGINT,
                                    p_cate              BIGINT,
                                    p_refe              BIGINT,
                                    p_marca             BIGINT,
                                    p_porcBase          BIGINT,
                                    p_porcUnid          BIGINT,
                                    p_porcDece          BIGINT,
                                    p_porcMill          BIGINT,
                                            ) RETURNS VARCHAR  AS $$
    DECLARE
    --
    c_categoria CURSOR FOR 
    SELECT cate_cate
      FROM in_tcate
     WHERE cate_cate = CASE WHEN - 1 = p_cate THEN cate_cate ELSE p_cate END
     ;
    --
    c_subCate CURSOR FOR
    SELECT refe_refe
      FROM in_trefe
     WHERE refe_refe = CASE WHEN - 1 = p_refe THEN refe_refe ELSE p_refe END
       AND refe_cate = CASE WHEN - 1 = p_cate THEN refe_cate ELSE p_cate END
     ;
    --
    c_marca CURSOR FOR
    SELECT marca_marca
      FROM in_tmarca
     WHERE marca_marca = CASE WHEN - 1 = p_marca THEN marca_marca ELSE p_marca END
      ;
    --
    BEGIN
    --
    FOR cate IN c_categoria LOOP
        --
        FOR refe IN c_subCate LOOP
            --
            FOR marca IN c_marca LOOP
            --
            UPDATE in_tpops
               SET pops_estado ='I'
             WHERE pops_sede = p_sede
               AND pops_cate = cate.cate_cate
               AND pops_refe = refe.refe_refe
               AND pops_marca = marca.marca_marca
               ;
            --
            INSERT INTO in_tpops(
                    pops_sede, pops_cate, pops_refe, pops_marca, 
                    pops_tius, pops_porc_base, pops_porc_uni, 
                    pops_porc_cent, pops_porc_mill)
            VALUES (
                    p_sede, cate.cate_cate, refe.refe_refe, marca.marca_marca, 
                    p_tius, p_porcBase, p_porcUnid, 
                    p_porcDece, p_porcMill);
            --
            END LOOP;
            --
        END LOOP;
        --
    END LOOP;
    --
    EXCEPTION 
        WHEN OTHERS THEN
         RETURN 'Error IN_PARA_PORC_PRECIOS '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';