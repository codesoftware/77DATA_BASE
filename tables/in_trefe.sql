-- CREAMOS LA TABLA RFFERENCIAS
-- Tabla en la cual se almacena la informacion de las referencias.
-- 

--DROP TABLE IF EXISTS in_trefe;

CREATE TABLE in_trefe(
   refe_refe              SERIAL                        ,  
   refe_nombre            varchar(500) NOT NULL         ,
   refe_desc              varchar(500) NOT NULL         , 
   refe_estado            varchar(500) default  'A'     , 
   refe_came              varchar(500) default  'N/A'   , 
   refe_memori            varchar(500) default  'N/A'   ,
   refe_pantalla          varchar(500) default  'N/A'   ,
   PRIMARY KEY (refe_refe)	
); 
