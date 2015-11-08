COMMENT ON TABLE  FA_TRRKA              IS          'Tabla encrgada de llevar el control del kardex que registra cada receta';
COMMENT ON COLUMN FA_TRRKA.RRKA_RRKA    IS          'Identificador primario de la tabla';
COMMENT ON COLUMN FA_TRRKA.RRKA_DTRE    IS          'Relacion con la tabla de detalle de recetas';
COMMENT ON COLUMN FA_TRRKA.RRKA_RECE    IS          'Indica la receta que implico el la facturacion del producto';
COMMENT ON COLUMN FA_TRRKA.RRKA_DSKA    IS          'Producto que registro el kardex';
COMMENT ON COLUMN FA_TRRKA.RRKA_KAPR    IS          'Registro exacto del kardex';
COMMENT ON COLUMN FA_TRRKA.RRKA_FECHA   IS          'Fecha en la cual se creo el registro';