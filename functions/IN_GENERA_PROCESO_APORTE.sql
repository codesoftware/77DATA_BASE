--
-- Funcion con la cual cambiare los productos de una sede a otra
--
CREATE OR REPLACE FUNCTION IN_GENERA_PROCESO_APORTE(   
                                            p_apor              BIGINT,
                                            p_auco              BIGINT,
                                            p_tius              BIGINT
                                            ) RETURNS VARCHAR AS $$
    DECLARE
    --
    c_auco cursor for
    select count(*)
      from co_tauco
     where auco_codi like '3105%'
    ;
    --
    v_valida_auco           bigint := 0;
    --
    --Funcion con la cual obtengo los productos del aporte
    --
    c_prod_aporte cursor for
    SELECT prap_dska, prap_cant, prap_costo
      FROM in_tprap
     WHERE prap_apor = 1
     ;
    --
    v_vlr_apor              numeric (1000,10):=0;
    --
    BEGIN
    --
    --Validacion de la informacion
    --
    OPEN c_auco;
    FETCH c_auco INTO v_valida_auco;
    CLOSE c_auco;
    --
    IF v_valida_auco = 0 THEN
        --
        raise exception 'La subcuenta proporcionada no corresponde a un cuenta valida (Debe pertenecer a la cuenta 3105)';
        --
    END IF;
    --
    UPDATE em_tapor
       SET apor_auco = p_auco
     WHERE apor_apor = p_apor
     ;
    --
    FOR prod IN c_prod_aporte LOOP
        --
    
        --
    END LOOP;
    --
    RETURN 'Ok';
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error IN_GENERA_PROCESO_APORTE ' ||sqlerrm ;
    END;
$$ LANGUAGE 'plpgsql';