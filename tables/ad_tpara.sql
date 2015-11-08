--CREAMOS LA TABLA PARAMETROS 
--Tabla en la cual se almacenaran los prarametros para que el administrador pueda visualizar
--
--DROP TABLE IF EXISTS ad_tpara

CREATE TABLE ad_tpara(
para_para             SERIAL                ,
para_nombre           varchar(200)          ,
para_estado           varchar(2)default 'A' ,
PRIMARY KEY (para_para)

);