--
--Funcion con la cual realizo la generacion de una remision basandome en un pedido previamente creado por un usuario
--
CREATE OR REPLACE FUNCTION IN_GENERA_REMISION(
                                p_idPedido        BIGINT,
                                p_idTius          BIGINT) RETURNS varchar AS $$

    DECLARE 
    --
    c_pedido CURSOR FOR
    SELECT pedi_sede, pedi_clie,pedi_pedi, (select sum(pedprod_precio) from in_tpedprod where pedprod_pedi = pedi_pedi) valor
      FROM in_tpedi
    WHERE pedi_esta = 'SR'
      AND pedi_pedi = p_idPedido
    ;
    --
    v_pedi_sede         bigint := 0;
    v_pedi_clien        bigint := 0;
    v_pedi_pedi         bigint := 0;
    v_pedi_valor        numeric(1000,10) :=0;
    --
    v_remi_remi         bigint := 0;
    --  
    --Valida si el movimiento de inventario para remisiones
    --
    c_valida_movi_remi CURSOR FOR
    SELECT count(*)
      FROM in_tmvin
     WHERE MVIN_CODIGO = 'REMI'
     ;
    --
    --Moviento de inventario parametrizado para la venta de productos
    --
    c_mvin_remi CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE MVIN_CODIGO = 'REMI'
     ;
    --
    v_val_mvin_remi         BIGINT := 0;
    v_mvin_mvin             BIGINT := 0;
    --
    c_detalle_prod CURSOR(vc_remi_remi BIGINT)IS
    SELECT drem_dska, drem_cantid, remi_sede, drem_drem
      FROM in_tdrem, in_tremi
     WHERE drem_remi = remi_remi
       AND remi_remi = vc_remi_remi
     ;
    --
    v_rta_insrt_kar         VARCHAR(500) := '';
    --
    v_kapr_kapr             NUMERIC(1000,10)  :=0;
    --
    -- Cursor con el cual encuentro el id del movimiento de inventario
    --
    c_kapr_kapr CURSOR (vc_expresion varchar) IS
    SELECT cast(kapr_kapr as bigint)
      FROM (
           SELECT regexp_split_to_table(vc_expresion, '-') kapr_kapr
           offset 1) as tabla
    ;
    BEGIN
        --
        v_remi_remi :=  nextval('in_tdrem_drem_drem_seq');
        --
        OPEN c_pedido;
        FETCH c_pedido INTO v_pedi_sede, v_pedi_clien, v_pedi_pedi, v_pedi_valor;
        CLOSE c_pedido;
        --
        INSERT INTO in_tremi (remi_remi,remi_clien , remi_pedi  , remi_estado, remi_tius  , remi_sede  , remi_plazod, remi_fplazo, remi_valor)
        VALUES(v_remi_remi,v_pedi_clien,v_pedi_pedi,'RE',p_idTius,v_pedi_sede,15,(select now() + cast( 1 || ' days' as interval )), v_pedi_valor);
        --
        INSERT INTO in_tdrem(drem_remi  , drem_dska  , drem_precio, drem_cantid, drem_estado )
        SELECT v_remi_remi, pedprod_dska, pedprod_precio, pedprod_canti, 'A'
          FROM in_tpedprod
         WHERE pedprod_pedi = p_idPedido
        ;
        --
        UPDATE in_tpedi
           SET pedi_esta = 'RE'
         WHERE pedi_pedi = p_idPedido
        ;
        --
        --Validacion de existencia de movimientos de inventario referenciando facturacion
        --
        OPEN c_valida_movi_remi;
        FETCH c_valida_movi_remi INTO v_val_mvin_remi;
        CLOSE c_valida_movi_remi;
        --
        IF v_val_mvin_remi <> 1 THEN
            --
            RAISE EXCEPTION 'No existe ningun movimiento de inventario que referencie la remision de productos';
            --
        ELSE
            --
            OPEN c_mvin_remi;
            FETCH c_mvin_remi INTO v_mvin_mvin;
            CLOSE c_mvin_remi;
            --
        END IF;
        --
        FOR prod IN c_detalle_prod(v_remi_remi) 
        LOOP 
            --
            --Realizamos la salida del inventario del producto 
            --
            v_rta_insrt_kar := IN_FINSERTA_PROD_KARDEX(prod.drem_dska,
                                                       v_mvin_mvin,
                                                       p_idTius,
                                                       cast(prod.drem_cantid as bigint),
                                                       cast(0 as numeric),
                                                       prod.remi_sede                                                   
                                                       );
            --
            IF upper(v_rta_insrt_kar) NOT LIKE '%OK%' THEN
                --
                RAISE EXCEPTION 'Error al hacer la salida de inventario. % ', v_rta_insrt_kar ;
                --
            ELSE
                --
                OPEN c_kapr_kapr(v_rta_insrt_kar);
                FETCH c_kapr_kapr INTO v_kapr_kapr;
                CLOSE c_kapr_kapr;
                --
                UPDATE in_tdrem
                   SET drem_kapr = v_kapr_kapr
                 WHERE drem_drem = prod.drem_drem
                 ;
                --
            END IF;
            --
        END LOOP;
        --
        RETURN 'Ok';
        --
    EXCEPTION WHEN 
        OTHERS THEN
            --
            RETURN 'Error IN_GENERA_REMISION ' || sqlerrm;
            --
END;
$$ LANGUAGE 'plpgsql';