--
-- Funcion con la cual por medio de un precio base se calculan todos los precios posible
--
CREATE OR REPLACE FUNCTION IN_PARA_PRECIO_PROD_PORCE(
                                                    p_user          BIGINT,
                                                    p_sede          BIGINT,
                                                    p_dska          BIGINT,
                                                    p_precio        NUMERIC(1000,10),
                                                    p_estatic       VARCHAR(2)          default 'N',
                                                    p_unid          NUMERIC(1000,10)    default 0 ,
                                                    p_dece          NUMERIC(1000,10)    default 0 ,
                                                    p_millar        NUMERIC(1000,10)    default 0 
                                                 )RETURNS VARCHAR  AS $$
    DECLARE
    --    
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
    v_porcBase              NUMERIC(1000,10) := 0;
    v_porcUnid              NUMERIC(1000,10) := 0;
    v_porcCent              NUMERIC(1000,10) := 0;
    v_porcMill              NUMERIC(1000,10) := 0;    
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
    --Cursor con el cual obtengo los porcentajes para realizar la parametrizacion del precio del producto
    --
    c_porcentajes_dska CURSOR IS
    SELECT pops_porc_base, pops_porc_uni, pops_porc_cent, pops_porc_mill
      FROM IN_TDSKA, IN_TPOPS
     WHERE DSKA_DSKA = p_dska
       AND DSKA_CATE = POPS_CATE
       AND DSKA_REFE = POPS_REFE
       AND DSKA_MARCA = POPS_MARCA
       and pops_estado = 'A'
       and pops_sede = p_sede
     ORDER BY pops_fecha DESC
    ;
    --
    --Codigo externo, y nombre de producto
    --
    c_datos_prod CURSOR IS
    SELECT dska_nom_prod, dska_cod_ext
      FROM in_tdska
     WHERE dska_dska = p_dska
      ;
    --
    v_nombre            varchar(4000) := '';
    v_codigoExt         varchar(4000) := '';
    --
    BEGIN
        --
        IF p_estatic <> 'N' THEN
            --
            IF p_unid = 0 or p_dece = 0 or p_millar = 0 THEN
                --
                RAISE EXCEPTION 'Cuando el precio es estatico se deben enviar los parametros unidad, decena y millar diferentes de cero.';                --
                --
            END IF;
            --
        END IF;
        --
        OPEN c_porcentajes_dska;
        FETCH c_porcentajes_dska INTO v_porcBase,v_porcUnid,v_porcCent,v_porcMill;
        CLOSE c_porcentajes_dska;
        --
        IF v_porcBase is null THEN
            --
            OPEN c_datos_prod;
            FETCH c_datos_prod INTO v_nombre,v_codigoExt;
            CLOSE c_datos_prod;
            --
            RAISE EXCEPTION 'El producto con el nombre % y el codigo % no tiene ningun porcentaje parametrizado', v_nombre,v_codigoExt;
            --
        END IF;
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
        v_precio := ((v_prom_pod*v_porcBase)/100.0000) + v_prom_pod;
        --
        --Sumo el iva
        --
        v_precio := (( v_precio * v_iva_precio )/100.00) + v_precio;
        --
        --
        --Redondeo el precio
        --
        --IF v_precio < 50 THEN
        --    --
        --    v_precio := 50;
        --    --
        --ELSIF v_precio between 50 and 100 THEN
        --    --
        --    v_precio := 100;
        --    --
        --ELSIF v_precio between 100 and 10000 THEN
        --    --
        --    v_modulo := v_precio % 100;
        --    v_faltante := 100 - v_modulo;
        --    v_precio := v_precio + v_faltante;
        --    v_precio := round(v_precio);
        --    --
        --ELSE
        --    --
        --    v_modulo := v_precio % 1000;
        --    v_faltante := 1000 - v_modulo;
        --    v_precio := v_precio + v_faltante;
        --    v_precio := round(v_precio);
        --    --
        --END IF;
        --Saco la base del iva
        v_auxiliar := 100.00;
        --
        v_auxiliar :=  (v_iva_precio / v_auxiliar)+1;
        --
        v_precio :=  v_precio /v_auxiliar;
        --
        v_millar := 0;
        v_centenas := 0;
        v_unidad := 0;
        --
        --Calculos para los precios por unidad, centena y millar
        --
        v_millar := ((v_prom_pod * v_porcMill )/100.00) + v_prom_pod;
        --
        v_centenas := ((v_prom_pod * v_porcCent )/100.00) + v_prom_pod;
        --
        v_unidad := ((v_prom_pod * v_porcUnid )/100.00) + v_prom_pod;
        --
        v_millar := (( v_millar * v_iva_precio )/100.00) + v_millar;
        --
        v_centenas := (( v_centenas * v_iva_precio )/100.00) + v_centenas;
        --
        v_unidad := (( v_unidad * v_iva_precio )/100.00) + v_unidad;
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
        IF p_estatic = 'N' THEN
            --
            INSERT INTO in_tprpr(
                        prpr_dska, prpr_precio, prpr_tius_crea, prpr_tius_update, 
                        prpr_estado, prpr_sede, prpr_preu,prpr_prec,prpr_prem)
                VALUES (p_dska, v_precio , p_user , p_user,
                        'A', p_sede,v_unidad,v_centenas,v_millar);
            --
        ELSE
            --
            --
            INSERT INTO in_tprpr(
                        prpr_dska, prpr_precio, prpr_tius_crea, prpr_tius_update, 
                        prpr_estado, prpr_sede, prpr_preu,prpr_prec,prpr_prem,prpr_estatic)
                VALUES (p_dska, v_precio , p_user , p_user,
                        'A', p_sede,p_unid,p_dece,p_millar,p_estatic);
            --
            --
        END IF;
        RETURN 'Ok';
        --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error IN_PARA_PRECIO_PROD_PORCE  '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';