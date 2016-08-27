COMMENT ON TABLE   	EM_TAPOR                       IS     'Tabla encargada de almacenar el registro de todos los aportes que han realizado los socios a la organizacion ';
COMMENT ON COLUMN   EM_TAPOR.APOR_APOR             IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   EM_TAPOR.APOR_CODIGO           IS     'Codigo que le da el cliente a su aporte, este campo es dado por el usuario';
COMMENT ON COLUMN   EM_TAPOR.APOR_DESC             IS     'Descripcion e informacion detallada del aporte';
COMMENT ON COLUMN   EM_TAPOR.APOR_TIUS             IS     'Usuario el cual registro el aporte';
COMMENT ON COLUMN   EM_TAPOR.APOR_FECHA            IS     'Fecha en la cual se registro el aporte';
COMMENT ON COLUMN   EM_TAPOR.APOR_VALOR            IS     'Valor por el cual se realizo el aporte de productos';
COMMENT ON COLUMN   EM_TAPOR.APOR_SOCI             IS     'Identificador del socio que realizo el aporte ';
COMMENT ON COLUMN   EM_TAPOR.APOR_TRAN_MVCO        IS     'Identificador del movimiento contable que genera el movimiento de la contabilidad';