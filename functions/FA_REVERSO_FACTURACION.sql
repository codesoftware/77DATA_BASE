--
--Funcion con la cual se realiza el reverso de faturacion
--
CREATE OR REPLACE FUNCTION FA_REVERSO_FACTURACION(

							p_idFact			BIGINT
							)RETURNS VARCHAR AS $$

DECLARE 
	
    --
    --Cursores necesarios para la contabilizacion
    --
    c_sum_debitos CURSOR(vc_temIdTrans INT) IS
    SELECT sum(coalesce(cast(tem_mvco_valor as numeric),0) )
      FROM co_ttem_mvco
     WHERE upper(tem_mvco_naturaleza) = 'D'
       AND tem_mvco_trans = vc_temIdTrans
       ;
    --
    c_sum_creditos CURSOR(vc_temIdTrans INT) IS
    SELECT sum(coalesce(cast(tem_mvco_valor as numeric),0) )
      FROM co_ttem_mvco
     WHERE tem_mvco_naturaleza = 'C'
       AND tem_mvco_trans = vc_temIdTrans
       ;

    --Cursor el cual sirve para obtener el id temporal de transaccion para la tabla temporal
    --de movimientos contables
    --
    c_sec_tem_mvco CURSOR IS
    SELECT nextval('co_temp_movi_contables') 
    ;
    --
    --Cursor que consulta los movimientos insertados en la tabla temporal
    --
    c_consultatmp CURSOR(vc_temIdTrans INT) FOR
    SELECT tem_mvco_trans,tem_mvco_sbcu,tem_mvco_naturaleza,tem_mvco_valor
    FROM co_ttem_mvco WHERE tem_mvco_trans = vc_temIdTrans
    ;
    --
    --Cursor que consulta el id del cliente que hace referencia a la factura
    --
    c_traecliente CURSOR IS
    SELECT FACT_CLIEN 
    FROM FA_TFACT WHERE
     FACT_FACT = p_idFact
     ;
    --
    --Cursor que consulta el id de nota credito
    --
    
    c_trae_id_notac CURSOR  IS
    select fanc_id from fa_tfanc
    WHERE FANC_FACT =p_idFact
    ;
    --
    --Obtiene el id de una subcuenta basandose en el codigo de la misma
    --
    c_sbcu_sbcu CURSOR(vc_sbcu_codigo VARCHAR) IS
    SELECT sbcu_sbcu
      FROM co_tsbcu
     WHERE sbcu_codigo = vc_sbcu_codigo
     ;
    --
    --
    v_naturaleza   			VARCHAR(10):='';
    v_sectemp				BIGINT:=0;
    v_sum_deb               NUMERIC(1000,10):=0;
    v_sum_cre               NUMERIC(1000,10):=0;
    v_id_nota_c				BIGINT:=0;
    v_id_client				BIGINT:=0;
    v_sbcu_sbcu             BIGINT := 0;	
 BEGIN

 	OPEN c_sec_tem_mvco;
 	FETCH c_sec_tem_mvco INTO v_sectemp;
 	CLOSE c_sec_tem_mvco;


 	INSERT INTO co_ttem_mvco
 	(tem_mvco_trans,tem_mvco_sbcu,tem_mvco_naturaleza,tem_mvco_valor)
 	SELECT v_sectemp, SBCU_CODIGO,
	(CASE 
		WHEN MVCO_NATURALEZA = 'C' THEN 'D' 
		WHEN MVCO_NATURALEZA = 'D' THEN 'C' END)VMVCO_NATURALEZA
	,MVCO_VALOR 
	FROM co_tmvco,CO_TSBCU WHERE 
	mvco_id_llave = p_idFact
	and mvco_lladetalle = 'fact'
	AND mvco_sbcu = sbcu_sbcu
	;

	OPEN c_sum_debitos(v_sectemp);
    FETCH c_sum_debitos INTO v_sum_deb;
    CLOSE c_sum_debitos;
    --
    OPEN c_sum_creditos(v_sectemp);
    FETCH c_sum_creditos INTO v_sum_cre;
    CLOSE c_sum_creditos;
    --
    OPEN c_traecliente;
    FETCH c_traecliente INTO v_id_client;
    CLOSE c_traecliente;

    OPEN c_trae_id_notac;
    FETCH c_trae_id_notac INTO v_id_nota_c;
    CLOSE c_trae_id_notac;

    IF v_sum_deb = v_sum_cre THEN
    	FOR movi IN c_consultatmp(v_sectemp)
    	LOOP
    	    OPEN c_sbcu_sbcu(movi.tem_mvco_sbcu);
            FETCH c_sbcu_sbcu INTO v_sbcu_sbcu;
            CLOSE c_sbcu_sbcu;

    	  INSERT INTO co_tmvco(mvco_trans, 
                                 mvco_sbcu, mvco_naturaleza, 
                                 mvco_tido, mvco_valor, 
                                 mvco_lladetalle, mvco_id_llave, 
                                 mvco_tercero, mvco_tipo)
    	  VALUES (v_sectemp,
    	  			v_sbcu_sbcu,movi.tem_mvco_naturaleza,
    	  			4,cast(movi.tem_mvco_valor as NUMERIC),
    	  			'notcr',v_id_nota_c,
    	  			v_id_client,v_id_client);

    	END LOOP;
    ELSE
     RAISE EXCEPTION 'Las sumas de las cuentas al facturar no coinciden por favor contactese con el administrador Debitos %, Creditos %',v_sum_deb,v_sum_cre;	

    END IF;

    DELETE FROM co_ttem_mvco
    WHERE tem_mvco_trans =  v_sectemp
    ;

	return 'OK CONTABILIDAD REALIZADA CORRECTAMENTE';
	EXCEPTION WHEN OTHERS THEN
    RETURN 'Error FA_FACTURACION_X_PRECIO '|| sqlerrm;
 END;
 $$ LANGUAGE 'plpgsql';   
