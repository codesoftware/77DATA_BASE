COMMENT ON TABLE    im_tgast                           IS     'Tabla encargada de almacenar los gastos que conlleva la importacion';
COMMENT ON COLUMN   im_tgast.gast_gast                 IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   im_tgast.gast_impo                 IS     'Identificador llave foranea de con la tabla de importaciones';
COMMENT ON COLUMN   im_tgast.gast_desc                 IS     'Descripcion del gasto';
COMMENT ON COLUMN   im_tgast.gast_tius                 IS     'Usuario que registro el gasto';
COMMENT ON COLUMN   im_tgast.gast_valor                IS     'Valor del gasto';
COMMENT ON COLUMN   im_tgast.gast_fecha                IS     'Fecha en la cual se realizo el gasto';
COMMENT ON COLUMN   im_tgast.gast_fechaRegi            IS     'Fecha en la cual se registro el gasto';
