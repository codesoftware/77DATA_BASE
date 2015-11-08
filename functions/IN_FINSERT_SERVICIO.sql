-- Función con la cual se realizara la inserccion de un cliente

CREATE OR REPLACE FUNCTION IN_FINSERT_SERVICIO (    
                                            p_numHab                integer, 
                                            p_num_max_pers          integer, 
                                            p_num_min_pers          integer, 
                                            p_iva                   integer,
                                            p_bano                  varchar(1), 
                                            p_televison             varchar(1), 
                                            p_cable                 varchar(1), 
                                            p_num_camas             integer,
                                            p_cama_aux              varchar(1)
                                            ) RETURNS varchar AS $$
    DECLARE  
    
                                            
    BEGIN  
    
    INSERT INTO in_tdsha(
            dsha_num_hab, dsha_num_max_pers, 
            dsha_num_min_pers, dsha_bano, dsha_televison, 
            dsha_cable, dsha_num_camas, dsha_cama_aux,dsha_iva,dsha_disp_actu)
    VALUES (p_numHab, p_num_max_pers, p_num_min_pers, p_bano , 
            p_televison, p_cable, p_num_camas, p_cama_aux,p_iva,'D');

    
    RETURN 'OK';
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Err ' || sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';