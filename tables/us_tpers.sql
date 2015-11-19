--
--Tabla en la cual se almacenan los datos principales de una persona
--
--drop table if exists US_TPERS;


CREATE TABLE US_TPERS(
   PERS_PERS               SERIAL                                       ,
   PERS_APELLIDO           VARCHAR(50)      NOT NULL                    ,
   PERS_NOMBRE             VARCHAR(50)      NOT NULL                    ,
   PERS_CEDULA             VARCHAR(50)      NOT NULL                    ,
   PERS_EMAIL              VARCHAR(50)      NOT NULL                    ,
   PERS_FECHA_NAC          DATE             NOT NULL                    ,
   PERS_TEL                VARCHAR(50)                                  ,
   PERS_CEL                VARCHAR(50)                                  ,
   PERS_DIR                VARCHAR(50)                                  ,
   PERS_DEPT_RESI          VARCHAR(50)                                  ,
   PERS_CIUDAD_RESI        VARCHAR(50)                                  ,
   PRIMARY KEY (PERS_PERS)
); 