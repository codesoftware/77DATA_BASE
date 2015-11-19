-- Funcion encargada de

CREATE OR REPLACE FUNCTION US_FAUTENTICAR_USUA (  
                                       p_user      varchar(50),
                                       p_contra    varchar(50)
                                     ) RETURNS return_rta AS $$
    DECLARE
    
      v_acceso_aux           VARCHAR(2);
      v_tipo_usua           VARCHAR(2);
      v_tipo_usua_aux       VARCHAR(2);
      
      v_cambio_contra       VARCHAR(1);
      
      v_contador            int := 0;
      
      rta          return_rta;  
      
      c_usuario CURSOR FOR 
      SELECT tipoUsuario, cambio_contra
      FROM us_vusuarios
      WHERE UPPER(usuario) = UPPER(p_user)
        AND contra         = p_contra
        AND estado_usuario = 'A'
      ;
      
      c_usuario_aux CURSOR FOR 
      SELECT case 
                when tius_contra_futura = p_contra then 'S'
                else 'N'
                end rta, tius_cambio_contra
        FROM us_ttius
        WHERE UPPER(tius_usuario) = UPPER(p_user)
        ;
        
        c_cuenta_usuario CURSOR FOR
        SELECT count(*)
          FROM us_ttius
         WHERE UPPER(tius_usuario) = UPPER(p_user)
        ;
        
    BEGIN
        
        OPEN c_cuenta_usuario;
        FETCH c_cuenta_usuario INTO v_contador;
        CLOSE c_cuenta_usuario;
        
        
        IF v_contador = 0 THEN
            
            rta.msn_rta  := 'Acceso_denegado';
            rta.cod_rta  := 'ERR';
            rta.tipo_usu := '**'; 
            
        ELSE
        
            OPEN c_usuario_aux;
            FETCH c_usuario_aux INTO v_acceso_aux, v_cambio_contra;
            CLOSE c_usuario_aux; 
             
            IF upper(v_acceso_aux) = 'S' AND  upper(v_cambio_contra) = 'S'  THEN
            
                rta.msn_rta  := 'UPD';
                rta.cod_rta  := 'Acceso_aprobado';
                rta.tipo_usu := 'AD';
                
            ELSE
            
                OPEN c_usuario;
                FETCH c_usuario INTO v_tipo_usua, v_cambio_contra;
                CLOSE c_usuario;
                
                IF v_tipo_usua IS NOT NULL THEN
                
                    IF v_cambio_contra = 'S' THEN
                    
                        rta.msn_rta  := 'UPD';
                        rta.cod_rta  := 'Acceso_aprobado';
                        rta.tipo_usu := 'AD';
                        
                    ELSE
                    
                        UPDATE US_TTIUS
                        set tius_cambio_contra = 'N'
                        where upper(tius_usuario) = upper(p_user)
                        ;
                    
                        rta.msn_rta  := 'OK';
                        rta.cod_rta  := 'Acceso_aprobado';
                        rta.tipo_usu := v_tipo_usua;
                    
                    END IF;
                        
                    
                
                    
                ELSE
                    
                    rta.msn_rta  := 'Acceso_denegado';
                    rta.cod_rta  := 'ERR';
                    rta.tipo_usu := '**'; 
                    
                END IF;
                
            END IF;
            
        END IF;
        
        RETURN rta;
      
    END;
$$ LANGUAGE 'plpgsql';