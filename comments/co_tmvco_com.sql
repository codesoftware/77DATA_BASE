COMMENT ON TABLE   	CO_TMVCO                        IS     'Tabla encargada de almacenar los movimientos contables de la empresa';
COMMENT ON COLUMN   CO_TMVCO.MVCO_MVCO              IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   CO_TMVCO.MVCO_TRANS             IS     'Codigo de transaccion nos indica cuales fueron todos los movimientos realizados en una transaccion(Los otros movimientos deben tener el mismo codigo para realizar el asiento contable)';
COMMENT ON COLUMN   CO_TMVCO.MVCO_SBCU              IS     'Identificador primario de la tabla de subcuentas';
COMMENT ON COLUMN   CO_TMVCO.MVCO_NATURALEZA        IS     'Identifica si el movimiento fue de debito(D) o Credito(C) para la subcuenta';
COMMENT ON COLUMN   CO_TMVCO.MVCO_TIDO              IS     'Indica que tipo de documento se creo al realizar esta transaccion';
COMMENT ON COLUMN   CO_TMVCO.MVCO_VALOR             IS     'Valor por el cual se realizo el movimiento';
COMMENT ON COLUMN   CO_TMVCO.MVCO_LLADETALLE        IS     'Identificador con el cual se sabe si genero un movimiento de inventario o una factura etc.(pgrm) Pago de una remision, importacion(impo), gasto importacion(gaimp), aporte de socio (apor) ';
COMMENT ON COLUMN   CO_TMVCO.MVCO_ID_LLAVE          IS     'Identificador del movimiento que genera el movimiento';
COMMENT ON COLUMN   CO_TMVCO.MVCO_TERCERO           IS     'Identificador primario del tercero que genero el movimiento si es -1 es por que no existe tercero';
COMMENT ON COLUMN   CO_TMVCO.MVCO_TIPO              IS     'Indica que tipo de tercero esta implicado en el movimiento Cliente(1), Proveedor(2), Proveedor Internacional(3) y Socio (4) ';
COMMENT ON COLUMN   CO_TMVCO.MVCO_FECHA             IS     'Fecha en el cual se realizo el movimiento contable';