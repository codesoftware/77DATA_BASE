-- CREAMOS LA TABLA SEDE
-- Tabla en la cual se almacena la informacion de las sedes.
-- 

--DROP TABLE IF EXISTS em_tsede;

CREATE TABLE em_tsede(
   sede_sede                BIGSERIAL                       ,  
   sede_nombre              varchar(500)                    , 
   sede_direccion           varchar(500)                    , 
   sede_telefono            varchar(20)                     , 
   sede_fecin               DATE        default now()       ,
   sede_tius                BIGINT                          ,
   sede_estado              varchar(2) default   'A'        ,
   sede_bodega              varchar(2) default   'N'        ,
   sede_sbcu_caja           BIGINT        default    0      ,
   sede_rsfa                BIGINT                          ,
   PRIMARY KEY (sede_sede)	
); 