
-- CREAMOS LA TABLA TIPO USUARIO
-- Tabla en la cual se almacenara los datos de solo los usuarios del sistema

--DROP TABLE IF EXISTS US_TTIUS; 

CREATE TABLE US_TPERF(
    PERF_PERF               SERIAL,            -- Identificador primario de la tabla
    PERF_NOMB               VARCHAR(50) ,      -- Nombre del perfil el cual le dan al usuario
    PERF_DESC               VARCHAR(500),      -- Descripcion de las funciones que tendra el perfil
    PERF_PERMISOS           VARCHAR(800),      -- Permisos los cuales tendra el perfil
    PERF_ESTADO             VARCHAR(1)  ,      -- Estados los cuales puede tener el perfil A(Activo) I(Inactivo) X(Eliminado)
    PRIMARY KEY  (PERF_PERF)
);