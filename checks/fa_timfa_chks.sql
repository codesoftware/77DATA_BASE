ALTER TABLE FA_TIMFA
ADD CONSTRAINT IMFA_ESTADO_CHK 
CHECK (IMFA_ESTA in ('A','I'))
;

ALTER TABLE FA_TIMFA
ADD CONSTRAINT imfa_tipo_CHK 
CHECK (imfa_tipo in ('NC','ND'))
;