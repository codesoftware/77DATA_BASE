--CREAMOS LA TABLA CONSOLIDADO DE PRODUCTOS
--Tabla en la cual se almacenaran los datos consolidados de existencias de cada producto como lo es su promedio ponderado y su existencia
--
--DROP TABLE IF EXISTS in_tcopr

CREATE TABLE in_tcepr(
    cepr_cepr               SERIAL          , 
    cepr_dska               INT             ,
    cepr_existencia         INT             ,
    cepr_promedio_uni       NUMERIC(50,6)   ,
    cepr_promedio_total     NUMERIC(50,6)   ,     
PRIMARY KEY (cepr_cepr)
);