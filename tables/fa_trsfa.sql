-- CREAMOS LA Resoluciones de Facturacion
-- Tabla en la cual se almacena la informacion para las resoluciones de facturacion
-- 

--DROP TABLE IF EXISTS fa_trsfa;

CREATE TABLE fa_trsfa(
   rsfa_rsfa                    BIGSERIAL                                           ,
   rsfa_prefij                  varchar(50)         not null                        , 
   rsfa_fechaInic               TIMESTAMP           not null                        , 
   rsfa_consec                  numeric(1000,10)    not null        DEFAULT 0       , 
   rsfa_inicon                  numeric(1000,10)    not null        DEFAULT 0       , 
   rsfa_estado                  varchar(4)                                          ,
   rsfa_fecha                   timestamp           not null        DEFAULT NOW()   ,
   rsfa_comentario              varchar(1000)       not null                        ,   
   PRIMARY KEY (rsfa_rsfa)	
);
