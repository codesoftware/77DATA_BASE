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

CREATE SEQUENCE sq_co_ttem_fact_rece;
ALTER TABLE co_ttem_fact_rece ALTER COLUMN TEM_FACT_RECE SET NOT NULL;
ALTER TABLE co_ttem_fact_rece ALTER COLUMN TEM_FACT_RECE SET DEFAULT nextval('sq_co_ttem_fact_rece');
ALTER SEQUENCE sq_co_ttem_fact_rece OWNED BY co_ttem_fact_rece.TEM_FACT_RECE;