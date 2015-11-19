-- CREAMOS LA TABLA MARCA
-- Tabla en la cual se almacena las marcas de los productos
-- 

--DROP TABLE IF EXISTS em_tsede;

CREATE TABLE in_tmarca(
   marca_marca                     SERIAL                       ,  
   marca_nombre                    varchar(200)                 , 
   marca_descr                     varchar(200)                 , 
   marca_estado                    varchar(2) default   'A'     ,
   PRIMARY KEY (marca_marca)	
); 

