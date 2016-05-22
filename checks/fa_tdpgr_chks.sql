ALTER TABLE fa_tdpgr
ADD CONSTRAINT dpgr_estado_chk 
CHECK (dpgr_estado in ('P','X'))
;

ALTER TABLE fa_tdpgr 
ADD CONSTRAINT dpgr_tipopago_chk
CHECK (dpgr_tipopago in ('E','C'))
;