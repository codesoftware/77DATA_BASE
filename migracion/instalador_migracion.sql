--
--Instalador de migracion
--
--Antes de correr el instalador se deben crear las siguientes subcuentas:
--1. Cuentas por cobrar a terceros 138020
--2. Aportes 31050101 Aportes socio dependiendo del contador
--
\i /77DATA_BASE/migracion/tablas_migracion.sql;

\i /77DATA_BASE/migracion/FN_MIGRACION_DATOS.sql;
--
alter table co_tmvco drop constraint MVCO_LLAVE_CHK;
--
\i  /77DATA_BASE/checks/co_tmvco_chks.sql
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT, MVIN_CORRIGE_ING,MVIN_CODIGO)
values('Ingreso Aportes','I','N','N','N','N','N','INAP')
;
--
INSERT INTO co_ttido(
            tido_tido,tido_estado, tido_nombre, tido_descripcion)
    VALUES (6,'A', 'APORTE','APORTE DE SOCIO');
--
DROP FUNCTION IF EXISTS CO_BUSCA_AUXILIAR_X_TIDO(BIGINT,VARCHAR);
--
\i /77DATA_BASE/functions/CO_BUSCA_AUXILIAR_X_TIDO.sql;
--
\i /77DATA_BASE/functions/IN_INSERTA_PROD_APORTE.sql;
--
DROP TRIGGER f_ins_kapr ON in_tkapr;
--
\i /77DATA_BASE/triggers/in_tkapr_before_insert_or_update.sql;
--
drop table in_tprap;
--
drop table em_tapor;
--
\i /77DATA_BASE/tables/em_tapor.sql;
--
\i /77DATA_BASE/tables/in_tprap.sql;
--
\i /77DATA_BASE/triggers/in_tkapr_before_insert_or_update.sql;
--
\i /77DATA_BASE/functions/IN_GENERA_PROCESO_APORTE.sql;
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (189, 3, 19, 'A',  'APORTE SOCIO', 
            '01', 'APORTE SOCIO', 'D');
--
INSERT INTO co_tauco ( auco_sbcu, auco_nomb, auco_codi, auco_descr) 
VALUES (32, 'APORTE SOCIO', '1', 'APORTE SOCIO');
--