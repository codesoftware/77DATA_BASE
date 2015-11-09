COMMENT ON TABLE    CO_TGRUP                        IS     'Tabla encargada de almacenar los grupos de PUC comercial es el segundo nivel del PUC comercial y depende de la CLASE';
COMMENT ON COLUMN   CO_TGRUP.GRUP_GRUP              IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   CO_TGRUP.GRUP_CLAS              IS     'Llave foranea de la table co_tclas';
COMMENT ON COLUMN   CO_TGRUP.GRUP_NOMBRE            IS     'Nombre del grupo de PUC';
COMMENT ON COLUMN   CO_TGRUP.GRUP_ESTADO            IS     'Estado de los grupos "I" inactivo "A" activo';