--
--contrain para el detalle de los movimientos contables
--
ALTER TABLE CO_TMVCO
ADD CONSTRAINT MVCO_LLAVE_CHK 
CHECK (mvco_lladetalle in ('fact','corin','notcr','mvin','fctc'))
;