--
-- CREAMOS LA TABLA PARAMETROS DE PRECIOS POR SEDE
-- Tabla en la cual se parametrizan los porcentajes de precios por medio de su categoria, subcategoria y marca 
-- pops(parametrizacion de porcentajes de precios por sede)
--

CREATE TABLE in_tpops(
   pops_pops                BIGSERIAL                           ,  
   pops_fecha               TIMESTAMP        DEFAULT NOW()      , 
   pops_sede                BIGINT                              , 
   pops_cate                BIGINT                              , 
   pops_refe                BIGINT                              , 
   pops_marca               BIGINT                              ,
   pops_tius                BIGINT                              ,
   pops_estado              varchar(2)                      DEFAULT   'A'      ,
   pops_porc_base           numeric(1000,10)    not null    DEFAULT    60      ,
   pops_porc_uni            numeric(1000,10)    not null    DEFAULT    50      ,
   pops_porc_cent           numeric(1000,10)    not null    DEFAULT    40      ,
   pops_porc_mill           numeric(1000,10)    not null    DEFAULT    30      ,
   PRIMARY KEY (pops_pops)
); 