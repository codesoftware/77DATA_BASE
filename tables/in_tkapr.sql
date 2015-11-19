-- CREAMOS LA TABLA KARDEX PRODUCTO
-- Tabla en la cual se almacenara los datos del kardex por cada producto, "KARDEX CON METODO PONDERADO"

--DROP TABLE IF EXISTS IN_TKAPR; 

CREATE TABLE IN_TKAPR(
KAPR_KAPR                SERIAL           NOT NULL                 ,
KAPR_CONS_PRO            INT              NOT NULL                 ,
KAPR_DSKA                INT              NOT NULL                 ,
KAPR_FECHA               TIMESTAMP        NOT NULL   DEFAULT NOW() ,
KAPR_MVIN                INT              NOT NULL                 ,
KAPR_CANT_MVTO           INT              NOT NULL                 ,
KAPR_COST_MVTO_UNI       NUMERIC(50,6)    NOT NULL                 ,
KAPR_COST_MVTO_TOT       NUMERIC(50,6)    NOT NULL                 ,
KAPR_COST_SALDO_UNI      NUMERIC(50,6)    NOT NULL                 ,
KAPR_COST_SALDO_TOT      NUMERIC(50,6)    NOT NULL                 ,
KAPR_CANT_SALDO          INT              NOT NULL                 ,
KAPR_PROV                INT                                       ,
KAPR_TIUS                INT              NOT NULL                 ,
KAPR_SEDE                INT              NOT NULL                 ,
PRIMARY KEY (KAPR_KAPR)
);