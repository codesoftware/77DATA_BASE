--
-- Creacion de la tabla para llevar el registro de proveedores internacionales
--
CREATE TABLE im_tpvin(
    pvin_pvin               BIGSERIAL                           ,
    pvin_id                 VARCHAR(1000)       NOT NULL        ,
    pvin_nombre             VARCHAR(1000)       NOT NULL        ,
    pvin_contacto           VARCHAR(1000)       NOT NULL        ,
    pvin_ubicacion          VARCHAR(1000)       NOT NULL        ,
PRIMARY KEY (pvin_pvin)
);