ALTER TABLE fa_tdtpr 
ADD CONSTRAINT dtpr_con_desc_chk 
CHECK (dtpr_con_desc in ('S','N'))
;

ALTER TABLE fa_tdtpr 
ADD CONSTRAINT dtpr_estado_chk
CHECK (dtpr_estado in ('A','C'))
;