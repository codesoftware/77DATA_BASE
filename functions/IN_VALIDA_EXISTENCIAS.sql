--
--funcion que realiza la solicitud
--
CREATE OR REPLACE function IN_VALIDA_EXISTENCIAS(
                  p_dska         BIGINT
                  ) RETURNS VARCHAR AS $$
    DECLARE
    --
    --Obtiene las existencias del producto
    --
    c_cons_exist CURSOR FOR
    SELECT cepr_existencia
      FROM in_tcepr
     WHERE cepr_dska = p_dska
    ;
    --
    c_cons_ex_sede  CURSOR FOR
    SELECT sum(eprs_existencia)
      FROM in_teprs
     WHERE eprs_dska = p_dska
    ;
    --
    v_exist_prod_tot                bigint:= 0;
    v_exist_prod_sed                bigint:= 0;
    --
    c_total_exi_in CURSOR (vc_sede      bigint) FOR
    SELECT sum(kapr_cant_mvto)
      FROM IN_TKAPR, IN_TMVIN
     WHERE KAPR_MVIN = MVIN_MVIN 
       AND MVIN_NATU = 'I'
       AND kapr_sede = vc_sede
       AND KAPR_DSKA = p_dska
       ;
    --
    c_total_exi_eg CURSOR (vc_sede      bigint) FOR
    SELECT sum(kapr_cant_mvto)
      FROM IN_TKAPR, IN_TMVIN
     WHERE KAPR_MVIN = MVIN_MVIN 
       AND MVIN_NATU = 'E'
       AND kapr_sede = vc_sede
       AND KAPR_DSKA = p_dska
       ;
    --
    v_ingresos_kapr         bigint := 0;
    v_egresos_kapr          bigint := 0;
    v_total_kapr            bigint := 0;
    v_ext_pr_sede           bigint := 0;
    --
    c_sedes_emp CURSOR FOR
    SELECT sede_sede
      FROM em_tsede
      ;
    --
    --Cursor con el cual evaluo si existe un producto en la tabla consolidada de existencias por sede
    --
    c_ex_prod_sede CURSOR(vc_sede bigint) FOR
    SELECT eprs_eprs
      FROM in_teprs
     WHERE eprs_dska = p_dska
       AND eprs_sede = vc_sede
       ;
    --
    BEGIN
    --
    OPEN c_cons_exist;
    FETCH c_cons_exist INTO v_exist_prod_tot;
    CLOSE  c_cons_exist;
    --
    OPEN c_cons_ex_sede;
    FETCH c_cons_ex_sede INTO v_exist_prod_sed;
    CLOSE c_cons_ex_sede;
    --
    IF v_exist_prod_tot <> v_exist_prod_sed THEN 
        --
        FOR sede IN c_sedes_emp LOOP
            --
            OPEN c_total_exi_in(sede.sede_sede);
            FETCH c_total_exi_in INTO v_ingresos_kapr;
            CLOSE  c_total_exi_in;
            --
            OPEN c_total_exi_eg(sede.sede_sede);
            FETCH c_total_exi_eg INTO v_egresos_kapr;
            CLOSE c_total_exi_eg;
            --
            IF v_ingresos_kapr is null THEN
                --
                v_ingresos_kapr := 0;
                --
            END IF;
            --
            IF v_egresos_kapr is null THEN
                --
                v_egresos_kapr := 0;
                --
            END IF;
            v_total_kapr := v_ingresos_kapr - v_egresos_kapr;
            --
            --
            IF v_total_kapr is null THEN 
                --
                v_total_kapr := 0;
                --
            END IF;
            --
            OPEN c_ex_prod_sede(sede.sede_sede);
            FETCH c_ex_prod_sede INTO v_ext_pr_sede;
            CLOSE c_ex_prod_sede;
            --
            IF v_ext_pr_sede is null THEN 
                --
                INSERT INTO IN_TEPRS(eprs_dska,eprs_existencia,eprs_sede)
                VALUES(p_dska, v_total_kapr,sede.sede_sede);
                --
            ELSE
                --
                UPDATE IN_TEPRS
                   SET eprs_existencia = v_total_kapr
                 WHERE eprs_sede = sede.sede_sede
                   AND eprs_dska = p_dska
                 ;
                 --
            END IF;
            --
        END LOOP;
        --
    END IF;
    --
    RETURN 'OK';
    --
    EXCEPTION WHEN 
        OTHERS THEN
            --
            return 'Error IN_VALIDA_EXISTENCIAS ' || sqlerrm;
    END;
    $$ LANGUAGE 'plpgsql';