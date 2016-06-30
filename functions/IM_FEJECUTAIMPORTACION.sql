--
--funcion que realiza la solicitud
--
CREATE OR REPLACE function IM_FEJECUTAIMPORTACION(
                  p_tius         bigint,
                  p_impo         bigint
                  ) RETURNS VARCHAR AS $$
    DECLARE
    --
    c_valida_trm_tasa CURSOR  FOR
    SELECT impo_trm,  impo_tazaprom, impo_estado
      FROM im_timpo
     WHERE impo_impo = p_impo
      ;
    --
    --Obtengo el id de la tabla temporal de movimientos contables
    --
    c_sec_contabilidad CURSOR IS
    SELECT CAST(nextval('co_temp_movi_contables') AS INT)
    ;
    v_trm               numeric(1000,10) := 0; 
    v_taza              numeric(1000,10) := 0;
    v_estado            varchar(10) := '';
    --
    v_valida            varchar(1000) := '';
    --
    --Cursor con el cual obtengo los productos de la importacion
    --
    c_prod_impo CURSOR FOR
    SELECT prim_prim, prim_dska, prim_cant, prim_vlrdolar, prim_vlrpestrm, 
       prim_vlrpestzprom
      FROM im_tprim
     WHERE prim_impo = p_impo 
      ;
    --
    --Cursor para obtener el codigo de la subcuenta
    --
    c_sbcu_prod CURSOR(vc_dska_dska  bigint) FOR
    SELECT sbcu_codigo
      FROM in_tdska, co_tsbcu
      WHERE sbcu_sbcu = dska_sbcu
       AND dska_dska = vc_dska_dska
       ;
     --
     v_sbcu_prod                     V ARCHAR(500)     := '';
     --
     v_sec_cont                      BIGINT :=0;
     --
    BEGIN
    --
    OPEN c_valida_trm_tasa;
    FETCH c_valida_trm_tasa into v_trm,v_taza,v_estado;
    CLOSE c_valida_trm_tasa;
    --
    IF v_estado <> 'A' THEN
        --
        RAISE EXCEPTION 'La importacion debe tener el estado activo, imposible realizar el proceso';
        --
    END IF;
    --
    IF v_trm is null OR  v_taza is null THEN
        --
        RAISE EXCEPTION 'La taza promedio de la importacion no puede ser nula por favor ingresela ';
        --
    ELSE
        --
        v_valida := im_convierte_dolares_importacion(p_impo,v_trm,v_taza);
        --
    END IF;
    --
    OPEN c_sbcu_prod(prod.fcprd_dska);
    FETCH c_sbcu_prod INTO v_sbcu_prod;
    CLOSE c_sbcu_prod;
    --
    OPEN c_sec_contabilidad;
    FETCH c_sec_contabilidad INTO v_sec_cont;
    CLOSE c_sec_contabilidad;
    --
    FOR prod in c_prod_impo LOOP
        --
        
        --
    END LOOP;
    --
    RETURN 'OK';
    --
    EXCEPTION WHEN 
        OTHERS THEN
            --
            return 'Error IM_FEJECUTAIMPORTACION ' || sqlerrm;
    END;
    $$ LANGUAGE 'plpgsql';