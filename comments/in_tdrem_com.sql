COMMENT ON TABLE    IN_TDREM                        IS     'Tabla encargada de almacenar los datos del detalle de remisiones';
COMMENT ON COLUMN   IN_TDREM.DREM_DREM              IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   IN_TDREM.DREM_REMI              IS     'Llave foranea con la tabla de remisiones.';
COMMENT ON COLUMN   IN_TDREM.DREM_DSKA              IS     'Llave foranea con la tabla de productos';
COMMENT ON COLUMN   IN_TDREM.DREM_PRECIO            IS     'Precio en el cual se vendio el producto';
COMMENT ON COLUMN   IN_TDREM.DREM_CANTID            IS     'Cantidad de productos ';
COMMENT ON COLUMN   IN_TDREM.DREM_ESTADO            IS     'Estado en el cual se encuentra el detalle del producto A(Activo) e I(Inactivo)';
COMMENT ON COLUMN   IN_TDREM.DREM_FECHA             IS     'Fecha en la cual se realizo el detalle del producto';