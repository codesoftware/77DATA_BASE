COMMENT ON TABLE  IN_TDSKA                          IS          'Tabla encargada de tener la descripcion de los productos con los cuales se llevara un registro Kardex';
COMMENT ON COLUMN IN_TDSKA.DSKA_DSKA                IS          'Identificador primario de la tabla';
COMMENT ON COLUMN IN_TDSKA.DSKA_REFE                IS          'Referencia del producto(formato AAAA-9999)(Unique key)';
COMMENT ON COLUMN IN_TDSKA.DSKA_COD                 IS          'Codigo identificador del Producto AAAA-999';
COMMENT ON COLUMN IN_TDSKA.DSKA_NOM_PROD            IS          'Nombre que identifica al producto';
COMMENT ON COLUMN IN_TDSKA.DSKA_IVA                 IS          'Indica si el producto es gravado con iva';
COMMENT ON COLUMN IN_TDSKA.DSKA_PORC_IVA            IS          'Porcentaje que se le deve grabar el iva';
COMMENT ON COLUMN IN_TDSKA.DSKA_MARCA               IS          'Marca del producto que se va a ingresar';
COMMENT ON COLUMN IN_TDSKA.DSKA_ESTADO              IS          'Estado en el cua se encuentra el producto A(Activo) e I(inactivo) al estar inactivo no se puede vender el producto';
COMMENT ON COLUMN IN_TDSKA.DSKA_FEC_INGRESO         IS          'Fecha en la cual se ingreso el producto a la base de datos';
COMMENT ON COLUMN IN_TDSKA.DSKA_CATE                IS          'Categoria del producto esta parametrica funciona para las subcuentas de inventario';
COMMENT ON COLUMN IN_TDSKA.DSKA_SBCU                IS          'Subcuenta a la cual se va el inventario de los productos';
COMMENT ON COLUMN IN_TDSKA.DSKA_PROV                IS          'Proveedor principal del producto';
COMMENT ON COLUMN IN_TDSKA.DSKA_INICONT             IS          'Campo con el cual se marcara un producto con el cual se iniciara un conteo';