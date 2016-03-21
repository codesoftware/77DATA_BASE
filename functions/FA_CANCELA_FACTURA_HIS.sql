--	
--Funcion que realiza la cancelacion de la factura
--
CREATE OR REPLACE FUNCTION FA_CANCELA_FACTURA_HIS(
								p_tius			INT,
								p_fact			INT,
								p_desc			VARCHAR,
								p_esta			VARCHAR
								)RETURNS VARCHAR AS $$

	DECLARE
		--
		--cursor que obtiene el id del registro del historial
		--
		c_hfac_hfac CURSOR IS
        SELECT coalesce(max(hfac_hfac),0) + 1
          FROM fa_thfac     
        ;
        --
        --cursor que consulta el id del cliente
        --
        c_tcliente CURSOR IS
        SELECT fact_clien FROM 
        FA_TFACT WHERE FACT_FACT = p_fact;
        --
        --variables
        --
        v_hfac   INT :=0;
		v_clie   INT :=0;

	BEGIN
	
	OPEN c_hfac_hfac;
	FETCH c_hfac_hfac INTO v_hfac;
	CLOSE c_hfac_hfac;

	OPEN c_tcliente;
	FETCH c_tcliente INTO v_clie;
	CLOSE c_tcliente;	

	INSERT INTO fa_thfac VALUES (v_hfac,p_tius,NOW(),p_fact,p_desc,v_clie,p_esta);
	UPDATE FA_TFACT 
	SET fact_estado = p_esta
	WHERE fact_fact = p_fact;
	RETURN 'OK';

	EXCEPTION WHEN OTHERS THEN
         RETURN 'Error Cancelando Factura '|| sqlerrm;
    END;
	$$ LANGUAGE 'plpgsql';	 