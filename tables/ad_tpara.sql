--CREAMOS LA TABLA PARAMETROS 
--Tabla en la cual se almacenaran los prarametros para que el administrador pueda visualizar
--
--DROP TABLE IF EXISTS ad_tpara

CREATE TABLE ad_tpara(
para_para             BIGSERIAL                     ,
para_nombre           VARCHAR(500)                  ,
para_estado           varchar(2)   DEFAULT 'A'      ,
PRIMARY KEY (para_para)
);