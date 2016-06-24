--
--Funcion que VALIDA todo antes de realizar un conteo
--
CREATE OR REPLACE FUNCTION im_convierte_dolares_importacion(
                                p_impo              bigint,
                                p_trm               numeric,
                                p_tazaPromedio      numeric
                                ) RETURNS varchar AS $$

DECLARE 
    --
    --Cursor con el cual obtengo los productos de la importacion
    --
    c_prod_impo CURSOR FOR
    SELECT prim_prim, prim_vlrdolar
      FROM im_tprim
     WHERE prim_impo = p_impo
     ;
    --
    v_trm_prod          numeric(1000,10):= 0;
    v_taza_prod         numeric(1000,10):= 0;
    --
BEGIN
    --
    FOR prod IN c_prod_impo LOOP
        --
        v_trm_prod := prod.prim_vlrdolar * p_trm;
        v_taza_prod := prod.prim_vlrdolar * p_tazaPromedio;
        --
        UPDATE im_tprim 
           SET prim_vlrPesTRM = v_trm_prod,
               prim_vlrPesTzProm = v_taza_prod
         WHERE prim_prim = prod.prim_prim
         ;
        --
    END LOOP;
    --
    UPDATE im_timpo
       SET impo_trm = p_trm,
       impo_tazaProm = p_tazaPromedio
     WHERE impo_impo = p_impo
     ;
    --
    RETURN 'Ok';
    --
EXCEPTION WHEN OTHERS THEN
    RETURN 'Error ' || sqlerrm;
END;
$$ LANGUAGE 'plpgsql';
