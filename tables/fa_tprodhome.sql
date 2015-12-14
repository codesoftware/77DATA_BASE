--
--Tabla en la cual se almacenara la informacion para armar el panel agil de consulta de productos
--
CREATE TABLE fa_tprodhome (
    prodhome_prodhome    BIGSERIAL      NOT NULL        ,
    prodhome_cate        BIGINT         NOT NULL        ,
    prodhome_refe        BIGINT         NOT NULL        ,
    prodhome_sede        BIGINT         NOT NULL        ,
    prodhome_rutai       VARCHAR(500)                   ,
    prodhome_estado      VARCHAR(2)     DEFAULT 'A'     ,
    prodhome_nombre      VARCHAR(500)                   ,
    PRIMARY KEY(prodhome_prodhome)
);