--
-- Funcion con la cual obtengo el registro 
--
CREATE OR REPLACE FUNCTION IN_REGISTRA_PRODUCTO (    
                                        p_refe_refe         INT, 
                                        p_descripcion       VARCHAR(100),  --Este campo es la descripcion que da el usuario es el que quiera el usuario (El nombre es la referencia)
                                        p_marca             INT, 
                                        p_categoria         INT
                                            ) RETURNS varchar AS $$
    DECLARE
    --
    --Validacion de datos 
    --
    c_valCate CURSOR FOR
    SELECT COUNT(*)
      FROM in_tcate
     WHERE cate_cate = p_categoria
     ;
    --Valida referencia o subcategoria
    c_valRefe CURSOR FOR
    SELECT COUNT(*)
      FROM in_trefe
     WHERE refe_refe = p_refe_refe
    ;
    --Valida Marca o tipo en los tornillos
    c_valMarca CURSOR FOR
    SELECT count(*)
      FROM in_tmarca
     WHERE marca_marca = p_marca
     ;
    --Valida repetidos
    c_validaRepe CURSOR FOR
    SELECT count(*)
      FROM in_tdska
     WHERE dska_refe = p_refe_refe
       AND dska_marca = p_marca
       AND dska_cate = p_categoria
       AND UPPER(TRIM(dska_desc)) = upper(trim(p_descripcion))
       ;
     --Codigo Repetido
    c_prodRepe CURSOR FOR
    SELECT dska_cod
      FROM in_tdska
     WHERE dska_refe = p_refe_refe
       AND dska_marca = p_marca
       AND dska_cate = p_categoria
       ;
    --
    v_valCate       INT := 0;
    v_valRefe       INT := 0;
    v_valMarca      INT := 0;
    v_valRep        INT := 0;
    --
    v_codRep        varchar(200) := '';
    --
    --Obtencion del id del producto
    --
    c_dska_dska CURSOR FOR
    SELECT coalesce(max(dska_dska),0)+ 1 as dska_dska
      FROM in_tdska
    ;
    --
    --Generacion del codigo
    --
    c_codigo CURSOR FOR
    SELECT '1-' || coalesce(count(*), 0 )+1 AS Id
      FROM in_tdska 
      ;
    --
    v_dska_dska         INTEGER := 0;
    v_codigo            VARCHAR(100) := '';
    v_cod_prod          VARCHAR(100) := '';
    --
    --
    --Cursor con el cual obtengo el valor de la subcuenta de la categoria
    --
    c_categoria CURSOR FOR
    SELECT cate_sbcu, cate_cate,cate_desc
      FROM in_tcate
     WHERE cate_cate = p_categoria
       AND cate_estado = 'A'
     ;
    --
    v_cate_cate             int := 0;
    v_cate_sbcu             int := 0;
    v_cate_desc             varchar(100):= '';
    --
    v_codigosbcu            varchar(50) :='';
    --
    --
    --Obtiene el valor de la secuencia para la insecion de subcuentas
    --
    c_sec_sbcu CURSOR FOR
    SELECT nextval('co_tsbcu_sbcu_sbcu_seq');
    --
    v_sbcu_sbcu     INTEGER := 0;        --Id de la futura subcuenta
    --
    c_codigo_sbcu CURSOR (vc_sbcu_sbcu int) IS
    SELECT substring(sbcu_codigo from character_length(sbcu_codigo)-1 for character_length(sbcu_codigo))
      FROM co_tsbcu
     WHERE sbcu_sbcu = vc_sbcu_sbcu
     ;
    --
    BEGIN
    --
    OPEN c_valCate;
    FETCH c_valCate INTO v_valCate;
    CLOSE c_valCate;
    --
    IF v_valCate = 0 THEN
        --
        RAISE EXCEPTION 'La categoria a la cual se le desea ingresar al producto no existe';
        --
    END IF;
    --
    --
    OPEN c_valRefe;
    FETCH c_valRefe INTO v_valRefe;
    CLOSE c_valRefe;
    --
    IF v_valRefe = 0 THEN
        --
        RAISE EXCEPTION 'La referencia a la cual se le desea ingresar al producto no existe';
        --
    END IF;
    --
    OPEN c_valMarca;
    FETCH c_valMarca INTO v_valMarca;
    CLOSE c_valMarca;
    --
    IF v_valMarca = 0 THEN
        --
        RAISE EXCEPTION 'La Marca a la cual se le desea ingresar al producto no existe';
        --
    END IF;
    --
    OPEN c_validaRepe;
    FETCH c_validaRepe INTO v_valRep;
    CLOSE c_validaRepe;
    --
    IF v_valRep > 0 THEN
        --
        OPEN c_prodRepe;
        FETCH c_prodRepe INTO v_codRep;
        CLOSE c_prodRepe;
        --
        RAISE EXCEPTION 'Ya existe un producto con la misma categoria, subcategoria y marca lo cual es imposible en el sistema y su codigo es %', v_codRep;
        --
    END IF;
    --Finalizacion de validaciones
    --
    OPEN c_dska_dska;
    FETCH c_dska_dska INTO v_dska_dska;
    CLOSE c_dska_dska;
    --
    --
    OPEN c_codigo;
    FETCH c_codigo INTO v_codigo ;
    CLOSE c_codigo;
    --         
    --v_cod_prod  :=   US_FVERIFICA_COD_PROD(v_codigo);
    ----
    --IF v_cod_prod = 'N' THEN
    --    --
    --    RAISE EXCEPTION 'Ya existe un producto con el mismo codigo lo cual es imposible por favor contacte al administrador';
    --    --
    --END IF;
    --
    INSERT INTO in_tdska(dska_dska,DSKA_REFE,DSKA_COD, DSKA_NOM_PROD, DSKA_DESC, DSKA_IVA, DSKA_PORC_IVA, DSKA_MARCA,DSKA_CATE,DSKA_PROV)
                  VALUES(v_dska_dska,p_refe_refe,v_codigo,'Por asignar',upper(p_descripcion),'N',0,p_marca,p_categoria,1);
    --
    --Creacion de la subcuenta por categoria
    --
    OPEN c_categoria;
    FETCH c_categoria INTO v_cate_sbcu,v_cate_cate,v_cate_desc;
    CLOSE c_categoria;
    --
    IF v_cate_cate is not null THEN                        
        --
        IF v_cate_sbcu is null THEN
            --
            IF v_cate_cate < 10 THEN
                --
                v_codigosbcu := '0'||CAST(v_cate_cate AS VARCHAR);
                --
            ELSE
                --
                v_codigosbcu := cast(v_cate_cate as VARCHAR);
                --
            END IF;
            --
            OPEN c_sec_sbcu;
            FETCH c_sec_sbcu INTO v_sbcu_sbcu;
            CLOSE c_sec_sbcu;
            
            
            INSERT INTO co_tsbcu(
                    sbcu_sbcu,sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
                    sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
            VALUES (v_sbcu_sbcu,47, 1, 4, 'A', 'CATEGORIA '|| v_cate_desc , 
                    v_codigosbcu,'Se almacenaran las entradas y salidas de los producto que pertenescan a la categoria ' || v_cate_desc  , 'C')
                    ;
            --
            UPDATE in_tcate
               SET cate_sbcu = v_sbcu_sbcu
             WHERE cate_cate = v_cate_cate
             ;
            --
        ELSE
            --
            v_sbcu_sbcu := v_cate_sbcu;
            --
            OPEN c_codigo_sbcu(v_cate_sbcu);
            FETCH c_codigo_sbcu INTO v_codigosbcu;
            CLOSE c_codigo_sbcu;
            --
        END IF;
        --
    ELSE
        RAISE EXCEPTION 'La categoria asociada al producto no existe o se encuentra inactiva por favor intente de nuevo. ';
    END IF;
    --
    UPDATE in_tdska
       SET dska_sbcu = v_sbcu_sbcu
     WHERE dska_dska = v_dska_dska
    ;
    --
    RETURN 'OK-'||v_dska_dska;
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Err' || sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';