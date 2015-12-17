-- Function: f_cargacliente()

-- DROP FUNCTION f_cargacliente();

CREATE OR REPLACE FUNCTION f_cargacliente()
  RETURNS character varying AS
$BODY$
DECLARE
--
--Cursor que verifica si el cliente ya existe
--
c_consultacliente CURSOR (nit varchar)is
SELECT COUNT(*) FROM US_TCLIEN 
WHERE CLIEN_CEDULA =nit;
--
--Cursor que recorre todos los clientes de la tabla temporal
--
c_consultaclientestmp CURSOR FOR
SELECT tmpclien_nit,tmpclien_nombre,tmpclien_direccion,tmpclien_telefono,tmpclien_ciudad
FROM us_tmpclien;

v_resp  varchar(200) := '';
v_contador        int:=0;

BEGIN
  FOR datos in c_consultaclientestmp LOOP
   OPEN c_consultacliente(datos.tmpclien_nit);
   FETCH c_consultacliente into v_contador;
   CLOSE c_consultacliente;
     IF v_contador = 0 THEN
     INSERT INTO US_TCLIEN  (clien_clien,clien_cedula,clien_nombres,clien_apellidos,clien_telefono,clien_direccion)VALUES
                            ((SELECT COALESCE(MAX(clien_clien), 0) + 1 FROM us_tclien),datos.tmpclien_nit,datos.tmpclien_nombre,
                            ' ',datos.tmpclien_telefono,datos.tmpclien_direccion);
     END IF;
          --
  END LOOP;
      RETURN 'OK';
    --
    EXCEPTION WHEN OTHERS THEN
    RETURN 'Err'||SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION f_cargacliente()
  OWNER TO postgres;

