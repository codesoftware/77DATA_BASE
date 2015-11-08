CREATE FUNCTION US_FCAMBIA_ESTADO_USUARIO (  
                                       p_usuario       varchar(50)
                                      ) RETURNS VARCHAR AS $$
   DECLARE
   
   c_usuario CURSOR FOR
      SELECT count(*)
        FROM us_ttius
       WHERE UPPER(tius_usuario) = UPPER(p_usuario)
       ;
       
   c_estado_usu CURSOR FOR
      SELECT tius_estado
        FROM us_ttius
       WHERE UPPER(tius_usuario) = UPPER(p_usuario)
      ;
       
   v_usua_exist     int := 0;
   v_estado         varchar(1);
   v_rta            varchar := '';
       
   BEGIN
      
      OPEN c_usuario;
      FETCH c_usuario INTO v_usua_exist;
      CLOSE c_usuario;
      
      IF v_usua_exist = 1 THEN
      
         OPEN c_estado_usu;
         FETCH c_estado_usu INTO v_estado;
         CLOSE c_estado_usu;   
         
         IF v_estado = 'I' THEN
            UPDATE us_ttius
               SET tius_estado = 'A'
             WHERE UPPER(tius_usuario) = UPPER(p_usuario)
            ;
            v_rta = 'OK';
         ELSE
	     UPDATE us_ttius
               SET tius_estado = 'I'
             WHERE UPPER(tius_usuario) = UPPER(p_usuario)
             ;		
             v_rta = 'OK';         
         END IF;    
      ELSE 
         v_rta = 'ERR';
      END IF;   
      RETURN v_rta;  
   END;
$$ LANGUAGE 'plpgsql';