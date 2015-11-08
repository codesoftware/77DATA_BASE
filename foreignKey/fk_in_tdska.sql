--
--Referencia a la tabla de categorias
--
ALTER TABLE IN_TDSKA
ADD FOREIGN KEY (DSKA_CATE)
REFERENCES IN_TCATE(cate_cate)
;
--
--Referencia a la tabla de subcuentas
--
ALTER TABLE in_tdska
ADD FOREIGN KEY (dska_sbcu)
REFERENCES co_tsbcu(sbcu_sbcu)
;
--
--Referencia a la tabla de referencias
--
ALTER TABLE in_tdska
ADD FOREIGN KEY (dska_refe)
REFERENCES in_trefe(refe_refe)
;
--
--Referencia a la tabla de marcas
--
ALTER TABLE in_tdska
ADD FOREIGN KEY (dska_marca)
REFERENCES in_tmarca(marca_marca)
;
--
--Referencia a la tabla de proveedores
--
alter table in_tdska 
add  foreign key (dska_prov)
references in_tprov (prov_prov);