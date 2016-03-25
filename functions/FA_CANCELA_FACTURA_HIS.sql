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
        --cursor que consulta el ultimo registro insertado
        --para la nota credito
        --
        c_tnotacr CURSOR IS
        SELECT MAX(fanc_fanc)
        FROM fa_tfanc
        WHERE FANC_FACT = p_fact;
        --variables
        --
        v_hfac   INT :=0;
		v_clie   INT :=0;
		v_fanc   INT :=0;

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
	--
	--Logica de insercion para los registros de la nota credito
	--
	IF p_esta = 'S' THEN
		INSERT INTO fa_tfanc (fanc_fact,fanc_pers_s,fanc_fech_s,fanc_come_s,fanc_esta) 
		VALUES (p_fact,p_tius,now(),p_desc,p_esta);

	ELSIF p_esta = 'A' THEN 
		OPEN  c_tnotacr;
		FETCH c_tnotacr INTO v_fanc;
		CLOSE c_tnotacr;
		UPDATE fa_tfanc SET fanc_pers_a= p_tius, fanc_fech_a= now(),fanc_come_a=p_desc, fanc_esta=p_esta 
		WHERE fanc_fanc = v_fanc;

		ELSIF p_esta = 'R' THEN 
		OPEN  c_tnotacr;
		FETCH c_tnotacr INTO v_fanc;
		CLOSE c_tnotacr;
		UPDATE fa_tfanc SET fanc_pers_r= p_tius, fanc_fech_r= now(),fanc_come_r=p_desc, fanc_esta=p_esta,
		fanc_id = (select nextval('fa_tfanc_seq'))
		WHERE fanc_fanc = v_fanc; 	

		ELSIF p_esta = 'C' THEN 
		OPEN  c_tnotacr;
		FETCH c_tnotacr INTO v_fanc;
		CLOSE c_tnotacr;
		UPDATE fa_tfanc SET fanc_pers_c= p_tius, fanc_fech_c= now(),fanc_come_c=p_desc, fanc_esta=p_esta 
		WHERE fanc_fanc = v_fanc;

	END IF;


	RETURN 'OK';

	EXCEPTION WHEN OTHERS THEN
         RETURN 'Error Cancelando Factura '|| sqlerrm;
    END;
	$$ LANGUAGE 'plpgsql';	 