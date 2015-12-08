COMMENT ON TABLE    IN_TPRPD               IS     'Tabla en la cual almacenamos los precios que tendran los productos por unidad, centena y millar(precio producto con descuento)';
COMMENT ON COLUMN   IN_TPRPD.PRPD_PRPD     IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   IN_TPRPD.PRPD_DSKA     IS     'Llave foranea con la tabla de productos';
COMMENT ON COLUMN   IN_TPRPD.PRPD_SEDE     IS     'Llave con la tabla de sedes';
COMMENT ON COLUMN   IN_TPRPD.PRPD_PREU     IS     'Precio por unidad del producto';
COMMENT ON COLUMN   IN_TPRPD.PRPD_PREC     IS     'Precio por 100 unidades';
COMMENT ON COLUMN   IN_TPRPD.PRPD_PREM     IS     'Precio por millar del producto ';