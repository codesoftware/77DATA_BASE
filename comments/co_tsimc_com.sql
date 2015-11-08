COMMENT ON TABLE   	CO_TSIMC                        IS    'Tabla encargada de almacenar los datos temporales para la simulacion de movimientos contables';
COMMENT ON COLUMN   CO_TSIMC.SIMC_SIMC             IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   CO_TSIMC.SIMC_TRANS            IS     'Codigo de transaccion nos indica cuales fueron todos los movimientos realizados en una transaccion(Los otros movimientos deben tener el mismo codigo para realizar el asiento contable)';
COMMENT ON COLUMN   CO_TSIMC.SIMC_SBCU             IS     'Identificador primario de la tabla de subcuentas';
COMMENT ON COLUMN   CO_TSIMC.SIMC_NATURALEZA       IS     'Identifica si el movimiento fue de debito(D) o Credito(C) para la subcuenta';
COMMENT ON COLUMN   CO_TSIMC.SIMC_VALOR            IS     'Valor por el cual va ha ser realizado el movimiento contable';