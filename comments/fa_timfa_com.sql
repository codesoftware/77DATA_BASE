COMMENT ON TABLE FA_TIMFA       			IS 'Tabla encargada de alamcenar los datos de las imagenes de las facturas';
COMMENT ON COLUMN FA_TIMFA.imfa_infa        IS 'id unico de la tabla';
COMMENT ON COLUMN FA_TIMFA.imfa_fact        IS 'llave foranea de la tabla factura';
COMMENT ON COLUMN FA_TIMFA.imfa_tipo      	IS 'tipo de imagen puede ser NC nota credito, ND nota debito';
COMMENT ON COLUMN FA_TIMFA.infa_ruta      	IS 'ruta de la imagen para la cual se puede visualizar';
COMMENT ON COLUMN FA_TIMFA.infa_esta      	IS 'estado del registro ';