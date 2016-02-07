--
-- Trigger el cual se encargara de relacionar la cuenta con el grupo 
--
CREATE OR REPLACE FUNCTION f_ins_pedprod_costos() RETURNS trigger AS $f_ins_pedprod_costos$
    DECLARE
        --
        --Cursor con el cual se obtiene el promedio ponderado del producto en el momento de la creacion del pedido
        --
        c_prom_pond_prod cursor for
        select cepr_promedio_uni
          from in_tcepr
         where cepr_dska = new.pedprod_dska
         ;
        --
        v_prom_pond         numeric(1000,10) := 0;
        --
        --Cursor que obtiene el iva parametrizado
        --
        c_iva_precio CURSOR IS
        SELECT cast(para_valor as numeric)
          FROM em_tpara
         WHERE para_clave = 'IVAPRVENTA'
        ;
        --
        v_iva_precio        NUMERIC(1000,10) := 0;
        v_auxiliar          NUMERIC(1000,10) := 0;
        --
        v_precio_base       NUMERIC(1000,10) := 0;
        --
    BEGIN
        --
        OPEN c_prom_pond_prod;
        FETCH c_prom_pond_prod into v_prom_pond;
        CLOSE c_prom_pond_prod;
        --
        OPEN c_iva_precio;
        FETCH c_iva_precio INTO v_iva_precio;
        CLOSE c_iva_precio;
        --
        --
        --Saco la base del iva
        v_auxiliar := 100.00;
        --
        v_auxiliar :=  (v_iva_precio / v_auxiliar)+1;
        --
        v_precio_base :=  (new.pedprod_precio - new.pedprod_descu) /v_auxiliar;
        --
        if v_prom_pond >= v_precio_base then
            --
            raise exception 'El precio que se le dara al producto es inferior al promedio ponderado del mismo operacion no permitida';
            --
        end if;
        --
        --raise exception 'Prueba de error de pedidos ';
        --
        RETURN NEW;        
        --
    END;
$f_ins_pedprod_costos$ LANGUAGE plpgsql;


CREATE TRIGGER f_ins_pedprod
    AFTER INSERT OR UPDATE ON in_tpedprod
    FOR EACH ROW
    EXECUTE PROCEDURE f_ins_pedprod_costos()
    ;