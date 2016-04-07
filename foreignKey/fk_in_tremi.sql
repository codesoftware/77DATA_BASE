--
--Referencia con la tabla Clientes
--
ALTER TABLE in_tremi
ADD FOREIGN KEY (remi_clien)
REFERENCES us_tclien(clien_clien)
;
--
--Referencia con la tabla pedidos
--
ALTER TABLE in_tremi
ADD FOREIGN KEY (remi_pedi)
REFERENCES in_tpedi(pedi_pedi)
;
--
--Referencia con la tabla Clientes
--
ALTER TABLE in_tremi
ADD FOREIGN KEY (remi_fact)
REFERENCES fa_tfact(fact_fact)
;
--
--Referencia con la tabla pedidos
--
ALTER TABLE in_tremi
ADD FOREIGN KEY (remi_tius)
REFERENCES us_ttius(tius_tius)
;