-- Función con la cual se realizara la inserccion de un cliente

CREATE OR REPLACE FUNCTION US_FINSERT_CLIENTE (    
                                            p_nombres           varchar(50), 
                                            p_apellidos         varchar(50), 
                                            p_cedula            numeric, 
                                            p_email             varchar(50), 
                                            p_telefono          varchar(50)                                            
                                            ) RETURNS varchar AS $$
    DECLARE
                                            
    c_cliente cursor for
    SELECT count(*)
      FROM us_tclien
     WHERE clien_cedula = p_cedula
    ;        
    --
    v_clien_cedula    numeric(10,0);
    --
    v_clien_clien     int;
    --
    c_clien_clien CURSOR FOR
    SELECT nextval('us_tclien_clien_clien_seq')
    ;
    --
    BEGIN
    --
    OPEN c_cliente;
    FETCH c_cliente INTO v_clien_cedula;
    CLOSE c_cliente;
    --
    
    IF v_clien_cedula = 0 THEN
        --
        OPEN c_clien_clien;
        FETCH c_clien_clien INTO v_clien_clien;
        CLOSE c_clien_clien;
        --
        INSERT INTO us_tclien(
            clien_clien,
            clien_cedula, 
            clien_nombres, 
            clien_apellidos, 
            clien_telefono, 
            clien_correo)
        VALUES (
                v_clien_clien,
                p_cedula, 
                p_nombres, 
                p_apellidos, 
                p_telefono, 
                p_email);
        --
        RETURN 'Ok-'||v_clien_clien;
        --        
    ELSE
        --
        RAISE EXCEPTION ' El usuario con cedula % que desea ingresar ya existe en la base de datos ',p_cedula ;
        --
    END IF;
    
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Err' || sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';