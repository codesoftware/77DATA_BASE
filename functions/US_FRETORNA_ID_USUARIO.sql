-- Funcion encargada de retornar el id del usuario por medio del usuario

CREATE OR REPLACE FUNCTION US_FRETORNA_ID_USUARIO (    p_usuario        VARCHAR(50) ) RETURNS INTEGER AS $$
      DECLARE 
      
         v_tius         integer := 0;         
         
         c_usuario CURSOR FOR
         SELECT tius_tius
           FROM us_ttius
          WHERE UPPER(tius_usuario) = UPPER(p_usuario)
          ;

      BEGIN
         
         OPEN c_usuario;
         FETCH c_usuario INTO v_tius;
         CLOSE c_usuario;
         
         IF v_tius IS NOT NULL THEN
            RETURN v_tius;
         END IF;
         v_tius := 0;
         
         RETURN v_tius;
         
          EXCEPTION WHEN OTHERS THEN
               RETURN v_tius;
       END;
$$ LANGUAGE 'plpgsql';