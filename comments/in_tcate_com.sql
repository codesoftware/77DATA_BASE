COMMENT ON TABLE  IN_TCATE              IS          'Tabla encargada de registrar las categorias de los productos';
COMMENT ON COLUMN IN_TCATE.cate_cate    IS          'Identificador primario de la tabla';
COMMENT ON COLUMN IN_TCATE.cate_desc    IS          'Descripcion de la categoria';
COMMENT ON COLUMN IN_TCATE.cate_estado  IS          'Estado en el cual se encontrara la categoria ';
COMMENT ON COLUMN IN_TCATE.cate_runic   IS          'Indica si los productos de esta categoria se registrar en el sistema uno por uno osea con un registro unico';
COMMENT ON COLUMN IN_TCATE.cate_feven   IS          'Indica si los productos de esta categoria registran fecha de vencimiento para las alertas del sistema';