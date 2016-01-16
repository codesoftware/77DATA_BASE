CREATE OR REPLACE FUNCTION in_finsertaexceltmp()
RETURNS character varying AS
$BODY$
DECLARE 
    rta                  varchar(1000) := 'error';
    contador             bigint         :=0;
    idCategoria          bigint         :=0; 
    --
    --Cursor que consulta los datos de las categorias de la tabla temporal de excel para insertarlas
    --
    c_consultacategoriastmp CURSOR FOR
    SELECT DISTINCT upper(tmprefe_categor) nombreCate 
      FROM in_tmprefe;
    --
    --Cursor que consulta si las categorias ya existen
    --
    c_verificacategorias CURSOR (categoria VARCHAR(500)) IS
    SELECT COUNT(*) 
      FROM in_tcate 
     WHERE upper(trim(cate_desc)) = UPPER(trim(categoria))
       and cate_estado = 'A';
    --
    --Cursor que consulta las referencias de la tabla temporal de excel para insertarlas
    --
    c_consultareferenciastmp CURSOR FOR
    SELECT DISTINCT upper(tmprefe_subcate)referencia
    FROM in_tmprefe;
    --
    --Cursor que consulta si la referencia ya existe
    --
    c_verificareferencias CURSOR (referencia VARCHAR(1000)) IS
	    SELECT COUNT(*)
	      FROM in_trefe
	     WHERE upper(trim(refe_nombre)) = UPPER(trim(referencia))
	       and refe_estado = 'A';
    --
    --Cursor que consulta el id de la categoria para asociarlo a la referencia
    --
    c_consultaIdCategoria CURSOR (referencia VARCHAR(1000)) IS 
    SELECT cate_cate from in_tcate,in_tmprefe where 
      upper(trim(tmprefe_categor))=upper(trim(cate_desc))
      and upper(trim(tmprefe_subcate))= referencia;      
    --
    --Cursor que consulta las marcas de la tabla temporal de excel para insertarlas,
    --se debe tener en cuenta que en una categoria sera tipo y en las otras va a ser marca
    --
    c_consultaMarcaTmp CURSOR FOR
    SELECT DISTINCT upper(tmprefe_tipo)marca
      FROM in_tmprefe;
    --
    --Cursor que verifica si la marca ya existe en la base de datos
    --
    c_verificaMarcas CURSOR (marca VARCHAR(1000)) IS
    SELECT COUNT(*) FROM in_tmarca 
      WHERE upper(trim(marca_nombre)) = upper(trim(marca));
    --
    v_valida_inProd         varchar(2000) := ''; 
    --
    BEGIN 
    --
    FOR nombreCategoria IN c_consultacategoriastmp LOOP
        --
        OPEN c_verificacategorias(nombreCategoria.nombreCate);
        FETCH c_verificacategorias INTO contador;
        CLOSE c_verificacategorias;
        --
        IF contador = 0 THEN
            --
            IF upper(nombreCategoria.nombreCate) = 'TORNILLOS' THEN 
            --
                INSERT INTO in_tcate (cate_cate,cate_desc,cate_estado,cate_runic,cate_feven,cate_porcentaje)
                VALUES ((SELECT COALESCE(MAX(cate_cate),0)+1 from in_tcate),nombreCategoria.nombreCate,'A','','', 60); 
            --
            ELSE
            --
                INSERT INTO in_tcate (cate_cate,cate_desc,cate_estado,cate_runic,cate_feven, cate_porcentaje)
                VALUES ((SELECT COALESCE(MAX(cate_cate),0)+1 from in_tcate),nombreCategoria.nombreCate,'A','','', 60); 
            --
            END IF;
            
            --
        END IF;
        
    END LOOP;
   
    FOR nombreReferencia IN c_consultareferenciastmp LOOP
       --
       OPEN c_verificareferencias(nombreReferencia.referencia);
       FETCH c_verificareferencias INTO contador;
       CLOSE c_verificareferencias;
       --
       IF contador = 0 THEN
          --
          OPEN c_consultaIdCategoria(nombreReferencia.referencia);
          FETCH c_consultaIdCategoria INTO idCategoria;
          CLOSE c_consultaIdCategoria;
          --
          INSERT INTO in_trefe(refe_refe,refe_nombre,refe_desc,refe_estado,refe_cate) 
          VALUES ((SELECT COALESCE(MAX(refe_refe),0)+1 from in_trefe),nombreReferencia.referencia,nombreReferencia.referencia,'A',idCategoria);
          --
       END IF;
       --
    END LOOP;
    --
    FOR nombreMarca IN c_consultaMarcaTmp LOOP
        --
        OPEN c_verificaMarcas(nombreMarca.marca);
        FETCH c_verificaMarcas INTO contador;
        CLOSE c_verificaMarcas;
        --
         IF contador = 0 THEN 
            --
            INSERT INTO in_tmarca (marca_marca,marca_nombre,marca_descr,marca_estado)VALUES
            ((SELECT COALESCE(MAX(marca_marca),0)+1 from in_tmarca),nombreMarca.marca,nombreMarca.marca,'A');
            --
         END IF;
         --
     END LOOP;  
    --
    v_valida_inProd := in_finsertaidexcel_tmp();
    --
    IF UPPER(v_valida_inProd) not like '%OK%' THEN
        --
        RAISE EXCEPTION 'Error in_finsertaexceltmp % ', v_valida_inProd; 
        --
    END IF;
    --
    RETURN v_valida_inProd;
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error in_finsertaexceltmp ' ||SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
