CREATE FUNCTION US_FVERIFICA_CORREO(  
                                       p_correo      varchar(50)
                                    ) RETURNS VARCHAR AS'
   DECLARE
   
   v_num_correo    int := 0;
   
   c_correo CURSOR FOR 
      SELECT count(*)
        FROM us_tpers 
        WHERE pers_email = p_correo
        ;
        
   BEGIN
   
      OPEN c_correo;
      FETCH c_correo INTO v_num_correo;
      CLOSE c_correo;
      
      IF v_num_correo  = 0 THEN
         RETURN ''UNICA'';
      ELSE
         RETURN ''DUPLICADA'';
      END IF;
      
   EXCEPTION WHEN OTHERS THEN
         RETURN ''ERR'';
   END;
'LANGUAGE 'plpgsql';