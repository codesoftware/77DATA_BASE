-- CREAMOS LA TABLA CLIENTE
-- Tabla en la cual identificara cuales son los clientes del hotel

--DROP TABLE IF EXISTS US_TCLIEN; 

CREATE TABLE US_TCLIEN(
   CLIEN_CLIEN            BIGSERIAL                            ,   -- Llave primaria de la tabla
   CLIEN_CEDULA           VARCHAR(500)       NOT NULL          ,   -- Llave foranea de la tabla us_tpers
   CLIEN_NOMBRES          VARCHAR(500)       NOT NULL          ,
   CLIEN_APELLIDOS        VARCHAR(500)                         ,
   CLIEN_TELEFONO         VARCHAR(500)                         ,
   CLIEN_CORREO           VARCHAR(500)                         ,   
   CLIEN_DIRECCION        VARCHAR(500)                         ,   
   PRIMARY KEY (CLIEN_CLIEN)
);
--
--Tabla para el cargue temporal de clientes
--
CREATE TABLE us_tmpclien(
    tmpclien_tmpclien           BIGSERIAL                NOT NULL   ,
    tmpclien_nit                varchar(500)          NOT NULL   ,
    tmpclien_nombre             varchar(2000)         NOT NULL   ,
    tmpclien_direccion          varchar(2000)                    ,
    tmpclien_telefono           varchar(2000)                    ,
    tmpclien_ciudad             varchar(2000)                    ,
PRIMARY KEY (tmpclien_tmpclien)
);
