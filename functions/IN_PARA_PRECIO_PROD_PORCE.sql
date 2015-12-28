--
-- Funcion con la cual por medio de un precio base se calculan todos los precios posible
--
CREATE OR REPLACE FUNCTION IN_PARA_PRECIO_PROD_PORCE(
                                                    p_user          BIGINT,
                                                    p_sede          BIGINT,
                                                    p_dska          BIGINT,
                                                    p_precio        NUMERIC(1000,10)
                                                 )RETURNS VARCHAR  AS $$
    DECLARE
    --    
    v_porc_precio           NUMERIC(1000,10) := 0;
    v_precio                NUMERIC(1000,10) := 0;
    v_prom_pod              NUMERIC(1000,10) := 0;
    v_iva_precio            NUMERIC(1000,10) := 0;
    v_auxiliar              NUMERIC(1000,10) := 0;
    v_modulo                NUMERIC(1000,10) := 0;
    v_faltante              NUMERIC(1000,10) := 0;
    v_modulo_pre_mayor      NUMERIC(1000,10) := 0;
    v_unidad                NUMERIC(1000,10) := 0;
    v_centenas              NUMERIC(1000,10) := 0;
    v_millar                NUMERIC(1000,10) := 0;
    --
    --Cursor con el cual obtengo el porcentaje para calcular el precio dependiendo su categoria
    --
    c_porcentaje_precio CURSOR IS
    select cate_porcentaje
      from in_tdska, in_tcate
     where dska_cate = cate_cate
       and dska_dska = p_dska
       ;
    --
    --Cursor con el cual obtengo el promedio ponderado del producto
    --
    c_prom_pod  CURSOR IS
    SELECT cepr_promedio_uni
      FROM in_tcepr
     WHERE cepr_dska = p_dska
    ;
    --
    --Cursor que obtiene el iva parametrizado
    --
    c_iva_precio CURSOR IS
    SELECT cast(para_valor as numeric)
      FROM em_tpara
     WHERE para_clave = 'IVAPRVENTA'
    ;
    --
    --Obtiene la descripcion de la categoria
    --
    c_tipo_cate CURSOR IS
    SELECT upper(cate_desc)
      FROM in_tdska, in_tcate
     WHERE dska_cate = cate_cate
       AND dska_dska = p_dska
    ;
    --
    v_desc_cat      varchar(500) := '';
    --
    BEGIN
        --
        OPEN c_porcentaje_precio;
        FETCH c_porcentaje_precio INTO v_porc_precio;
        CLOSE c_porcentaje_precio;
        --
        OPEN c_prom_pod;
        FETCH c_prom_pod INTO v_prom_pod;
        CLOSE c_prom_pod;
        --
        OPEN c_iva_precio;
        FETCH c_iva_precio INTO v_iva_precio;
        CLOSE c_iva_precio;
        --
        UPDATE in_tprpr
           SET prpr_estado = 'I'
         WHERE prpr_sede = p_sede
           AND prpr_dska = p_dska
           ;
        --
        --Le sumo el porcentaje parametrizado para la categoria que tiene el producto
        --
        --
        v_precio := ((v_prom_pod*v_porc_precio)/100.0000) + v_prom_pod;
        --
        --Sumo el iva
        --
        v_precio := (( v_precio * v_iva_precio )/100.00) + v_precio;
        --
        --
        --Redondeo el precio
        --
        IF v_precio < 50 THEN
            --
            v_precio := 50;
            --
        ELSIF v_precio between 50 and 100 THEN
            --
            v_precio := 100;
            --
        ELSIF v_precio between 100 and 10000 THEN
            --
            v_modulo := v_precio % 100;
            v_faltante := 100 - v_modulo;
            v_precio := v_precio + v_faltante;
            v_precio := round(v_precio);
            --
        ELSE
            --
            v_modulo := v_precio % 1000;
            v_faltante := 1000 - v_modulo;
            v_precio := v_precio + v_faltante;
            v_precio := round(v_precio);
            --
        END IF;
        --Saco la base del iva
        v_auxiliar := 100.00;
        --
        v_auxiliar :=  (v_iva_precio / v_auxiliar)+1;
        --
        v_precio :=  v_precio /v_auxiliar;
        --
        --Calculos para precios por unidad, centena y millar
        --
        OPEN c_tipo_cate;
        FETCH c_tipo_cate INTO v_desc_cat;
        CLOSE c_tipo_cate;
        --
        IF v_desc_cat = 'TORNILLOS' THEN
            --
            v_millar := 0;
            v_centenas := 0;
            v_unidad := 0;
            --
            --Calculos para los precios por unidad, centena y millar
            --
            v_millar := ((v_prom_pod * 20.00 )/100.00) + v_prom_pod;
            --
            v_centenas := ((v_prom_pod * 25.00 )/100.00) + v_prom_pod;
            --
            v_unidad := ((v_prom_pod * 30.00 )/100.00) + v_prom_pod;
            --
            v_millar := (( v_millar * v_iva_precio )/100.00) + v_millar;
            --
            v_centenas := (( v_centenas * v_iva_precio )/100.00) + v_centenas;
            --
            v_unidad := (( v_unidad * v_iva_precio )/100.00) + v_unidad;
            --
        ELSE
            --
            v_millar := 0;
            v_centenas := 0;
            v_unidad := 0;
            --
            --Calculos para los precios por unidad, centena y millar
            --
            v_millar := ((v_prom_pod * 18.00 )/100.00) + v_prom_pod;
            --
            v_centenas := ((v_prom_pod * 28.00 )/100.00) + v_prom_pod;
            --
            v_unidad := ((v_prom_pod * 35.00 )/100.00) + v_prom_pod;
            --
            v_millar := (( v_millar * v_iva_precio )/100.00) + v_millar;
            --
            v_centenas := (( v_centenas * v_iva_precio )/100.00) + v_centenas;
            --
            v_unidad := (( v_unidad * v_iva_precio )/100.00) + v_unidad;
            --
            v_modulo_pre_mayor := v_unidad % 100;
            v_faltante :=  100 -  v_modulo_pre_mayor;
            v_unidad := v_unidad + v_faltante;
            --
            v_modulo_pre_mayor := v_centenas % 100;
            v_faltante :=  100 -  v_modulo_pre_mayor;
            v_centenas := v_centenas + v_faltante;
            --
            v_modulo_pre_mayor := v_millar % 100;
            v_faltante :=  100 -  v_modulo_pre_mayor;
            v_millar := v_millar + v_faltante;
            --
        END IF;
        --
        --Evaluo si le envio un precio diferente de cero esto quiere decir que no utilizara el calculo sobre el costo para el precio base
        --
        IF p_precio <> 0 THEN
            --
            IF p_precio <= v_prom_pod THEN
                --
                RAISE EXCEPTION 'El precio del producto no puede ser menor ni igual al promedio ponderado del producto, promedio ponderado: % ',v_prom_pod;
                --
            ELSE
                --
                --Saco la base del iva
                v_auxiliar := 100.00;
                --
                v_auxiliar :=  (v_iva_precio / v_auxiliar)+1;
                --
                v_precio :=  p_precio /v_auxiliar;
                --
            END IF;
            --
        END IF;
        --
        --Insercion del precio
        --
        INSERT INTO in_tprpr(
                    prpr_dska, prpr_precio, prpr_tius_crea, prpr_tius_update, 
                    prpr_estado, prpr_sede, prpr_preu,prpr_prec,prpr_prem)
            VALUES (p_dska, v_precio , p_user , p_user,
                    'A', p_sede,v_unidad,v_centenas,v_millar);
        --
        RETURN 'Ok';
        --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error IN_PARA_PRECIO_PROD_PORCE  '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';