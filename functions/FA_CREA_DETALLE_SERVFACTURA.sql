CREATE OR REPLACE 
FUNCTION FA_CREA_DETALLE_SERVFACTURA (  
                            ptius           INT,
                            p_fecha_ini     DATE,          
                            p_num_dias      INT,
                            p_dsha_dsha     INT,
                            p_fact_fact     INT
                         ) RETURNS VARCHAR  AS $$
                         
                         
    DECLARE
    --
    --Variable con la cual sabre si la habitacion esta disponible o no
    --
    v_verf_reservacion      VARCHAR;
    --
    -- Variable encargada de obtener el id del cliente al cual se le facturara
    --
    v_clien                 INT;
    --
    -- Cursor el cual identifica si la factura si existe
    --
    c_exists_fact  CURSOR FOR
    SELECT fact_clien 
      FROM fa_tfact
     WHERE fact_fact = p_fact_fact
    ;
    --
    -- Cursor el cual obtiene el precio actual de la habitacion
    --
    c_precHab CURSOR FOR 
    SELECT prha_precio, dsha_iva
      FROM in_tprha,in_tdsha
     WHERE prha_dsha = p_dsha_dsha
       AND prha_estado = 'A'
       AND dsha_dsha = prha_dsha
     LIMIT 1 OFFSET 0
     ;
    --
    --
    --
    v_valor_reservacion       NUMERIC(50,6) := 0; 
    v_precioHabitacion        NUMERIC(50,6) := 0; 
    v_porcIva                 NUMERIC(50,6) := 0;
    v_valorIva                NUMERIC(50,6) := 0;
    v_valorTotal              NUMERIC(50,6) := 0;
    --
    BEGIN
    
    
    OPEN c_exists_fact;
    FETCH c_exists_fact INTO v_clien;
    CLOSE c_exists_fact;
    
    IF v_clien IS NULL THEN
        --
        RETURN 'Error la factura relacionada no existe';
        --        
    END IF;
    
    v_verf_reservacion  := FA_RESERVA_HABITACION(
                                                    ptius,
                                                    p_fecha_ini,
                                                    p_num_dias,
                                                    p_dsha_dsha,
                                                    v_clien
                                                );
                                                
    IF upper(v_verf_reservacion) not like '%ERROR%' THEN
        
        OPEN c_precHab;
        FETCH c_precHab INTO v_precioHabitacion,v_porcIva;
        CLOSE c_precHab;
        
        IF v_precioHabitacion is null THEN
            
            RAISE EXCEPTION ' LA HABITACION % NO TIENE PARAMETRIZADO EL PRECIO', p_dsha_dsha ;
            
        END IF;
        
        v_valor_reservacion := v_precioHabitacion * p_num_dias;
        
        v_valorIva := (v_valor_reservacion * v_porcIva)/100;
        
        IF v_valorIva is null THEN
            
            v_valorIva := 0;
            
        END IF;
        
        v_valorTotal :=   v_valor_reservacion + v_valorIva;

        INSERT INTO fa_tdtsv(
                dtsv_rvha, dtsv_fact, dtsv_valor_venta, 
                dtsv_valor_sv, dtsv_desc,dtsv_valor_iva,dtsv_costo_hab)
        VALUES (to_number(v_verf_reservacion,'9999G999D9S'), p_fact_fact, v_valorTotal,
                v_valor_reservacion, 0,v_valorIva,v_precioHabitacion);
        
        RETURN 'OK';
        
    ELSE
    
        RETURN v_verf_reservacion;
    
    END IF;
    
    EXCEPTION 
        WHEN OTHERS THEN
        
        RETURN 'Error '|| sqlerrm;
        
 END;
$$ LANGUAGE 'plpgsql';