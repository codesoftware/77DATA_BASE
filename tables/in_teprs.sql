--CREAMOS LA TABLA CONSOLIDADO DE EXISTENCIAS POR SEDE
--Tabla en la cual se almacenaran los datos consolidados de existencias de cada producto en cada sede
--
--DROP TABLE IF EXISTS in_teprs

CREATE TABLE in_teprs(
    eprs_eprs               BIGSERIAL       , 
    eprs_dska               INT             ,
    eprs_existencia         INT             ,
    eprs_sede               int             ,
PRIMARY KEY (eprs_eprs)
);