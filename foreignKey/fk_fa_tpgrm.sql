--
--Llave relacional entre los pagos y una factura
--
ALTER TABLE fa_tpgrm
ADD FOREIGN KEY (pgrm_fact)
REFERENCES fa_tfact(fact_fact)
;
--
--Llave relacional entre los pagos y la remision
--
ALTER TABLE fa_tpgrm
ADD FOREIGN KEY (pgrm_remi)
REFERENCES in_tremiremi_remi)
;