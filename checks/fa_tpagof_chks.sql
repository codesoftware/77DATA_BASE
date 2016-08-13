ALTER TABLE fa_tpagof 
ADD CONSTRAINT pagof_estad_chk 
CHECK (pagof_estad in ('P','Rs'));
