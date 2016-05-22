COMMENT  ON TABLE FA_TSOPD                   IS 'Tabla encargada de almacenar los productos de la solicitud';
COMMENT  ON COLUMN FA_TSOPD.SOPD_SOPD        IS 'id unico de la tabla';
COMMENT  ON COLUMN FA_TSOPD.SOPD_DSKA        IS 'llave foranea de in_tdska';
COMMENT  ON COLUMN FA_TSOPD.SOPD_SOLI        IS 'llave foranea de fa_tsoli';
COMMENT  ON COLUMN FA_TSOPD.SOPD_CANT        IS 'cantidades del producto';