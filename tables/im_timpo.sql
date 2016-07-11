--
-- Creacion de la tabla para llevar el registro de importaciones
--
CREATE TABLE im_timpo(
    impo_impo                   BIGSERIAL                               NOT NULL    ,
    impo_nombre                 varchar(1000)                           NOT NULL    ,
    impo_fecCrea                timestamp           default now()       NOT NULL    ,
    impo_fecLlegada             timestamp                               NOT NULL    ,
    impo_estado                 varchar(2)          default 'C'         NOT NULL    , --Estado C (creado o en ejecucion) y X (Cerrado o ya finalizo el proceso)
    impo_pvin                   BIGINT                                  NOT NULL    , 
    impo_tius                   BIGINT                                  NOT NULL    , 
    impo_vlrTotal               numeric(1000,10)    default 0               , 
    impo_vlrImpu                numeric(1000,10)    default 0               , 
    impo_trm                    numeric(1000,10)    default 0               , 
    impo_tazaProm               numeric(1000,10)    default 0               , 
    impo_idTrans_co             BIGINT              default 0               ,
    impo_vlr_fob                numeric(1000,10)    default 0               ,
PRIMARY KEY (impo_impo)
);