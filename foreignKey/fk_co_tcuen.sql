
ALTER TABLE co_tcuen
ADD FOREIGN KEY (cuen_grup)
REFERENCES co_tgrup(grup_grup)
;