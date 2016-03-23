ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_fact)
REFERENCES fa_tfact(fact_fact)
;

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_pers_s)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_pers_a)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_pers_r)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE fa_tfanc
ADD FOREIGN KEY(fanc_pers_c)
REFERENCES us_ttius(tius_tius)
;