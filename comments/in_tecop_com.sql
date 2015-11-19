COMMENT ON TABLE    IN_TECOP                                IS     'Tabla encargada de almacenar los datos al ejecutar un conteo de inventarios';
COMMENT ON COLUMN   IN_TECOP.ECOP_ECOP                      IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   IN_TECOP.ECOP_COPR                      IS     'Llave foranea con la tabla in_tcopr';
COMMENT ON COLUMN   IN_TECOP.ECOP_DSKA                      IS     'Llave foranea con la tabla in_tdska (productos)';
COMMENT ON COLUMN   IN_TECOP.ECOP_VALOR                     IS     'Numero de valores del producto';
COMMENT ON COLUMN   IN_TECOP.ECOP_EXISTENCIAS               IS     'Existencias del producto en la sede del inventario a la fecha de cierre del conteo';
COMMENT ON COLUMN   IN_TECOP.ECOP_DIFERENCIA                IS     'Diferencia entre los valores del conteo y las existencias que deberian haber en la sede';