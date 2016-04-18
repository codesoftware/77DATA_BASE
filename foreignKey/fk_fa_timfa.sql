ALTER TABLE fa_timfa
ADD FOREIGN KEY(imfa_fact)
REFERENCES fa_tfact(fact_fact)
;
