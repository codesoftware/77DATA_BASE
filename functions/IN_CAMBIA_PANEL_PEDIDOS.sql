--
-- Funcion con la cual cambiare los productos de una sede a otra
--
CREATE OR REPLACE FUNCTION IN_CAMBIA_PANEL_PEDIDOS(   
                                            ) RETURNS VARCHAR AS $$
    DECLARE
    --
    c_tablaHome CURSOR FOR
    SELECT prodhome_prodhome , prodhome_nombre
      FROM fa_tprodhome 
      ;
    --
    c_datosRefe CURSOR (vc_nombre varchar)FOR
    SELECT REFE_REFE, REFE_CATE
      FROM in_trefe
     WHERE refe_nombre = vc_nombre
     ;
    --
    v_refe_refe         bigint := 0;
    v_refe_cate         bigint := 0;
    --
    BEGIN
    --
    FOR home in c_tablaHome LOOP
        --
        OPEN c_datosRefe(home.prodhome_nombre);
        FETCH c_datosRefe INTO v_refe_refe,v_refe_cate;
        CLOSE c_datosRefe;
        --
        --raise exception 'v_refe_cate % v_refe_refe %' , v_refe_cate, v_refe_refe;
        --
        IF v_refe_refe is not null AND v_refe_cate is not null THEN 
            --
            UPDATE fa_tprodhome 
               SET  prodhome_cate = v_refe_cate,
                    prodhome_refe = v_refe_refe
             WHERE prodhome_prodhome = home.prodhome_prodhome
            ;
            --
        END IF; 
        --
    END LOOP;
    --
    RETURN 'Ok';
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error ' ||sqlerrm ;
    END;
$$ LANGUAGE 'plpgsql';