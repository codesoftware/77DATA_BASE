--
-- Funcion con la cual se cambian los precios de los productos teniendo en cuenta parametros especificos
--
CREATE OR REPLACE FUNCTION IN_EJECUTA_MASIVOS (  
                                    p_sede              BIGINT,
                                    p_tius              BIGINT,
                                    p_cate              BIGINT,
                                    p_refe              BIGINT,
                                    p_marca             BIGINT
                                            ) RETURNS VARCHAR  AS $$
    DECLARE
    --
    v_contador      bigint:= 0;
    --
    c_productos  CURSOR IS
    select dska_dska
      from in_tdska
     where dska_cate = CASE WHEN - 1 = p_cate THEN dska_cate ELSE p_cate END
       and dska_refe = CASE WHEN - 1 = p_refe THEN dska_refe  ELSE p_refe END
       and dska_marca = CASE WHEN - 1 = p_marca THEN dska_marca ELSE p_marca END
       --and 'S' <> (select prpr_estatic from in_tprpr where prpr_dska = dska_dska and prpr_estado = 'A' and prpr_sede = p_sede)
       ;
    --
    c_estatic_prod CURSOR(vc_dska   bigint) FOR
    SELECT prpr_estatic
      FROM in_tprpr
     WHERE prpr_dska = vc_dska
       and prpr_estado = 'A'
       and prpr_sede = p_sede
       ;
    --
    v_estatic           varchar(2):= '';
    --
    v_valida            varchar(4000):= '';
    --
    BEGIN
    --
    FOR prod in c_productos LOOP
        --
        OPEN c_estatic_prod(prod.dska_dska);
        FETCH c_estatic_prod into v_estatic;
        CLOSE c_estatic_prod;
        --
        IF v_estatic <> 'S' THEN
            --
            v_valida := IN_PARA_PRECIO_PROD_PORCE(1,p_sede,prod.dska_dska, 0);
            --
            IF upper(v_valida) NOT LIKE '%OK%' THEN
                --
                RAISE EXCEPTION ' % ',v_valida;
                --
            END IF;
            --
            v_contador := v_contador + 1;
            --
        END IF;
        --
    END LOOP;
    --
    RETURN 'Ok-'||v_contador;
    --
    EXCEPTION 
        WHEN OTHERS THEN
         RETURN 'Error IN_EJECUTA_MASIVOS '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';