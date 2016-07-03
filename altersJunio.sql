--
--alter del tamaño del campo direccion
--
ALTER TABLE IN_TPROV 
ALTER COLUMN prov_direccion TYPE VARCHAR(800);
--
--
ALTER TABLE IN_TPROV 
add prov_rete NUMERIC(1000,6);
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
--
--porcentaje retencion
ALTER TABLE fa_tfacom_tmp ADD facom_tmp_porc NUMERIC(1000,6);
--
--valor suma productos
ALTER TABLE fa_tfacom_tmp ADD facom_tmp_vlpr NUMERIC(1000,10);


