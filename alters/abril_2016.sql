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

--
--Columna la cual se utilizara para indicar a que resolucion de facturacion pertenece la factura
--
ALTER TABLE fa_tfact 
ADD fact_rsfa BIGINT NOT NULL DEFAULT 1
;
--
--Columna la cual se utilizara para indicar el consecutivo de la factura dentro de la resolucion de facturacion
--
ALTER TABLE fa_tfact 
ADD fact_cons NUMERIC(1000,10) NOT NULL DEFAULT 0
;
--
--Llave con la cual garantizo la existencia de una resolucion de facturacion
--
ALTER TABLE FA_TFACT
ADD FOREIGN KEY (fact_rsfa)
REFERENCES fa_trsfa(rsfa_rsfa)
;
--
--Llave con la cual se garantiza que no se repita el mismo consecutivo en una resolucion de facturacion
--
ALTER TABLE FA_TFACT
ADD CONSTRAINT RSFA_UNIQUE 
UNIQUE (fact_rsfa,fact_cons)
;