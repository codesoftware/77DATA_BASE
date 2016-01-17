--
--Referencia con la tabla tipo documento
--
ALTER TABLE in_tpops
ADD FOREIGN KEY (pops_cate)
REFERENCES in_tcate(cate_cate)
;
--
--Referencia con la tabla tipo documento
--
ALTER TABLE in_tpops
ADD FOREIGN KEY (pops_refe)
REFERENCES in_trefe(refe_refe)
;
--
--Referencia con la tabla tipo documento
--
ALTER TABLE in_tpops
ADD FOREIGN KEY (pops_marca)
REFERENCES in_tmarca(marca_marca)
;