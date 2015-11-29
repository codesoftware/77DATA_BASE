-- CREAMOS LA TABLA SEDE
-- Tabla en la cual se almacena la informacion de las sedes.
-- 

--DROP TABLE IF EXISTS em_tsede;

CREATE TABLE em_tsede(
   sede_sede                SERIAL                       ,  
   sede_nombre              varchar(200)                 , 
   sede_direccion           varchar(200)                 , 
   sede_telefono            varchar(20)                  , 
   sede_fecin               date default now()           ,
   sede_tius                int                          ,
   sede_estado              varchar(2) default   'A'     ,
   sede_bodega              varchar(2) default   'N'     ,
   sede_sbcu_caja           int        default    0      ,
   PRIMARY KEY (sede_sede)	
); 