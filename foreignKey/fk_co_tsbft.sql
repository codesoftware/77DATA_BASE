--
--Referencia con la tabla tipo documento
--
ALTER TABLE co_tsbft
ADD FOREIGN KEY (sbft_tido)
REFERENCES co_ttido(tido_tido)
;