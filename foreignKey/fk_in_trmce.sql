ALTER TABLE in_trmce
ADD FOREIGN KEY (rmce_tius_ent)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE in_trmce
ADD FOREIGN KEY (rmce_tius_ent)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE in_trmce
ADD FOREIGN KEY (rmce_sede)
REFERENCES em_tsede(sede_sede)
;


ALTER TABLE in_trmce
ADD FOREIGN KEY (rmce_sede)
REFERENCES em_tsede(sede_sede)
;