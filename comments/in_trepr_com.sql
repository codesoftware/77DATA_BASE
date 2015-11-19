COMMENT ON TABLE  IN_TREPR                      IS         'Tabla encargada de almacenar los productos asociados a una receta ';
COMMENT ON COLUMN IN_TREPR.REPR_REPR            IS          'Identificador primario de la tabla';
COMMENT ON COLUMN IN_TREPR.REPR_RECE            IS          'Llave foranea con la tabla in_trece con el cual se a que receta pertence el producto.';
COMMENT ON COLUMN IN_TREPR.REPR_DSKA            IS          'Llave foranea con la tabla in_tdska con la cual se asocia el producto a la receta ';
COMMENT ON COLUMN IN_TREPR.REPR_PROMEDIO        IS          'Promedio ponderado que tiene el producto en el momento';
COMMENT ON COLUMN IN_TREPR.REPR_ESTADO          IS          'Estaddo del producto dentro de la receta Inactivo(I) y Activo(A)';
COMMENT ON COLUMN IN_TREPR.REPR_FEC_INGRESO     IS          'Fecha de ingreso del registro en la base de datos';
COMMENT ON COLUMN IN_TREPR.REPR_TIUS            IS          'Usuario que creo el registro en la base de datos';
COMMENT ON COLUMN IN_TREPR.REPR_CANTIDAD        IS          'Cantidad de productos que necesita la receta';