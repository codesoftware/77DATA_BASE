--
-- Funcion encargada de realizar toda la facturacion del sistema
--
CREATE OR REPLACE FUNCTION FN_FACTPROD_MIGRACION_77(  
                                                p_tius          BIGINT,        --Id del usuario que esta registrando la venta del producto
                                                p_dska          BIGINT,        --Id del producto que se esta vendiendo
                                                p_sede          BIGINT,        --Sede en la cual se esta vendiendo el producto
                                                p_cantidad      BIGINT,        --Cantidad de productos que se vendieron
                                                p_idmvco        BIGINT,        --Id de los movimientos contables que generar la transaccion
                                                p_fact          BIGINT,        --Id de facturacion 
                                                p_precio        NUMERIC(1000,10)
                                            ) RETURNS VARCHAR  AS $$
	DECLARE
	    --
    --Variable utilizada para almacenar la respuesta de la salida de inventario
    --
    v_rta_insrt_kar         VARCHAR(500) := '';
    --
    --Variable en la cual se almacenara el movimiento de inventario que se encuentra parametrizado para las ventas
    --
    v_mvin_mvin             INT :=0;
    v_val_mvin_fact         INT := 0;

    --
    --Moviento de inventario parametrizado para la venta de productos
    --
    c_mvin_venta CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_venta = 'S'
     ;
	
	BEGIN
	
	
	
	EXCEPTION WHEN OTHERS THEN
      RETURN 'Error FA_FACTURA_PRODUCTO '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';