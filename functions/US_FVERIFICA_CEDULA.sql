CREATE FUNCTION US_FVERIFICA_CEDULA(  
                                       p_cedula      varchar(50)
                                    ) RETURNS VARCHAR AS'
   DECLARE
   
   v_num_cedula    int := 0;
   
   c_cedula CURSOR FOR 
      SELECT count(*)
        FROM us_tpers 
        WHERE pers_cedula = p_cedula
        ;
        
   BEGIN
   
      OPEN c_cedula;
      FETCH c_cedula INTO v_num_cedula;
      CLOSE c_cedula;
      
      IF v_num_cedula  = 0 THEN
         RETURN ''UNICA'';
      ELSE
         RETURN ''DUPLICADA'';
      END IF;
      
   EXCEPTION WHEN OTHERS THEN
         RETURN ''ERR'';
   END;
'LANGUAGE 'plpgsql';