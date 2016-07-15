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
	
	
	BEGIN
	
	
	
	EXCEPTION WHEN OTHERS THEN
      RETURN 'Error FA_FACTURA_PRODUCTO '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';