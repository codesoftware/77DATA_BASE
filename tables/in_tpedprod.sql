CREATE TABLE in_tpedprod(
     pedprod_pedprod        SERIAL                            ,
     pedprod_pedi           BIGINT          NOT NULL          ,
     pedprod_dska           BIGINT          NOT NULL          ,
     pedprod_precio         NUMERIC(1000,10)                  ,
     pedprod_canti          BIGINT          NOT NULL          ,
     pedprod_codi           VARCHAR(200)    NOT NULL          ,
     pedprod_descu          NUMERIC(15,6)                     ,
     pedprod_name           VARCHAR(1000)                     ,
     pedprod_cod_ext        VARCHAR(1000)                     ,
     PRIMARY KEY(pedprod_pedprod)
  ); 
   
