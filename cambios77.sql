ALTER TABLE FA_TFACT  DROP CONSTRAINT FACT_ESTADO_CHK;

ALTER TABLE FA_TFACT 
ADD CONSTRAINT FACT_ESTADO_CHK 
CHECK (FACT_ESTADO in ('P','C','U','S','A','R'))
;


CREATE TABLE fa_tfanc(
fanc_fanc				BIGSERIAL NOT NULL	,
fanc_fact				BIGINT NOT NULL		,
fanc_pers_s				BIGINT				,
fanc_fech_s				TIMESTAMP			,
fanc_come_s				VARCHAR(2000)		,
fanc_pers_a				BIGINT				,
fanc_fech_a				TIMESTAMP			,
fanc_come_a				VARCHAR(2000)		,
fanc_pers_r				BIGINT				,
fanc_fech_r				TIMESTAMP			,
fanc_come_r				VARCHAR(2000)		,
fanc_pers_c				BIGINT				,
fanc_fech_c				TIMESTAMP			,
fanc_ruta_c				VARCHAR(2000)		,
fanc_esta				VARCHAR(2)			,
PRIMARY KEY(fanc_fanc)
);

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_fact)
REFERENCES fa_tfact(fact_fact)
;

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_pers_s)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_pers_a)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_pers_r)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_pers_c)
REFERENCES us_ttius(tius_tius)
;

COMMENT ON TABLE FA_TFANC       			IS 'Tabla encargada de ingresar los datos necesarios para generar a nota credito';
COMMENT ON COLUMN FA_TFANC.FANC_FANC        IS 'id unico de la tabla';
COMMENT ON COLUMN FA_TFANC.fanc_fact        IS 'llave foranea de la tabla factura';
COMMENT ON COLUMN FA_TFANC.fanc_pers_s      IS 'llave foranea del usuario que realiza la solicitud de cancelacion';
COMMENT ON COLUMN FA_TFANC.fanc_fech_s      IS 'fecha cuando se realiza la solicitud de cancelacion';
COMMENT ON COLUMN FA_TFANC.fanc_come_s      IS 'comentario cuando se realiza la solicitud de cancelacion';
COMMENT ON COLUMN FA_TFANC.fanc_pers_a      IS 'llave foranea del usuario que realiza la aceptacion de la  solicitud';
COMMENT ON COLUMN FA_TFANC.fanc_fech_a      IS 'fecha cuando se realiza la aceptacion de la solicitud';
COMMENT ON COLUMN FA_TFANC.fanc_come_a      IS 'comentario cuando se realiza la aceptacion de la solicitud';
COMMENT ON COLUMN FA_TFANC.fanc_pers_r      IS 'llave foranea del usuario que realiza la contabilizacion';
COMMENT ON COLUMN FA_TFANC.fanc_fech_r      IS 'fecha cuando se realiza la contabilizacion';
COMMENT ON COLUMN FA_TFANC.fanc_come_r      IS 'comentario cuando se realiza la contabilizacion';
COMMENT ON COLUMN FA_TFANC.fanc_pers_c      IS 'llave foranea del usuario que realiza la cancelacion';
COMMENT ON COLUMN FA_TFANC.fanc_fech_c      IS 'fecha cuando se realiza la cancelacion';
COMMENT ON COLUMN FA_TFANC.fanc_ruta_c      IS 'ruta de la nota credito';
COMMENT ON COLUMN FA_TFANC.fanc_esta        IS 'estado de la solicitud';


ALTER TABLE fa_tfanc ADD fanc_id int;

CREATE SEQUENCE fa_tfanc_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9999999999
  START 1
  CACHE 1
  CYCLE;

ALTER TABLE FA_TFANC 
ADD CONSTRAINT FANC_ESTADO_CHK 
CHECK (FANC_ESTA in ('P','C','U','S','A','R'))
;

COMMENT ON TABLE FA_TIMFA       			IS 'Tabla encargada de alamcenar los datos de las imagenes de las facturas';
COMMENT ON COLUMN FA_TIMFA.imfa_infa        IS 'id unico de la tabla';
COMMENT ON COLUMN FA_TIMFA.imfa_fact        IS 'llave foranea de la tabla factura';
COMMENT ON COLUMN FA_TIMFA.imfa_tipo      	IS 'tipo de imagen puede ser NC nota credito, ND nota debito';
COMMENT ON COLUMN FA_TIMFA.infa_ruta      	IS 'ruta de la imagen para la cual se puede visualizar';
COMMENT ON COLUMN FA_TIMFA.infa_esta      	IS 'estado del registro ';

INSERT INTO co_ttido(
            tido_tido,tido_estado, tido_nombre, tido_descripcion)
    VALUES (4,'A', 'NOTACRED','NOTA CREDITO');
    
ALTER TABLE fa_timfa
ADD FOREIGN KEY(imfa_fact)
REFERENCES fa_tfact(fact_fact)
;


ALTER TABLE FA_TIMFA
ADD CONSTRAINT IMFA_ESTADO_CHK 
CHECK (IMFA_ESTA in ('A','I'))
;

ALTER TABLE FA_TIMFA
ADD CONSTRAINT imfa_tipo_CHK 
CHECK (imfa_tipo in ('NC','ND'))
;


ALTER TABLE CO_TMVCO
ADD CONSTRAINT MVCO_LLAVE_CHK 
CHECK (mvco_lladetalle in ('fact','corin','notcr','mvin','fctc'))
;

CREATE TABLE fa_timfac (
imfac_imfac             BIGSERIAL,
imfac_fecha             TIMESTAMP NOT NULL DEFAULT NOW(),
imfac_facom             BIGSERIAL NOT NULL,
imfac_nombr				VARCHAR(200) NOT NULL,
imfac_rutai				VARCHAR(200) NOT NULL,
imfac_estad				VARCHAR(200) NOT NULL,
 PRIMARY KEY(imfac_imfac)
);

ALTER TABLE fa_timfac
ADD FOREIGN KEY (imfac_facom)
REFERENCES FA_TFACOM(FACOM_FACOM)
;

--
--Columna adicionada para referenciar ubicacion fisica del documento
--
ALTER TABLE fa_timfac
ADD imfac_ubica VARCHAR(2000);

