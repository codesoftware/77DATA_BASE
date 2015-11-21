ALTER TABLE in_tpedi
ADD FOREIGN KEY (pedi_sede)
REFERENCES em_tsede(sede_sede)
;
ALTER TABLE in_tpedi
ADD FOREIGN KEY (pedi_usu)
REFERENCES us_ttius(tius_tius)
;
ALTER TABLE in_tpedi
ADD FOREIGN KEY (pedi_clie)
REFERENCES us_tclien(clien_clien)
;
