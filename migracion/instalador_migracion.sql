--
--Instalador de migracion
--
--Antes de correr el instalador se deben crear las siguientes subcuentas:
--1. Cuentas por cobrar a terceros 138020
--2. Aportes 31050101 Aportes socio dependiendo del contador
--
alter table co_tmvco drop constraint MVCO_LLAVE_CHK;
--
\i  C:/77DATA_BASE/checks/co_tmvco_chks.sql
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