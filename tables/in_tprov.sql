-- CREAMOS LA TABLA TIPOS DE MOVIMIENTOS DE INVENTARIOS
-- Tabla en la cual se almacenara los tipos de movimientos de inventarios

--DROP TABLE IF EXISTS IN_TMVIN; 

CREATE TABLE IN_TPROV(
PROV_PROV                 BIGSERIAL                                 ,
PROV_NOMBRE               VARCHAR(200)          NOT NULL            ,
PROV_NIT                  VARCHAR(200)          NOT NULL            ,
PROV_RAZON_SOCIAL         VARCHAR(200)          NOT NULL            ,
PROV_REPRESENTANTE        VARCHAR(200)          NOT NULL            ,
PROV_TELEFONO             VARCHAR(20)           NOT NULL            ,
PROV_DIRECCION            VARCHAR(800)          NOT NULL            ,
PROV_CELULAR              VARCHAR(15)           NOT NULL            ,
PROV_ESTADO               VARCHAR(2)            DEFAULT ('A')       ,
prov_corre                VARCHAR(50)                               ,
prov_retde                bigint                DEFAULT 1           ,
prov_gcron                VARCHAR(200)                              ,        
prov_ciu                  bigint                                    ,                               
prov_mpio                 bigint                                    ,
prov_rete				  NUMERIC(1000,10)							,
prov_dver				  VARCHAR(200)								,
prov_dcre				  BIGINT				DEFAULT 1			,


                               
PRIMARY KEY (PROV_PROV)
);