COMMENT ON TABLE CO_TTEM_MVCO                        IS  'Tabla temporal para almacenar los datos basicos para crear un movimiento contable';
COMMENT ON COLUMN CO_TTEM_MVCO.TEM_MVCO_TRANS        IS  'Llave con la cual se unira toda las subcuentas de una transaccion';
COMMENT ON COLUMN CO_TTEM_MVCO.TEM_MVCO_SBCU         IS  'Subcuenta implicada en el movimiento contable CODIGO DE LA SUBCUENTA';
COMMENT ON COLUMN CO_TTEM_MVCO.TEM_MVCO_VALOR        IS  'Valor implicado en el movimiento contable';
COMMENT ON COLUMN CO_TTEM_MVCO.TEM_MVCO_NATURALEZA   IS  'Naturaleza del movimiento contable';