--
-- Check que garantiza que debe ser debito o credito la columna
--
ALTER TABLE co_tsbft 
ADD CONSTRAINT co_sbft_naturaleza_chk 
CHECK (sbft_naturaleza in ('D','C'));