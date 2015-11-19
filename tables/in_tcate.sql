-- CREAMOS LA TABLA CATEGORIAS
-- Tabla en la cual se almacena la informacion de las categorias de los productos.
-- 

--DROP TABLE IF EXISTS in_tcate;

CREATE TABLE in_tcate(
   cate_cate                SERIAL                       ,  
   cate_desc                varchar(200)                 , 
   cate_estado              varchar(2)                   , 
   cate_runic               varchar(2)                   , 
   cate_feven               varchar(2)                   ,
   cate_sbcu	            int 					     ,
   PRIMARY KEY (cate_cate)	
); 