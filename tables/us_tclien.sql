-- CREAMOS LA TABLA CLIENTE
-- Tabla en la cual identificara cuales son los clientes del hotel

--DROP TABLE IF EXISTS US_TCLIEN; 

CREATE TABLE US_TCLIEN(
   CLIEN_CLIEN            SERIAL                              ,   -- Llave primaria de la tabla
   CLIEN_CEDULA           NUMERIC(10,0)       NOT NULL        ,   -- Llave foranea de la tabla us_tpers
   CLIEN_NOMBRES          VARCHAR(50)         NOT NULL        ,
   CLIEN_APELLIDOS        VARCHAR(50)                         ,
   CLIEN_TELEFONO         VARCHAR(50)                         ,
   CLIEN_CORREO           VARCHAR(50)                         ,   
   CLIEN_DIRECCION        VARCHAR(50)                         ,   
   PRIMARY KEY (CLIEN_CLIEN)
);

CREATE TABLE us_tmpclien(
tmpclien_tmpclien serial NOT NULL,
tmpclien_nit      varchar(200) NOT NULL,
tmpclien_nombre   varchar(2000) NOT NULL,
tmpclien_direccion varchar(2000),
tmpclien_telefono varchar(2000),
tmpclien_ciudad  varchar(2000),
PRIMARY KEY (tmpclien_tmpclien)
);
