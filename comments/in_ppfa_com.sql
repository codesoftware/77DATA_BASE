COMMENT ON TABLE   	IN_TPPFA                 IS     'Tabla encargada de almacenar los codigos de los productos y recetas que se visualizaran en la pantalla principal de facturacion';
COMMENT ON COLUMN   IN_TPPFA.PPFA_PPFA       IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   IN_TPPFA.PPFA_CODIGO     IS     'Codigo del producto o de la receta';
COMMENT ON COLUMN   IN_TPPFA.PPFA_TIPO       IS     'Indica el tipo de producto es si es una receta(R) o producto (P)';
COMMENT ON COLUMN   IN_TPPFA.PPFA_NOMBRE     IS     'Indica el nombre que se visualizara en la pantalla de facturacion';
COMMENT ON COLUMN   IN_TPPFA.PPFA_POSICION   IS     'Posicion en la cual se mostrara en la pantalla';
COMMENT ON COLUMN   IN_TPPFA.PPGA_RUTA_IMG   IS     'Ruta de la imagen del producto o receta que se esta desea visualizar en la pantalla';