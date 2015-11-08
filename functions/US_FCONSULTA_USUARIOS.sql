CREATE OR REPLACE FUNCTION US_FCONSULTA_USUARIOS (  p_usuario       varchar(50),
                                         p_nombre       varchar(50),
                                         p_cedula       varchar(50),
                                         p_apellido     varchar(50)
                                      ) RETURNS return_usua_com[] AS $$
   DECLARE
   
   rtafinal          return_usua_com[];
   rta               return_usua_com;
   v_iterator        int := 0;
   v_nulo            varchar(8) := 'SIN DATO';
   
   c_usuario CURSOR FOR 
      SELECT COALESCE(cedula     ,v_nulo), 
             COALESCE(nombre     ,v_nulo), 
             COALESCE(apellido   ,v_nulo), 
             COALESCE(correo     ,v_nulo), 
             COALESCE(telefono   ,v_nulo), 
             'AD', 
             COALESCE(usuario    ,v_nulo),
             COALESCE(perfil_usuario    ,v_nulo),
             COALESCE(fecha_nacimiento    ,v_nulo),
             COALESCE(estado_usuario    ,'Err'),
             COALESCE(id_perfil_usuario ,0),
             COALESCE(id_tipo_usuario ,0),             
             COALESCE(sede , 0 )
      FROM us_vusuarios
      WHERE UPPER(usuario)  LIKE '%'||COALESCE(UPPER(p_usuario)  ,UPPER(usuario))  ||'%'
      AND   UPPER(apellido) LIKE '%'||COALESCE(UPPER(p_apellido) ,UPPER(apellido)) ||'%'
      AND   UPPER(nombre)   LIKE '%'||COALESCE(UPPER(p_nombre)   ,UPPER(nombre))   ||'%'
      AND   UPPER(cedula)   LIKE '%'||COALESCE(UPPER(p_cedula)   ,UPPER(cedula))   ||'%'      
      ;
      
   BEGIN
      OPEN c_usuario;
      LOOP 
         FETCH c_usuario INTO rta.cedula, rta.nombre, rta.apellido, rta.correo, rta.telefono, rta.tipoUsuario, rta.usuario, rta.perfil, rta.fecha_nac, rta.estado, rta.id_perfil, rta.id_tipo_usuario, rta.sede;
         IF rta IS NULL THEN EXIT;
         END IF;
         rtafinal[v_iterator] := rta;
         v_iterator := v_iterator+1;
      END loop;
      
      CLOSE c_usuario;
      
      RETURN rtafinal;
      
   END;
$$ LANGUAGE 'plpgsql';