--
--Funcion que VALIDA todo antes de realizar un conteo
--
CREATE OR REPLACE FUNCTION IN_INSERTA_PROD_IMPORTACION(
                                p_impo              bigint,
                                p_cod_ext           varchar,
                                p_cantidad          BIGINT,
                                p_precio            NUMERIC
                                ) RETURNS varchar AS $$

DECLARE 
    --
    --Cursor con el cual evaluo si el producto existe en la importacion
    --
    c_prod_impo CURSOR FOR
    SELECT prim_prim
      FROM im_tprim
     WHERE prim_dska = (select dska_dska from in_tdska where upper(dska_cod_ext) = upper(trim(p_cod_ext)))
       AND prim_impo = p_impo
     ;
    --
    v_prim_prim           BIGINT := 0;
    --
    c_busca_dska CURSOR FOR
    SELECT dska_dska
      FROM in_tdska
     WHERE dska_cod_ext = p_cod_ext
     ;
    --
    v_dska_dska             bigint  := 0;
    --
BEGIN
    --
    OPEN c_prod_impo;
    FETCH c_prod_impo INTO v_prim_prim;
    CLOSE c_prod_impo;
    --
    OPEN c_busca_dska;
    FETCH c_busca_dska INTO v_dska_dska;
    CLOSE c_busca_dska;
    --
    IF v_dska_dska is null THEN
        --
        RAISE EXCEPTION 'El producto con el codigo externo % no existe en el sistema por favor ingreselo',p_cod_ext;
        --
    END IF;
    --
    IF v_prim_prim is null THEN 
        --Debo insertar
        INSERT INTO im_tprim (prim_impo ,prim_dska  ,prim_cant,prim_vlrDolar,prim_vlrPesTRM,prim_vlrPesTzProm)
                     VALUES  (p_impo    ,v_dska_dska,p_cantidad,p_precio,0,0);
        --
    ELSE 
        --Debo actualizar
        update im_tprim
        set prim_cant = p_cantidad,
        prim_vlrDolar = p_precio
        where prim_prim = v_prim_prim
        ;
        --
    END IF;
    --
    RETURN 'Ok';
    --
EXCEPTION WHEN OTHERS THEN
    RETURN 'Error ' || sqlerrm;
END;
$$ LANGUAGE 'plpgsql';
