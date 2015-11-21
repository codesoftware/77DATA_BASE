CREATE OR REPLACE FUNCTION in_finsertaidexcel_tmp()
RETURNS character varying
$BODY$
DECLARE
  v_rta                 varchar(1000) :='error';
  v_idCate              int :=0;
  v_idRefe              int :=0;
  v_idMarca             int :=0;
  
  --
  --Cursor que consulta los datos de la tabla inicial del excel 
  --
  c_consultadatosexcel CURSOR FOR
     SELECT tmprefe_codexte,tmprefe_ubicaci,
     tmprefe_descrip,tmprefe_categor,tmprefe_subcate,
     tmprefe_tipo,tmprefe_existencia,
     tmprefe_costo from in_tmprefe;

  --
  --Cursor que consulta el id de la categoria
  --
  c_consultaIdCategoria CURSOR (categoria VARCHAR(500))IS
    SELECT cate_cate from in_tcate
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

    BEGIN
    FOR datos IN c_consultaIdCategoria LOOP
     OPEN c_consultadatosexcel(datos.)
    
    END LOOP;


    END;
LANGUAGE plpgsql VOLATILE
COST 100; 
