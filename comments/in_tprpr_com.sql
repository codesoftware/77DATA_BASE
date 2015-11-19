COMMENT ON TABLE  IN_TPRPR                      IS         'Tabla encargada de almacenar los precios de cada producto discriminados por sede y por estado ';
COMMENT ON COLUMN IN_TPRPR.PRPR_PRPR            IS          'Identificador primario de la tabla';
COMMENT ON COLUMN IN_TPRPR.PRPR_DSKA            IS          'Llave foranea con la tabla in_tdska con el cual se sabe que es el precio de un producto';
COMMENT ON COLUMN IN_TPRPR.PRPR_PRECIO          IS          'Precio parametrizado en el sistema ';
COMMENT ON COLUMN IN_TPRPR.PRPR_TIUS_CREA       IS          'Usuario que creo el registro en la base de datos';
COMMENT ON COLUMN IN_TPRPR.PRPR_TIUS_UPDATE     IS          'Ultimo usuario que actualizo el registro';
COMMENT ON COLUMN IN_TPRPR.PRPR_ESTADO          IS          'Estado de el precio del producto, Inactivo (I) Activo o en uso(A)';
COMMENT ON COLUMN IN_TPRPR.PRPR_FECHA           IS          'Fecha en la cual se creo el registro';
COMMENT ON COLUMN IN_TPRPR.PRPR_SEDE            IS          'Sede en la cual funcionara el precio parametrizado';