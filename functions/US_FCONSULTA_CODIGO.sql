--Funcion encargada de buscar todas las coincidencias de los codigos de los productos de acuerdo a un filtro

CREATE FUNCTION US_FCONSULTA_CODIGO (  
                                       p_codigo       varchar(50)                                         
                                     ) RETURNS VARCHAR[] AS $$
   DECLARE
   
   v_rta             varchar[];
   v_iterator        int := 0;
   v_rtaAux          varchar; 
   
   c_codigo CURSOR FOR
   SELECT dska_cod
     FROM in_tdska
    WHERE upper(dska_cod) LIKE '%'|| upper(p_codigo) ||'%'
    ;
    
    BEGIN
    
    OPEN c_codigo;
      LOOP
         FETCH c_codigo INTO v_rtaAux;
         IF v_rta IS NULL THEN 
            EXIT;
         END IF;
         v_rta[v_iterator] = v_rtaAux;
         v_iterator := v_iterator+1;
      END LOOP;
      
      CLOSE c_codigo;
      
      RETURN v_rta;
   END;
$$ LANGUAGE 'plpgsql';