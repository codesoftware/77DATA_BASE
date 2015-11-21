COMMENT ON TABLE in_tpedi             IS 'Tabla encargada de almacenar los datos de los pedidos';
COMMENT ON COLUMN in_tpedi.pedi_pedi  IS 'llave primaria de la tabla ';
COMMENT ON COLUMN in_tpedi.pedi_sede  IS 'llave foranea de la tabla em_tsede ';
COMMENT ON COLUMN in_tpedi.pedi_usu   IS 'llave foranea de la tabla us_tpers';
COMMENT ON COLUMN in_tpedi.pedi_fech  IS 'fecha de creacion del pedido';
COMMENT ON COLUMN in_tpedi.pedi_esta  IS 'Estado del pedido  CREADO (CR),CANCELADO (CA), FACTURADO(FA)';
COMMENT ON COLUMN in_tpedi.pedi_clie  IS 'llave foranea de la tabla us_tclien';



