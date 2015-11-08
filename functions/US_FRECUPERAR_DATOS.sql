--
-- Funcion encargada de traer el objeto de logeo
--

CREATE OR REPLACE FUNCTION US_FRECUPERAR_DATOS (  
                                                   p_user      varchar(50)
                                                ) RETURNS return_usuario AS $$
   DECLARE
   
   rta          return_usuario;
   
   c_usuario CURSOR FOR 
      SELECT cedula, nombre, apellido, correo, telefono, tipoUsuario, perfil_usuario, permisos_usuario, id_tipo_usuario, tius_ultimo_ingreso
      FROM us_vusuarios
      WHERE UPPER(usuario) = UPPER(p_user)
      ;
      
   BEGIN
   
      OPEN c_usuario;
      FETCH c_usuario INTO rta.cedula, rta.nombre, rta.apellido, rta.correo, rta.telefono, rta.tipoUsuario, rta.perfil_usuario, rta.permisos_usuario, rta.idUsuario,rta.ultimoIngreso;
      CLOSE c_usuario;
      
       RETURN rta;
      
   END;
$$ LANGUAGE 'plpgsql';