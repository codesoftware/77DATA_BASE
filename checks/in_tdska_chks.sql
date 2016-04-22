ALTER TABLE IN_TDSKA 
ADD CONSTRAINT DSKA_IVA_CHK CHECK (DSKA_IVA in ('S','N'))
;

ALTER TABLE IN_TDSKA 
ADD CONSTRAINT DSKA_ESTADO_CHK CHECK (DSKA_ESTADO in ('A','I'))
;
--
--Check para no permitir que el campo ingresen valores no validos
--
ALTER TABLE in_tdska 
ADD CONSTRAINT IN_DSKA_INICONT_CHK 
CHECK (dska_inicont in ('S','N'))
;