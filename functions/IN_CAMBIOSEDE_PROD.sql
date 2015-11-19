--
-- Funcion con la cual cambiare los productos de una sede a otra
--
CREATE OR REPLACE FUNCTION IN_CAMBIOSEDE_PROD(   
                                            p_sede_destin       INT,
                                            p_sede_origen       INT,
                                            p_cantidad          INT,
                                            p_dska_dska         INT,
                                            p_tius_tius         INT
                                            ) RETURNS VARCHAR AS $$
    DECLARE
    --
    --Cursor encargado de obtener la informacion de la cantidad de productos existenetes en las sedes implicadas
    --
    c_exist_dest_ing CURSOR FOR
    SELECT coalesce(sum(kapr_cant_mvto),0)
	  FROM in_tkapr, in_tmvin
	 WHERE kapr_mvin = mvin_mvin
	   AND mvin_natu = 'I'
	   AND kapr_sede = p_sede_destin
       AND kapr_dska = p_dska_dska
       ;
    --
    c_exist_dest_egr CURSOR FOR
    SELECT coalesce(sum(kapr_cant_mvto),0)
	  FROM in_tkapr, in_tmvin
	 WHERE kapr_mvin = mvin_mvin
	   AND mvin_natu = 'E'
	   AND kapr_sede = p_sede_destin
       AND kapr_dska = p_dska_dska
       ;
    --
    c_exist_org_ing CURSOR FOR
    SELECT coalesce(sum(kapr_cant_mvto),0)
	  FROM in_tkapr, in_tmvin
	 WHERE kapr_mvin = mvin_mvin
	   AND mvin_natu = 'I'
	   AND kapr_sede = p_sede_origen
       AND kapr_dska = p_dska_dska
       ;
    --
    c_exist_org_egr CURSOR FOR
    SELECT coalesce(sum(kapr_cant_mvto),0)
	  FROM in_tkapr, in_tmvin
	 WHERE kapr_mvin = mvin_mvin
	   AND mvin_natu = 'E'
	   AND kapr_sede = p_sede_origen
       AND kapr_dska = p_dska_dska
       ;
    --
    v_exist_org         NUMERIC(15,6) := 0;
    v_exist_des         NUMERIC(15,6) := 0;
    v_aux               NUMERIC(15,6) := 0;
    --
    --
    --Cursor el cual obtiene el movimiento de inventario de ingreso
    --
    c_mvin_ing CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_cambsede_ing = 'S'
     ;
    --
    --Cursor el cual obtiene el movimiento de inventario de egreso
    -- 
    c_mvin_egr CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_cambsede_egr = 'S'
     ; 
    --
    --Variables utilizadas para los movimientos de inventario implicados
    --
    v_mvin_egr      int   := 0;
    v_mvin_ing      int   := 0;
    --
    v_rta_ing       varchar(600) := '';
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
    BEGIN
    --
    OPEN c_exist_dest_ing;
    FETCH c_exist_dest_ing INTO v_aux;
    CLOSE c_exist_dest_ing;
    --
    OPEN c_exist_dest_egr;
    FETCH c_exist_dest_egr INTO v_exist_des;
    CLOSE c_exist_dest_egr;
    --
    v_exist_des := v_aux - v_exist_des;
    --
    v_aux := 0;
    --
    OPEN c_exist_org_ing;
    FETCH c_exist_org_ing INTO v_aux;
    CLOSE c_exist_org_ing;
    --
    OPEN c_exist_org_egr;
    FETCH c_exist_org_egr INTO v_exist_org; 
    CLOSE c_exist_org_egr;
    --
    v_exist_org := v_aux - v_exist_org;
    --
    IF v_exist_org <= 0 THEN
        --
        RAISE EXCEPTION 'La sede origen no tiene productos para hacer traslados';
        --
    END IF;
    --
    IF v_exist_org < p_cantidad THEN
        --
        RAISE EXCEPTION 'La sede origen no tiene suficinetes productos para hacer el traslado';
        --
    END IF;
    --
    OPEN c_mvin_ing;
    FETCH c_mvin_ing INTO v_mvin_ing;
    CLOSE c_mvin_ing;
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
                                        p_sede_origen                                                   
                                        );
    --
    IF UPPER(v_rta_egr) like '%OK%' THEN
        --
        v_rta_ing := IN_FINSERTA_PROD_KARDEX(p_dska_dska,
                                            v_mvin_ing,
                                            p_tius_tius,
                                            p_cantidad,
                                            v_costo_total,
                                            p_sede_destin                                                   
                                            );
        --
    ELSE
        --
        RAISE EXCEPTION 'Error al realizar el egreso: %' , v_rta_egr;
        --
    END IF;
    --
    RETURN 'Ok';
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error ' ||sqlerrm ;
    END;
$$ LANGUAGE 'plpgsql';