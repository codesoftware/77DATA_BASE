--
--
--
ALTER TABLE em_tapor
ADD FOREIGN KEY (apor_tius)
REFERENCES us_ttius(tius_tius)
;
--
--
--
ALTER TABLE em_tapor
ADD FOREIGN KEY (apor_sede)
REFERENCES em_tsede(sede_sede)
;