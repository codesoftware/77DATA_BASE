COMMENT ON TABLE  US_TPERF                  IS          'Tabla encrgada de controlar los perfiles que tendran los usuarios dentro de la aplicación';
COMMENT ON COLUMN US_TPERF.PERF_PERF        IS          'Identificador primario de la tabla';
COMMENT ON COLUMN US_TPERF.PERF_NOMB        IS          'Nombre que se le dara a los perfiles que tendra la aplicación';
COMMENT ON COLUMN US_TPERF.PERF_DESC        IS          'Descripcion del perfil que tendra la aplicación';
COMMENT ON COLUMN US_TPERF.PERF_PERMISOS    IS          'Permisos que adquirira el perfil';
COMMENT ON COLUMN US_TPERF.PERF_ESTADO      IS          'Estados los cuales puede tener el perfil A(Activo) I(Inactivo) X(Eliminado)';