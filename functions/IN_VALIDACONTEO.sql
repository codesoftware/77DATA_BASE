--
--Funcion que VALIDA todo antes de realizar un conteo
--
CREATE OR REPLACE FUNCTION IN_VALIDACONTEO(
                                p_codigoExterno   VARCHAR(200),
                                p_cantidad        BIGINT,
                                p_codigoBarras    VARCHAR(200),
                                p_ubicacion       VARCHAR(200),
                                p_CodProducto     VARCHAR(200),
                                p_idConteo        BIGINT)RETURNS varchar AS $$

DECLARE 
--
--Validacion de existencia de  producto X codigo de barras
--
c_valiCodigoBarras CURSOR IS
	SELECT coalesce(dska_dska,0)as dska_dska
	FROM in_tdska 
	WHERE dska_barcod = p_codigoBarras;
--
--Validacion de existencia de producto X codigo externo
--
c_valiProdCodExterno CURSOR IS
	SELECT coalesce(dska_dska,0)as dska_dska
	FROM in_tdska 
	WHERE dska_cod_ext= p_codigoExterno;
--
--Validacion de existencia de producto X Codigo
--	
 c_valiProdCodProd CURSOR IS
	SELECT coalesce(dska_dska,0)as dska_dska
	FROM in_tdska 
	WHERE dska_cod= p_CodProducto;
--
--Validacion del estado del conteo
--
c_ValiConteo CURSOR IS
	SELECT coalesce(copr_estado,'X')
	FROM in_tcopr
	WHERE copr_copr=p_idConteo;	
	
	v_existeProducto     BIGINT :=0;
	v_estadoConteo       VARCHAR(10) :='X';
	v_respuestaAct       VARCHAR(200) :='';

BEGIN

	--
	OPEN c_ValiConteo;
	FETCH c_ValiConteo INTO v_estadoConteo;
	CLOSE c_ValiConteo;
	--

	IF p_codigoBarras = '' THEN
		IF p_codigoExterno = '' THEN
			RETURN 'EL CODIGO EXTERNO Y EL CODIGO DE BARRAS NO PUEDE IR VACIO.';
		ELSE
			--
			OPEN c_valiProdCodExterno;
			FETCH c_valiProdCodExterno INTO v_existeProducto;
			CLOSE c_valiProdCodExterno;
			--
			IF v_existeProducto = 0 OR v_existeProducto is null THEN
				RETURN 'EL PRODUCTO CON CODIGO '||p_codigoExterno||' No esta parametrizado, favor verifique.';
			ELSE
				IF  v_estadoConteo = 'A' THEN
					v_respuestaAct = IN_ACTUALIZACONTEO(p_cantidad,p_codigoBarras,p_ubicacion,v_existeProducto,p_idConteo);
					RETURN ''||v_respuestaAct;

				ELSE
				RETURN 'EL CONTEO NO EXISTE O NO ESTA ABIERTO.';
				END IF;
			END IF;


		END IF;
		ELSE
			--
			OPEN c_valiCodigoBarras;
			FETCH c_valiCodigoBarras INTO v_existeProducto;
			CLOSE c_valiCodigoBarras;
			--
			IF v_existeProducto = 0 OR v_existeProducto is null  THEN
				OPEN c_valiProdCodExterno;
				FETCH c_valiProdCodExterno INTO v_existeProducto;
				CLOSE c_valiProdCodExterno;
				IF v_existeProducto = 0 OR v_existeProducto is null THEN
					RETURN 'EL PRODUCTO CON CODIGO '||p_codigoExterno||' No esta parametrizado, favor verifique.';
				ELSE
					IF  v_estadoConteo = 'A' OR v_estadoConteo = 'C' THEN
					v_respuestaAct = IN_ACTUALIZACONTEO(p_cantidad,p_codigoBarras,p_ubicacion,v_existeProducto,p_idConteo);
					RETURN ''||v_respuestaAct;

					ELSE
					RETURN 'EL CONTEO NO EXISTE O NO ESTA ABIERTO.';
					END IF;	
				END IF;

			ELSE
				IF  v_estadoConteo = 'A' OR v_estadoConteo = 'C' THEN
					v_respuestaAct = IN_ACTUALIZACONTEO(p_cantidad,'',p_ubicacion,v_existeProducto,p_idConteo);
					RETURN ''||v_respuestaAct;

				ELSE
				RETURN 'EL CONTEO NO EXISTE O NO ESTA ABIERTO.';
				END IF;
			END IF;

	END IF;



EXCEPTION WHEN OTHERS THEN
RETURN 'Err' || sqlerrm;
END;
$$ LANGUAGE 'plpgsql';
