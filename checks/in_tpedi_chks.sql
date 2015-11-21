ALTER TABLE in_tpedi
ADD CONSTRAINT pedi_estado_chk 
CHECK (pedi_estado in ('CR','CA','FA'));
