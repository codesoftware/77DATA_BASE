COMMENT  ON TABLE in_tmpidexc                      IS 'Tabla encargada de almacenar los datos del excel que se sube para hacer cargue masivo solo id';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_tmpidexc    IS 'llave primaria de la tabla';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_codexte     IS 'Codigo externo del producto';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_ubicaci     IS 'Ubicacion del producto en el almacen';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_descrip     IS 'Descripcion del producto en el almacen';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_categor     IS 'llave de la tabla in_tcate';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_subcate     IS 'llave de la tabla in_trefe';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_tipo        IS 'llave del la tabla de marca';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_existencia  IS 'cantidad de productos';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_costo       IS 'costo por unidad de los productos';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_fecha       IS ' fecha de insercion';
COMMENT ON COLUMN in_tmpidexc.tmpidexc_usu         IS 'usuario que ingreso el excel';
