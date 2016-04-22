ALTER TABLE em_tsede
ADD FOREIGN KEY (sede_tius)
REFERENCES us_ttius(tius_tius)
;

--
--Referencia con la tabla de resoluciones de facturacion
--
ALTER TABLE em_tsede
ADD FOREIGN KEY (sede_rsfa)
REFERENCES fa_trsfa(rsfa_rsfa)
;