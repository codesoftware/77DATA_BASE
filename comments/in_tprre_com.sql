COMMENT ON TABLE  IN_TPRRE                      IS         'Tabla encargada de almacenar los precios de cada receta discriminados por sede y por estado ';
COMMENT ON COLUMN IN_TPRRE.PRRE_PRRE            IS          'Identificador primario de la tabla';
COMMENT ON COLUMN IN_TPRRE.PRRE_RECE            IS          'Llave foranea con la tabla in?trece con el cual se sabe que es el precio de una receta';
COMMENT ON COLUMN IN_TPRRE.PRRE_PRECIO          IS          'Precio parametrizado en el sistema ';
COMMENT ON COLUMN IN_TPRRE.PRRE_TIUS_CREA       IS          'Usuario que creo el registro en la base de datos';
COMMENT ON COLUMN IN_TPRRE.PRRE_TIUS_UPDATE     IS          'Ultimo usuario que actualizo el registro';
COMMENT ON COLUMN IN_TPRRE.PRRE_ESTADO          IS          'Estado de el precio del producto, Inactivo (I) Activo o en uso(A)';
COMMENT ON COLUMN IN_TPRRE.PRRE_FECHA           IS          'Fecha en la cual se creo el registro';
COMMENT ON COLUMN IN_TPRRE.PRRE_SEDE            IS          'Sede en la cual funcionara el precio parametrizado';