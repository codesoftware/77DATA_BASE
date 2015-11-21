CREATE TABLE in_tpedprod(
     pedprod_pedprod        SERIAL                  ,
     pedprod_pedi           int   NOT NULL          ,
     pedprod_dska           int   NOT NULL          ,
     pedprod_precio         NUMERIC(15,6)           ,
     PRIMARY KEY(pedprod_pedprod)
  ); 
   
