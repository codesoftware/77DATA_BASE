-- CREAMOS LA TABLA REMISIONES para CELULARES
-- Tabla en la cual se almacenaran los datos de los celulares que entran en consignacion
-- 

--DROP TABLE IF EXISTS em_tpara;

CREATE TABLE in_trmce(
   rmce_rmce                SERIAL              NOT NULL    ,
   rmce_refe                int                 NOT NULL    ,
   rmce_imei                VARCHAR(150)        NOT NULL    ,
   rmce_iccid               VARCHAR(150)        NOT NULL    ,
   rmce_valor               NUMERIC(50,6)       NOT NULL    ,
   rmce_comision            NUMERIC(50,6)                   ,
   rmce_tppl                VARCHAR(2)          NOT NULL    ,
   rmce_fcve                date                NOT NULL    ,
   rmce_fcsl                date                            ,
   rmce_fcen                date default NOW()              ,
   rmce_tius_ent            int                 NOT NULL    ,
   rmce_tius_sal            int                             ,
   rmce_codigo              VARCHAR(25)     	NOT NULL    ,
   rmce_sede                int                 NOT NULL    ,
   rmce_estado              VARCHAR(2)          NOT NULL  DEFAULT 'E' ,
   rmce_pagado              VARCHAR(2)          NOT NULL  DEFAULT 'N' ,
   rmce_comdev              varchar(100)                    ,
   rmce_trans               int                 NOT NULL  DEFAULT -1 ,
   rmce_clien               int                  ,
   PRIMARY KEY (rmce_rmce)
);