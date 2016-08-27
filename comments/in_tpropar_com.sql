COMMENT ON TABLE IN_TPROPAR    IS 'Tabla encargada de almacenar los pagos productos que pueden ser no inventariables';

COMMENT  ON COLUMN IN_TPROPAR.PROPAR_PROPAR IS 'Identificador primario de la tabla ';
COMMENT  ON COLUMN IN_TPROPAR.PROPAR_DSKA IS 'llave foranea con la tabla de in_tdska producto';
COMMENT  ON COLUMN IN_TPROPAR.PROPAR_TIUS  IS  'llave foranea con la tabla de us_ttius usuario quien realiza la accion';
COMMENT  ON COLUMN IN_TPROPAR.PROPAR_AUCO IS 'llave foranea con la tabla de co_tauco auxiliar contable relacionado';
COMMENT  ON COLUMN IN_TPROPAR.PROPAR_ESTA IS 'Estado del pago , (A) acitvo, (I) inactivo';
COMMENT  ON COLUMN IN_TPROPAR.PROPAR_DESC IS 'Descripcion del producto';
COMMENT  ON COLUMN IN_TPROPAR.PROPAR_FECH IS 'fecha en la cual se realiza el registro';