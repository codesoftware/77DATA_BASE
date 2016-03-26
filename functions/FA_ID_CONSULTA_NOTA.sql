--	
--Funcion que consulta el id de la factura
--
CREATE OR REPLACE FUNCTION FA_ID_CONSULTA_NOTA(
								p_idFac   BIGINT
								)RETURNS BIGINT AS $$


DECLARE 
	c_con_id_fanc CURSOR IS 
	SELECT COALESCE(FANC_ID,0) 
	FROM FA_TFANC
	WHERE FANC_FACT = p_idFac
	;

	v_id       BIGINT :=0;

BEGIN

	OPEN c_con_id_fanc;
	FETCH c_con_id_fanc INTO v_id;
	CLOSE c_con_id_fanc;

	RETURN v_id;

END;
$$ LANGUAGE 'plpgsql';	 