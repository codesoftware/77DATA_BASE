ALTER TABLE in_tpedprod
ADD FOREIGN KEY (pedprod_pedi)
REFERENCES in_tpedi(pedi_pedi)
;
ALTER TABLE in_tpedprod
ADD FOREIGN KEY (pedprod_dska)
REFERENCES in_tdska(dska_dska)
;

