--
-- Creacion de la tabla para llevar el registro de importaciones
--
CREATE TABLE im_timpo(
    impo_impo                   BIGSERIAL                               NOT NULL    ,
    impo_nombre                 varchar(1000)                           NOT NULL    ,
    impo_fecCrea                timestamp           default now()       NOT NULL    ,
    impo_fecLlegada             timestamp                               NOT NULL    ,
    impo_pvin                   BIGINT                                  NOT NULL    , 
    impo_tius                   BIGINT                                  NOT NULL    , 
    impo_vlrTotal               numeric(1000,10)    default 0           NOT NULL    , 
    impo_vlrImpu                numeric(1000,10)    default 0           NOT NULL    , 
PRIMARY KEY (impo_impo)
);