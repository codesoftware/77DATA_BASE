--
-- Funcion utilizada para recuperar el usuario por medio del correo
--
CREATE OR REPLACE FUNCTION US_FRECUPERAR_USUA   (  
                                                    p_email      varchar(50)
                                                ) RETURNS VARCHAR AS $$
   DECLARE
      
   p_usuario       varchar(50);
      
   c_usuario CURSOR FOR
   SELECT tius_usuario
     FROM us_ttius, us_tpers
    WHERE pers_email = p_email
      AND pers_pers = tius_pers
      ;
   BEGIN 
   
   OPEN c_usuario;
   FETCH c_usuario INTO p_usuario;
   CLOSE c_usuario;

   RETURN p_usuario;
   
   END;
$$LANGUAGE 'plpgsql';