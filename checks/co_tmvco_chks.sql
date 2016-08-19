--
--contrain para el detalle de los movimientos contables
--
--alter table CO_TMVCO drop constraint MVCO_LLAVE_CHK;
--
ALTER TABLE CO_TMVCO
ADD CONSTRAINT MVCO_LLAVE_CHK 
CHECK (mvco_lladetalle in ('fact','corin','notcr','mvin','fctc','pgrm','impo','gaim','apor'))
;