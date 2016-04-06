--
ALTER TABLE in_tpedi DROP CONSTRAINT pedi_estado_chk;
--
ALTER TABLE in_tpedi
ADD CONSTRAINT pedi_estado_chk 
CHECK (pedi_esta in ('CR','CA','FA','GU','CO','SR'));
--