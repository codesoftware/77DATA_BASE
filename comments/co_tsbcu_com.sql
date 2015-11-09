COMMENT ON TABLE    CO_TSBCU                         IS     'Tabla encargada de almacenar los tipos de subcuenta de PUC es el ultimo nivel del puc comercial y depende de las cuentas';
COMMENT ON COLUMN   CO_TSBCU.SBCU_SBCU               IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   CO_TSBCU.SBCU_CUEN               IS     'Llave foranea de la table co_tcuen';
COMMENT ON COLUMN   CO_TSBCU.SBCU_CLAS               IS     'Llave foranea de la table co_tclas';
COMMENT ON COLUMN   CO_TSBCU.SBCU_GRUP               IS     'Llave foranea de la table co_tgrup';
COMMENT ON COLUMN   CO_TSBCU.SBCU_NOMBRE             IS     'Nombre de la subcuenta de PUC';
COMMENT ON COLUMN   CO_TSBCU.SBCU_ESTADO             IS     'Estado de los grupos "I" inactivo "A" activo';
