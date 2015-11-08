--
-- Funcion con la cual se corregira el ingreso de productos por error humano
--
CREATE OR REPLACE FUNCTION IN_CORRIGEING_PROD(   
                                            p_sede              INT,
                                            p_dska_dska         INT,
                                            p_cantidad          INT,
                                            p_tius_tius         INT
                                            ) RETURNS VARCHAR AS $$
    DECLARE
    --
    --Cursor encargado de obtener la informacion de la cantidad de productos existenetes en las sedes implicadas
    --
    c_exist_ing CURSOR FOR
    SELECT coalesce(sum(kapr_cant_mvto),0)
	  FROM in_tkapr, in_tmvin
	 WHERE kapr_mvin = mvin_mvin
	   AND mvin_natu = 'I'
	   AND kapr_sede = p_sede
       AND kapr_dska = p_dska_dska
       ;
    --
    c_exist_egr CURSOR FOR
    SELECT coalesce(sum(kapr_cant_mvto),0)
	  FROM in_tkapr, in_tmvin
	 WHERE kapr_mvin = mvin_mvin
	   AND mvin_natu = 'E'
	   AND kapr_sede = p_sede
       AND kapr_dska = p_dska_dska
       ;
    --
    v_existencias        NUMERIC(15,6) := 0;
    v_aux                NUMERIC(15,6) := 0;    
    --
    --Cursor el cual obtiene el movimiento de inventario de egreso
    -- 
    c_mvin_egr CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_corrige_ing = 'S'
     ; 
    --
    --Variables utilizadas para los movimientos de inventario implicados
    --
    v_mvin_egr      int   := 0;
    --
    v_rta_egr       varchar(600) := '';
    --
    c_prom_pond CURSOR FOR
    SELECT kapr_cost_saldo_uni
      FROM in_tkapr
     WHERE kapr_kapr = (SELECT max(kapr_kapr) FROM in_tkapr WHERE kapr_dska = p_dska_dska)
     ;
    --
    v_prom_pond        NUMERIC(15,6) := 0;
    v_costo_total      NUMERIC(15,6) := 0;
    --
    v_iva              NUMERIC(15,6) := 0;
    --
    v_total            NUMERIC(15,6) := 0;
    --
    c_sec_tem_mvco CURSOR FOR
    SELECT nextval('co_temp_movi_contables') 
    ;
    --
    v_sec_cont          int := 0;
    --
    --Subcuentas utilizadas para la contabilizacion de la correccion
    --
    c_sbcu_corr CURSOR FOR
    SELECT dska_sbcu sbcu_prod,
           (select sbcu_sbcu from co_tsbcu where sbcu_codigo = '240801') sbcu_iva,
           (select sbcu_sbcu from co_tsbcu where sbcu_codigo = '110501') sbcu_caja
      FROM in_tdska
     WHERE dska_dska = p_dska_dska
     ;
    --
    v_sbcu_prod             INT := 0;
    v_sbcu_iva              INT := 0;
    v_sbcu_caja             INT := 0;
    --
    --Cursor el cual obtiene el id para el tipo de documento para correcciones de Ingreso de Productos
    --
    c_tido CURSOR FOR
    SELECT tido_tido
      FROM co_ttido
     WHERE UPPER(tido_nombre) = 'CORRING' 
    ;
    --
    v_tido_tido             int := 0;
    --
    v_kapr_kapr             int := 0;
    --
    --Cursor con el cual obtengo el id del kardex del producto
    --
    c_kapr_kapr CURSOR(vc_kardex varchar) IS
    SELECT cast(id as int)
      FROM (SELECT regexp_split_to_table(vc_kardex, '-')  ID
      LIMIT 2
     OFFSET 1) KAPR_KAPR
     ;
    --
   BEGIN
    --
    OPEN c_exist_ing;
    FETCH c_exist_ing INTO v_aux;
    CLOSE c_exist_ing;
    --
    OPEN c_exist_egr;
    FETCH c_exist_egr INTO v_existencias;
    CLOSE c_exist_egr;
    --
    v_existencias := v_aux - v_existencias;
    --
    IF v_existencias < p_cantidad THEN
        --
        RAISE EXCEPTION 'El numero de existencias es inferior al numero de productos que se desean corregir';
        --
    END IF;
    --
    OPEN c_mvin_egr;
    FETCH c_mvin_egr INTO v_mvin_egr;
    CLOSE c_mvin_egr;
    --
    OPEN c_prom_pond;
    FETCH c_prom_pond INTO v_prom_pond;
    CLOSE c_prom_pond;
    --
    v_costo_total := v_prom_pond * p_cantidad;
    --
    v_rta_egr := IN_FINSERTA_PROD_KARDEX(p_dska_dska,
                                            v_mvin_egr,
                                            p_tius_tius,
                                            p_cantidad,
                                            v_costo_total,
                                            p_sede                                                   
                                            );
    IF UPPER(v_rta_egr) NOT LIKE '%OK%' THEN
        --
        RAISE EXCEPTION 'Error al realizar el egreso de los productos, Error funcion IN_FINSERTA_PROD_KARDEX %' ,v_rta_egr ;
        --
    ELSE
        --
        OPEN c_kapr_kapr(v_rta_egr);
        FETCH c_kapr_kapr INTO v_kapr_kapr;
        CLOSE c_kapr_kapr;
        --
    END IF;
    --
    -- Inicio de la Contabilizacion
    --
    v_iva := ( v_costo_total * 16 ) / 100;
    --
    v_total :=  v_iva + v_costo_total;
    --
    --Obtengo las subcuentas necesarias para la creacion de la contabilidad
    --
    OPEN c_sbcu_corr;
    FETCH c_sbcu_corr INTO v_sbcu_prod, v_sbcu_iva, v_sbcu_caja ;
    CLOSE c_sbcu_corr;
    --
    IF v_sbcu_prod is null THEN 
        --
        RAISE EXCEPTION 'El producto no tiene asociado ninguna subcuenta por favor contacte al administrador';
        --
    END IF;
    --
    IF v_sbcu_iva is null THEN 
        --
        RAISE EXCEPTION 'No existe parametrizada en el sistema la subcuenta utilizada para el IVA DESCONTABLE con el codigo 240801';
        --
    END IF;
    --
    IF v_sbcu_caja is null THEN 
        --
        RAISE EXCEPTION 'No existe parametrizada en el sistema la subcuenta utilizada para la CAJA MENOR con el codigo 110501';
        --
    END IF;
    --
    --Obtengo el valor de la secuencia de movimientos contables
    --
    OPEN c_sec_tem_mvco;
    FETCH c_sec_tem_mvco INTO v_sec_cont;
    CLOSE c_sec_tem_mvco;
    --
    OPEN c_tido;
    FETCH c_tido INTO v_tido_tido;
    CLOSE c_tido;
    --
    --Ingreso del movimiento contable de iva
    --
    INSERT INTO co_tmvco(mvco_trans, 
                         mvco_sbcu, mvco_naturaleza, 
                         mvco_tido, mvco_valor, 
                         mvco_lladetalle, mvco_id_llave, 
                         mvco_tercero, mvco_tipo)
                    VALUES ( v_sec_cont, 
                             v_sbcu_iva, 'C', 
                             v_tido_tido, v_iva,
                            'corin', v_kapr_kapr,
                            -1, -1);
    --
    --Ingreso del movimiento contable de inventario
    --
    INSERT INTO co_tmvco(mvco_trans, 
                         mvco_sbcu, mvco_naturaleza, 
                         mvco_tido, mvco_valor, 
                         mvco_lladetalle, mvco_id_llave, 
                         mvco_tercero, mvco_tipo)
                    VALUES ( v_sec_cont, 
                             v_sbcu_prod, 'C', 
                             v_tido_tido, v_costo_total,
                            'corin', v_kapr_kapr,
                            -1, -1);
    --
    --Ingreso del movimiento de caja para la devolucion del dinero
    --
    INSERT INTO co_tmvco(mvco_trans, 
                         mvco_sbcu, mvco_naturaleza, 
                         mvco_tido, mvco_valor, 
                         mvco_lladetalle, mvco_id_llave, 
                         mvco_tercero, mvco_tipo)
                    VALUES ( v_sec_cont, 
                             v_sbcu_caja, 'D', 
                             v_tido_tido, v_total,
                            'corin', v_kapr_kapr,
                            -1, -1);
    --
    RETURN 'Ok-'||v_sec_cont;
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error ' ||sqlerrm ;
    END;
$$ LANGUAGE 'plpgsql';