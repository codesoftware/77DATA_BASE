--
--Tabla en la cual se almacenan los datos principales de una persona
--
--drop table if exists US_TPERS;


CREATE TABLE US_TPERS(
   PERS_PERS               BIGSERIAL                                     ,
   PERS_APELLIDO           VARCHAR(500)      NOT NULL                    ,
   PERS_NOMBRE             VARCHAR(500)      NOT NULL                    ,
   PERS_CEDULA             VARCHAR(500)      NOT NULL                    ,
   PERS_EMAIL              VARCHAR(500)      NOT NULL                    ,
   PERS_FECHA_NAC          DATE              NOT NULL                    ,
   PERS_TEL                VARCHAR(500)                                  ,
   PERS_CEL                VARCHAR(500)                                  ,
   PERS_DIR                VARCHAR(500)                                  ,
   PERS_DEPT_RESI          VARCHAR(500)                                  ,
   PERS_CIUDAD_RESI        VARCHAR(500)                                  ,
   PRIMARY KEY (PERS_PERS)
); 