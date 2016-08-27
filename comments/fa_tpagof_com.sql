COMMENT ON TABLE FA_TPAGOF     IS 'Tabla encargada de almacenar los pagos posteriores de la factura de compra';

COMMENT  ON COLUMN FA_TPAGOF.pagof_pagof IS 'Identificador primario de la tabla ';
COMMENT  ON COLUMN FA_TPAGOF.pagof_facom IS 'llave foranea con la tabla de fa_tfacom  factura de compra';
COMMENT  ON COLUMN FA_TPAGOF.pagof_auco  IS  'llave foranea con la tabla de co_tauco auxiliar contable';
COMMENT  ON COLUMN FA_TPAGOF.pagof_valor IS 'Valor del pago realizado ';
COMMENT  ON COLUMN FA_TPAGOF.pagof_fecha IS 'fecha en la cual se realiza el pago';
COMMENT  ON COLUMN FA_TPAGOF.pagof_estad IS 'Estado del pago , (P) pagado, (R) reversado';