--
--Funcion que VALIDA todo antes de realizar un conteo
--
CREATE OR REPLACE FUNCTION IM_CALCULOS_IMPORTACION(
                                p_impo              bigint
                                ) RETURNS varchar AS $$

DECLARE 
    --
    c_valor_fob CURSOR IS
    SELECT sum(prim_vlrpestrm * prim_cant)
      FROM im_tprim, im_timpo
     WHERE prim_impo = impo_impo 
       AND impo_impo = p_impo
       ;
    --
    v_valor_fob         numeric(1000,10):= 0;
    --
    c_valor_impo CURSOR IS
    SELECT sum(prim_vlrpestzprom * prim_cant)
      FROM im_tprim, im_timpo
     WHERE prim_impo = impo_impo 
       AND impo_impo = p_impo
       ;
    --
    v_valor_impo        numeric(1000,10):= 0;
    --
    
    --
BEGIN
    --
    OPEN c_valor_fob;
    FETCH c_valor_fob INTO v_valor_fob;
    CLOSE c_valor_fob;
    --
    OPEN c_valor_impo;
    FETCH c_valor_impo INTO v_valor_impo;
    CLOSE c_valor_impo;
    --
    
    --
    RETURN 'Ok';
    --
EXCEPTION WHEN OTHERS THEN
    RETURN 'Error im_convierte_dolares_importacion' || sqlerrm;
END;
$$ LANGUAGE 'plpgsql';
