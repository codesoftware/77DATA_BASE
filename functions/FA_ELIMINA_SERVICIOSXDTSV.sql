--
-- Funcion con la cual desactivo una servicio y su reservacion
--
CREATE OR REPLACE FUNCTION FA_ELIMINA_SERVICIOSXDTSV(   
                                            p_fact_fact     INT,
                                            p_dtsv_dtsv     INT
                                            ) RETURNS VARCHAR AS $$
    DECLARE
    --
    --Cursor con el cual encuentro las reservaciones  que tiene ese detalle de factura
    --
    c_rvha_rvha CURSOR FOR
    SELECT rvha_rvha
      FROM in_trvha, fa_tdtsv
     WHERE dtsv_rvha = rvha_rvha
       AND dtsv_fact = p_fact_fact
       AND dtsv_dtsv = p_dtsv_dtsv
     ORDER BY rvha_rvha
     ;

    
    BEGIN
    
    --
    -- Actualizo el detalle de facturacion a C (Cancelada)
    --
    UPDATE fa_tdtsv
       SET dtsv_estado =  'C'
     WHERE dtsv_dtsv = p_dtsv_dtsv
       AND dtsv_fact = p_fact_fact
     ;
    --
    FOR detalle IN c_rvha_rvha LOOP
        --
        --Actualizo a cancelada todas las reservas de habitaciones
        --
        UPDATE in_trvha
           SET rvha_estado = 'X'
         WHERE rvha_rvha = detalle.rvha_rvha
         ;
        --
    END LOOP;    
    --
    RETURN 'Ok';
    --
    EXCEPTION WHEN OTHERS THEN
            RETURN 'Error '||SQLERRM;
    END;
$$ LANGUAGE 'plpgsql';