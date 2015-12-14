-- CREAMOS LA TABLA CATEGORIAS
-- Tabla en la cual se almacena la informacion de las categorias de los productos.
-- 

--DROP TABLE IF EXISTS in_tcate;

CREATE TABLE in_tcate(
   cate_cate                BIGSERIAL                       ,  
   cate_desc                varchar(500)                    , 
   cate_estado              varchar(2)                      , 
   cate_runic               varchar(2)                      , 
   cate_feven               varchar(2)                      ,
   cate_sbcu                int                             ,
   cate_porcentaje          numeric(1000,10)   default  45  ,
   PRIMARY KEY (cate_cate)
); 