--
--alter del tamaño del campo direccion
--
ALTER TABLE IN_TPROV 
ALTER COLUMN prov_direccion TYPE VARCHAR(800);
--
--
--
alter table in_tprov
add prov_ciu VARCHAR(200);
--
--
--
alter table in_tprov
add prov_mpio VARCHAR(200);
--
--
--digito de verificacion
alter table in_tprov
add prov_dver VARCHAR(200);
---
--dias credito
alter table in_tprov
add prov_dcre BIGINT;
