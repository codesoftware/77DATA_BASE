CREATE TABLE in_tpedprod(
     pedprod_pedprod        SERIAL                  ,
     pedprod_pedi           int   NOT NULL          ,
     pedprod_dska           int   NOT NULL          ,
     pedprod_precio         NUMERIC(15,6)           ,
     pedprod_canti          int   NOT NULL          ,
     pedprod_codi           VARCHAR(200) NOT NULL   ,
     pedprod_descu          NUMERIC(15,6)           ,
     pedprod_name           VARCHAR(1000)           ,
     PRIMARY KEY(pedprod_pedprod)
  ); 
   