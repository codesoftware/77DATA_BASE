-- CREAMOS LA TABLA KARDEX PRODUCTO
-- Tabla en la cual se almacenara los datos del kardex por cada producto, "KARDEX CON METODO PONDERADO"

--DROP TABLE IF EXISTS IN_TKAPR; 

CREATE TABLE IN_TKAPR(
KAPR_KAPR                BIGSERIAL              NOT NULL                 ,
KAPR_CONS_PRO            BIGINT                 NOT NULL                 ,
KAPR_DSKA                BIGINT                 NOT NULL                 ,
KAPR_FECHA               TIMESTAMP              NOT NULL   DEFAULT NOW() ,
KAPR_MVIN                BIGINT                 NOT NULL                 ,
KAPR_CANT_MVTO           BIGINT                 NOT NULL                 ,
KAPR_COST_MVTO_UNI       NUMERIC(1000,6)        NOT NULL                 ,
KAPR_COST_MVTO_TOT       NUMERIC(1000,6)        NOT NULL                 ,
KAPR_COST_SALDO_UNI      NUMERIC(1000,6)        NOT NULL                 ,
KAPR_COST_SALDO_TOT      NUMERIC(1000,6)        NOT NULL                 ,
KAPR_CANT_SALDO          BIGINT                 NOT NULL                 ,
KAPR_PROV                BIGINT                                       ,
KAPR_TIUS                BIGINT                 NOT NULL                 ,
KAPR_SEDE                BIGINT                 NOT NULL                 ,
PRIMARY KEY (KAPR_KAPR)
);