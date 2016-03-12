ALTER TABLE fa_thfac
ADD FOREIGN KEY (HFAC_CLIE)
REFERENCES us_tclien(clien_clien)
;

ALTER TABLE fa_thfac
ADD FOREIGN KEY (HFAC_FACT)
REFERENCES fa_tfact(fact_fact)
;

ALTER TABLE fa_thfac
ADD FOREIGN KEY (HFAC_TIUS)
REFERENCES us_ttius(tius_tius)
;