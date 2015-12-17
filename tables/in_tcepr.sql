--CREAMOS LA TABLA CONSOLIDADO DE PRODUCTOS
--Tabla en la cual se almacenaran los datos consolidados de existencias de cada producto como lo es su promedio ponderado y su existencia
--
--DROP TABLE IF EXISTS in_tcopr

CREATE TABLE in_tcepr(
    cepr_cepr               BIGSERIAL          , 
    cepr_dska               BIGINT             ,
    cepr_existencia         BIGINT             ,
    cepr_promedio_uni       NUMERIC(1000,10)   ,
    cepr_promedio_total     NUMERIC(1000,10)   ,     
PRIMARY KEY (cepr_cepr)
);