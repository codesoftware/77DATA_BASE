--
--Funcion que VALIDA todo antes de realizar un conteo
--
CREATE OR REPLACE FUNCTION IN_ACTUALIZACONTEO(
                                p_cantidad        BIGINT,
                                p_codigoBarras    VARCHAR(200),
                                p_ubicacion       VARCHAR(200),
                                p_idProducto      BIGINT,
                                p_idConteo        BIGINT) RETURNS varchar AS $$

DECLARE 
--
--Cursor que verifica si el producto ya existe en el conteo
--
	c_valiProdConteo CURSOR IS
	SELECT coalesce(ecop_ecop,0) ecop_ecop
	FROM in_tecop
	WHERE ecop_copr = p_idConteo
	AND ecop_dska =  p_idProducto;
		v_existeProductoConteo   BIGINT :=0;

BEGIN

IF p_codigoBarras <> '' THEN
	UPDATE in_tdska 
	SET dska_barcod = p_codigoBarras
	WHERE dska_dska =  p_idProducto;
END IF;
IF p_ubicacion <> '' THEN
     UPDATE in_tdska 
	SET dska_ubicacion = p_ubicacion
	WHERE dska_dska =  p_idProducto;
END IF;

	--
	OPEN c_valiProdConteo;
	FETCH c_valiProdConteo INTO v_existeProductoConteo;
	CLOSE c_valiProdConteo;
	--
	IF v_existeProductoConteo > 0 THEN
		UPDATE in_tecop 
		SET ecop_valor = (ecop_valor+p_cantidad)
		WHERE ecop_ecop = v_existeProductoConteo;
	ELSE	
		INSERT INTO in_tecop 
		(ecop_ecop,ecop_copr,ecop_dska,ecop_valor)
		VALUES((SELECT coalesce(max(ecop_ecop),0)+1 FROM in_tecop),p_idConteo,p_idProducto,p_cantidad);
	END IF;
	RETURN 'OK';

EXCEPTION WHEN OTHERS THEN
RETURN 'Err' || sqlerrm;
END;
$$ LANGUAGE 'plpgsql';
--
--Funcion que VALIDA todo antes de realizar un conteo
--
CREATE OR REPLACE FUNCTION IN_ACTUALIZACONTEO(
                                p_cantidad        BIGINT,
                                p_codigoBarras    VARCHAR(200),
                                p_ubicacion       VARCHAR(200),
                                p_idProducto      BIGINT,
                                p_idConteo        BIGINT) RETURNS varchar AS $$

DECLARE 
--
--Cursor que verifica si el producto ya existe en el conteo
--
	c_valiProdConteo CURSOR IS
	SELECT coalesce(ecop_ecop,0) ecop_ecop
	FROM in_tecop
	WHERE ecop_copr = p_idConteo
	AND ecop_dska =  p_idProducto;
		v_existeProductoConteo   BIGINT :=0;

BEGIN

IF p_codigoBarras <> '' THEN
	UPDATE in_tdska 
	SET dska_barcod = p_codigoBarras
	WHERE dska_dska =  p_idProducto;
END IF;
IF p_ubicacion <> '' THEN
     UPDATE in_tdska 
	SET dska_ubicacion = p_ubicacion
	WHERE dska_dska =  p_idProducto;
END IF;

	--
	OPEN c_valiProdConteo;
	FETCH c_valiProdConteo INTO v_existeProductoConteo;
	CLOSE c_valiProdConteo;
	--
	IF v_existeProductoConteo > 0 THEN
		UPDATE in_tecop 
		SET ecop_valor = (ecop_valor+p_cantidad)
		WHERE ecop_ecop = v_existeProductoConteo;
	ELSE	
		INSERT INTO in_tecop 
		(ecop_ecop,ecop_copr,ecop_dska,ecop_valor)
		VALUES((SELECT coalesce(max(ecop_ecop),0)+1 FROM in_tecop),p_idConteo,p_idProducto,p_cantidad);
	END IF;
	RETURN 'OK';

EXCEPTION WHEN OTHERS THEN
RETURN 'Err' || sqlerrm;
END;
$$ LANGUAGE 'plpgsql';
