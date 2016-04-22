ALTER TABLE FA_TFACT
ADD FOREIGN KEY (FACT_CLIEN)
REFERENCES us_tclien(clien_clien)
;

ALTER TABLE FA_TFACT
ADD FOREIGN KEY (FACT_TIUS)
REFERENCES US_TTIUS(TIUS_TIUS)
;
--
--Referencia con la tabla de cierres
--
ALTER TABLE FA_TFACT
ADD FOREIGN KEY (FACT_CIERRE)
REFERENCES AD_TCIER(CIER_CIER)
;
--
--Referencia con la tabla de SEDES
--
ALTER TABLE FA_TFACT
ADD FOREIGN KEY (FACT_SEDE)
REFERENCES EM_TSEDE(SEDE_SEDE)
;
--
--Llave con la cual garantizo la existencia de una resolucion de facturacion
--
ALTER TABLE FA_TFACT
ADD FOREIGN KEY (fact_rsfa)
REFERENCES fa_trsfa(rsfa_rsfa)
;

