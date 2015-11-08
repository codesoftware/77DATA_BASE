COMMENT ON TABLE  EM_TSEDE                 IS          'Tabla encargada de adicionar sedes de la empresa';
COMMENT ON COLUMN EM_TSEDE.SEDE_SEDE       IS          'Identificador primario de la tabla';
COMMENT ON COLUMN EM_TSEDE.SEDE_NOMBRE     IS          'Nombre de la sede (se vera reflejado en la factura)';
COMMENT ON COLUMN EM_TSEDE.SEDE_DIRECCION  IS          'Direccion de la sede ';
COMMENT ON COLUMN EM_TSEDE.SEDE_TELEFONO   IS          'Telefono de la sede';
COMMENT ON COLUMN EM_TSEDE.SEDE_FECIN      IS          'Fecha en la cual se inserta la sede';
COMMENT ON COLUMN EM_TSEDE.SEDE_TIUS       IS          'usuario que inserta la sede ( llave foranea de us_ttius )';