--
--UNIQUE QUE GARANTIZA QUE NO HALLA REFERENCIA A UNA FACTURA
--
ALTER TABLE fa_tpgrm
ADD CONSTRAINT PGRM_FACT_UNIQUE UNIQUE (pgrm_fact)
;
--
--UNIQUE QUE GARANTIZA QUE NO HALLA REFERENCIA A UNA FACTURA
--
ALTER TABLE fa_tpgrm
ADD CONSTRAINT PGRM_REMI_UNIQUE UNIQUE (PGRM_REMI)
;