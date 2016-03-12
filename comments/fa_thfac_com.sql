COMMENT ON TABLE FA_THFAC       			IS 'Tabla encargada de llevar el historial de las facturas';
COMMENT ON COLUMN FA_THFAC.HFAC_HFAC        IS 'id unico de la tabla';
COMMENT ON COLUMN FA_THFAC.HFAC_TIUS        IS 'foranea de us_tius';
COMMENT ON COLUMN FA_THFAC.HFAC_FECH        IS 'fecha de insercion del registro';
COMMENT ON COLUMN FA_THFAC.HFAC_FACT        IS 'foranea de fa_tfact';
COMMENT ON COLUMN FA_THFAC.HFAC_COME        IS 'comentario del historial';
COMMENT ON COLUMN FA_THFAC.HFAC_CLIE        IS 'foreana us_tclien';
COMMENT ON COLUMN FA_THFAC.HFAC_ESTA        IS 'estado del registro';
