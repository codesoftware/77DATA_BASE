ALTER TABLE fa_tdtpr
ADD FOREIGN KEY (dtpr_fact)
REFERENCES fa_tfact(fact_fact)
;

ALTER TABLE fa_tdtpr
ADD FOREIGN KEY (dtpr_dska)
REFERENCES in_tdska(dska_dska)
;

ALTER TABLE fa_tdtpr
ADD FOREIGN KEY (dtpr_kapr)
REFERENCES in_tkapr(kapr_kapr)
;