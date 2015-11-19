COMMENT ON TABLE    CO_TSBFT                         IS     'Tabla encargada de almacenar las subcuentas fijas que tendra los documentos';
COMMENT ON COLUMN   CO_TSBFT.SBFT_SBFT               IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   CO_TSBFT.SBFT_TIDO               IS     'Identificador de la tabla de tipo de documentos';
COMMENT ON COLUMN   CO_TSBFT.SBFT_SBCU_CODIGO        IS     'Codigo de la subcuenta que se utilizara en el momento de realizar el movimiento contable';
COMMENT ON COLUMN   CO_TSBFT.SBFT_NATURALEZA         IS     'Naturaleza que tendra el movimiento contable Debito(D) o Credito(C)';
COMMENT ON COLUMN   CO_TSBFT.SBFT_PORCENTAJE         IS     'Porcentaje que tendra dentro del movimiento de inventario si es -1 es por que no aplica';
COMMENT ON COLUMN   CO_TSBFT.SBFT_VISIBLE            IS     'Porcentaje que tendra dentro del movimiento de inventario si es -1 es por que no aplica';