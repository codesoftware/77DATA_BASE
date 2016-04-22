--
--Llave con la cual se garantiza que no se repita el mismo consecutivo en una resolucion de facturacion
--
ALTER TABLE FA_TFACT
ADD CONSTRAINT RSFA_UNIQUE 
UNIQUE (fact_rsfa,fact_cons)
;