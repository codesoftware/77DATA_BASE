-- Funcion encargada verificar si existe el cod del producto
-- Retorna S si el producto existe

CREATE OR REPLACE FUNCTION US_FVERIFICA_COD_PROD(   P_COD_PROD    VARCHAR(10)
                                    ) RETURNS VARCHAR AS $$
   DECLARE
   
      v_cod_prod     INTEGER;
      
      c_cod_prod CURSOR FOR
      SELECT count(dska_cod)
        FROM in_tdska
       WHERE upper(dska_cod) = trim(upper(P_COD_PROD))
       ;
  BEGIN
       
       OPEN c_cod_prod;
       FETCH c_cod_prod INTO v_cod_prod;
       CLOSE c_cod_prod;
       
       IF  v_cod_prod <> 0 THEN
            RETURN 'S';
       END IF;
       
      RETURN 'N';
  END;
$$ LANGUAGE 'plpgsql';