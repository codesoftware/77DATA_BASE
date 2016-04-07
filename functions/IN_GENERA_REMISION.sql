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
    BEGIN
        --
        v_remi_remi :=  nextval('in_tdrem_drem_drem_seq');
        --
        OPEN c_pedido;
        FETCH c_pedido INTO v_pedi_sede, v_pedi_clien, v_pedi_pedi, v_pedi_valor;
        CLOSE c_pedido;
        --
        INSERT INTO in_tremi (remi_remi,remi_clien , remi_pedi  , remi_estado, remi_tius  , remi_sede  , remi_plazod, remi_fplazo, remi_valor)
        VALUES(v_remi_remi,v_pedi_clien,v_pedi_pedi,'RE',p_idTius,v_pedi_sede,15,(select now() + cast( 10 || ' days' as interval )), v_pedi_valor);
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
        RETURN 'Ok';
        --
    EXCEPTION WHEN 
        OTHERS THEN
            --
            RETURN 'Error ' || sqlerrm;
            --
END;
$$ LANGUAGE 'plpgsql';