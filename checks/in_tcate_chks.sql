ALTER TABLE in_tcate 
ADD CONSTRAINT cate_estado_chk 
CHECK (cate_estado in ('A','I'));