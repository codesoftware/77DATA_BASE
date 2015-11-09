COMMENT ON TABLE  IN_TCATE                 IS         'Tabla encargada de almacenar las categorias que estan asociadas a los prductos, y con estas se creara una subcuenta en la 1435 para su movimiento de inventario respectivo';
COMMENT ON COLUMN IN_TCATE.CATE_CATE      IS          'Identificador primario de la tabla';
COMMENT ON COLUMN IN_TCATE.CATE_DESC      IS          'Descripcion de la categoria';
COMMENT ON COLUMN IN_TCATE.CATE_ESTADO    IS          'Estado de la categoria ';
COMMENT ON COLUMN IN_TCATE.CATE_RUNIC     IS          'parametro el cual no se usa en el momento';
COMMENT ON COLUMN IN_TCATE.CATE_FEVEN     IS          'parametro el cual no se usa en el momento';
COMMENT ON COLUMN IN_TCATE.CATE_SBCU	  IS          'Subcuenta la cual se usa para el ingreso de inventario';