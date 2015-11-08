CREATE FUNCTION US_FVERIFICA_USUARIO(  
                                       p_usuario      varchar(50)
                                    ) RETURNS VARCHAR AS'
   DECLARE
   
   v_num_usuario    int := 0;
   
   c_usuario CURSOR FOR 
      SELECT count(*)
        FROM us_ttius 
        WHERE tius_usuario = UPPER(p_usuario)
        ;
        
   BEGIN
   
      OPEN c_usuario;
      FETCH c_usuario INTO v_num_usuario;
      CLOSE c_usuario;
      
      IF v_num_usuario  = 0 THEN
         RETURN ''UNICA'';
      ELSE
         RETURN ''DUPLICADA'';
      END IF;
      
   EXCEPTION WHEN OTHERS THEN
         RETURN ''ERR'';
   END;
'LANGUAGE 'plpgsql';