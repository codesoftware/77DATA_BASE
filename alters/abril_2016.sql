--
ALTER TABLE in_tpedi DROP CONSTRAINT pedi_estado_chk;
--
ALTER TABLE in_tpedi
ADD CONSTRAINT pedi_estado_chk 
CHECK (pedi_esta in ('CR','CA','FA','GU','CO','SR','RE'));
--
--Alteracion para el desarrollo de ajuste al peso
--
ALTER TABLE fa_tfact 
ADD fact_ajpeso NUMERIC(1000,10) NOT NULL DEFAULT 0
;