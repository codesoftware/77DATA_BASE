--
--funcion que realiza la solicitud
--
CREATE OR REPLACE function FA_ENVIASOLICITUD(
                  p_tius         BIGINT,
                  p_soli         BIGINT
                  ) RETURNS VARCHAR AS $$
    DECLARE
    --
    --Cursor encargado de consultar los datos de la solicitud
    --
    c_consultasoli  CURSOR IS 
    SELECT soli_esta,soli_sede
    FROM fa_tsoli 
    WHERE soli_soli = p_soli
    ;
    --
    --cursor encargado de consultar los productos de la solicitud
    --
    c_consultaprdsoli CURSOR FOR
    SELECT sopd_dska,sopd_cenv,sopd_sede,sopd_sopd
    FROM fa_tsopd
    WHERE sopd_soli = p_soli
    ;
    --
    v_estado        varchar(2):= '';
    v_sede          bigint:= 0;
    --
    --cursor encargado de validar existencias por sede
    --
    c_exist_sede CURSOR (vc_dska bigint,vc_sede bigint)FOR
    SELECT eprs_existencia
      FROM in_teprs
     WHERE eprs_dska = vc_dska
       AND eprs_sede = vc_sede
       ;
    --
    v_exist_sede            bigint;
    --
    --
    --Cursor el cual obtiene el movimiento de inventario de ingreso
    --
    c_mvin_ing CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_cambsede_ing = 'S'
     ;
    --
    --Cursor el cual obtiene el movimiento de inventario de egreso
    -- 
    c_mvin_egr CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_cambsede_egr = 'S'
     ; 
    --
    --Variables utilizadas para los movimientos de inventario implicados
    --
    v_mvin_egr      bigint   := 0;
    v_mvin_ing      bigint   := 0;
    --
    c_promedio CURSOR(vc_dska bigint) FOR
    select cepr_promedio_uni
      from in_tcepr
     where cepr_dska = vc_dska
    ;     
    --
    v_promedio_pond     numeric(1000,10):= 0 ;
    --
    v_rta_ing       varchar(600) := '';
    v_rta_egr       varchar(600) := '';
    --
    v_costo_total      NUMERIC(1000,10) := 0;
    --
    -- Cursor con el cual encuentro el id del movimiento de inventario
    --
    c_kapr_kapr CURSOR (vc_expresion varchar) IS
    SELECT cast(kapr_kapr as int)
      FROM (
           SELECT regexp_split_to_table(vc_expresion, '-') kapr_kapr
           offset 1) as tabla
    ;
    --
    v_kapr_kapr         bigint := 0;
    --
    BEGIN
    --
    OPEN c_consultasoli;
    FETCH c_consultasoli into v_estado,v_sede;
    close c_consultasoli;
    --
    IF v_estado = 'C' THEN
        --
        FOR producto IN c_consultaprdsoli LOOP 
            --
            IF producto.sopd_sede = v_sede THEN
                --
                RAISE EXCEPTION 'El producto % no puede ser enviado a la misma sede ',producto.sopd_dska;
                --
            END IF;
            --
            OPEN c_exist_sede(producto.sopd_dska,producto.sopd_sede);
            fetch c_exist_sede into v_exist_sede;
            close c_exist_sede;
            --
            IF v_exist_sede is null THEN
                --
                raise exception 'El producto con el codigo 1-% en la sede % no tiene existencias',producto.sopd_dska,producto.sopd_sede;
                --
            END IF;
            --
            IF v_exist_sede < producto.sopd_cenv THEN
                --
                raise exception 'La cantidad que desea enviar no puede superar la existente en la sede ' ;
                --
            END IF;
            --
                OPEN c_mvin_ing;
                FETCH c_mvin_ing INTO v_mvin_ing;
                CLOSE c_mvin_ing;
                --
                OPEN c_mvin_egr;
                FETCH c_mvin_egr INTO v_mvin_egr;
                CLOSE c_mvin_egr;
                --
                OPEN c_promedio(producto.sopd_dska);
                FETCH c_promedio INTO v_promedio_pond;
                CLOSE c_promedio;
                --
                v_costo_total := v_promedio_pond * producto.sopd_cenv;
                --
                --Realizamos el ingreso del producto
                --
                v_rta_ing := IN_FINSERTA_PROD_KARDEX(   producto.sopd_dska,
                                                        v_mvin_ing,
                                                        p_tius,
                                                        producto.sopd_cenv,
                                                        v_costo_total,
                                                        v_sede
                                                        );
                --
                OPEN c_kapr_kapr(v_rta_ing);
                FETCH c_kapr_kapr INTO v_kapr_kapr;
                CLOSE c_kapr_kapr;
                --
                UPDATE FA_TSOPD
                   SET sopd_kapr = v_kapr_kapr
                 WHERE sopd_sopd = producto.sopd_sopd 
                 ;
                --
                IF UPPER(v_rta_ing) like '%OK%' THEN
                    --
                    
                    v_rta_egr := IN_FINSERTA_PROD_KARDEX(   producto.sopd_dska,
                                                            v_mvin_egr,
                                                            p_tius,
                                                            producto.sopd_cenv,
                                                            v_costo_total,
                                                            producto.sopd_sede                                                   
                                                            );
                    IF UPPER(v_rta_egr) not like '%OK%' THEN
                    --
                        RAISE EXCEPTION 'Error al realizar el ingreso: %' , v_rta_egr;
                    --
                    ELSE 
                        --
                        OPEN c_kapr_kapr(v_rta_egr);
                        FETCH c_kapr_kapr INTO v_kapr_kapr;
                        CLOSE c_kapr_kapr;
                        --
                        UPDATE FA_TSOPD
                           SET sopd_kapr_eg = v_kapr_kapr
                         WHERE sopd_sopd = producto.sopd_sopd 
                         ;
                        --
                    END IF;                             
                    --
                ELSE
                    --
                    RAISE EXCEPTION 'Error al realizar el egreso: %' , v_rta_egr;
                    --
                END IF;
            --
        END LOOP;
        --
    ELSE
        --
        raise exception 'El estado de la solicitud no es permitido';
        --
    END IF;
    --
    UPDATE fa_tsoli
       SET soli_esta = 'A'
     WHERE soli_soli = p_soli
    ;
    --
    RETURN 'OK';
    --
    EXCEPTION WHEN 
        OTHERS THEN
            --
            return 'Error FA_ENVIASOLICITUD ' || sqlerrm;
    END;
    $$ LANGUAGE 'plpgsql';