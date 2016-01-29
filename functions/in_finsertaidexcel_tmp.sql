CREATE OR REPLACE FUNCTION in_finsertaidexcel_tmp()
RETURNS character varying
AS
$BODY$
DECLARE
    --
    --Cursor con el cual obtengo el id de un producto
    --
    c_formato_dska CURSOR (vc_expresion varchar) IS
    SELECT cast(kapr_kapr as int)
      FROM (
           SELECT regexp_split_to_table(vc_expresion, '-') kapr_kapr
           offset 1) as tabla
           ;
    --
    --Obtengo el id de la tabla
    --
    c_idTabla CURSOR FOR
    SELECT COALESCE(MAX(tmpidexc_tmpidexc), 0) + 1 
    FROM in_tmpidexc
    ;
    --
    v_rta                 varchar(1000) :='error';
    v_idCate              bigint :=0;
    v_idRefe              bigint :=0;
    v_idMarca             bigint :=0;
    v_dska_dska           bigint :=0;
    v_idTabla             bigint :=0; 
  --
  --Cursor que consulta los datos de la tabla inicial del excel 
  --
  c_consultadatosexcel CURSOR FOR
  SELECT tmprefe_codexte,tmprefe_ubicaci,
            tmprefe_descrip,tmprefe_categor,tmprefe_subcate,
            tmprefe_tipo,tmprefe_existencia,
            tmprefe_costo
    FROM in_tmprefe;

  --
  --Cursor que consulta el id de la categoria
  --
  c_consultaIdCategoria CURSOR (categoria VARCHAR(500))IS
  SELECT cate_cate 
    FROM in_tcate
   WHERE upper(trim(cate_desc)) = UPPER(trim(categoria));

  --
  --Cursor que consulta el id de la referencia
  --
  c_consutaIdReferencia CURSOR(referencia VARCHAR(500))IS
    SELECT refe_refe FROM in_trefe 
    WHERE upper(trim(refe_nombre)) = UPPER(trim(referencia));

  --
  --Cursor que consulta el id de la marca
  --
  c_consultaIdMarca CURSOR(marca VARCHAR(500)) IS
    SELECT marca_marca FROM in_tmarca
    WHERE upper(trim(marca_nombre)) = UPPER(trim(marca));
  --
  --Variable para la evaluacion de la creacion del producto
  --
  v_ins_prod                varchar(2000) := '';
  --
  v_sec_cont                bigint := 0;
  v_rta_ingExt              varchar(2000) := '';
  --
  v_excepcion               varchar(2000) := '';
  --
    BEGIN
    --
        FOR datos IN c_consultadatosexcel LOOP
        --
             v_excepcion := datos.tmprefe_codexte;
             --
             OPEN  c_consultaIdCategoria(datos.tmprefe_categor);
             FETCH c_consultaIdCategoria INTO v_idCate;
             CLOSE c_consultaIdCategoria;
             --
             OPEN  c_consutaIdReferencia(datos.tmprefe_subcate);
             FETCH c_consutaIdReferencia INTO v_idRefe;
             CLOSE  c_consutaIdReferencia;
             --
             OPEN  c_consultaIdMarca(datos.tmprefe_tipo);
             FETCH c_consultaIdMarca INTO v_idMarca;
             CLOSE c_consultaIdMarca;
             --
             --Obtengo el id que va ha tener el registro
             --
             OPEN c_idTabla;
             FETCH c_idTabla INTO v_idTabla;
             CLOSE c_idTabla;
             --
             INSERT INTO in_tmpidexc (tmpidexc_tmpidexc,tmpidexc_codexte,tmpidexc_ubicaci,tmpidexc_descrip,
                                      tmpidexc_categor,tmpidexc_subcate,tmpidexc_tipo,tmpidexc_existencia,tmpidexc_costo)
                               VALUES(v_idTabla,datos.tmprefe_codexte,
                                      datos.tmprefe_ubicaci,datos.tmprefe_descrip,v_idCate,v_idRefe,v_idMarca,datos.tmprefe_existencia,
                                      datos.tmprefe_costo);  
            --  
            v_ins_prod := IN_REGISTRA_PRODUCTO(
                                                v_idRefe,
                                                datos.tmprefe_descrip,
                                                v_idMarca,
                                                v_idCate,
                                                datos.tmprefe_codexte,
                                                datos.tmprefe_ubicaci,
                                                'S'
                                                );
            --
            IF UPPER(TRIM(v_ins_prod)) NOT LIKE UPPER('%OK%') THEN
                --
                RAISE EXCEPTION 'Error in_finsertaidexcel_tmp % ', v_ins_prod;
                --
            ELSE
                --
                --Realiza la actualizacion de la tabla temporal con el id del producto
                --
                OPEN c_formato_dska(v_ins_prod);
                FETCH c_formato_dska INTO v_dska_dska;
                CLOSE c_formato_dska;
                --
                --RAISE exception 'Para hacer el update idtabla(%) y el del dska (%)', v_idTabla,v_dska_dska ;
                --
                UPDATE in_tmpidexc
                SET tmpidexc_dska = v_dska_dska
                WHERE tmpidexc_tmpidexc = v_idTabla
                ;
                --
            END IF;
            --
        END LOOP;
        --
    RETURN 'OK';
    --
    EXCEPTION WHEN OTHERS THEN
    RETURN 'Error in_finsertaidexcel_tmp con este codigo: '|| v_excepcion ||SQLERRM;
    --
    END;
	$BODY$
LANGUAGE plpgsql VOLATILE
COST 100; 
