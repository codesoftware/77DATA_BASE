ALTER TABLE IN_TMVIN ADD CONSTRAINT MVIN_NATU CHECK (MVIN_NATU in ('I','E'));

ALTER TABLE IN_TMVIN ADD CONSTRAINT MVIN_USIM_CHK CHECK (MVIN_USIM in ('P','C','N'));

ALTER TABLE IN_TMVIN ADD CONSTRAINT MVIN_VENTA_CHK CHECK (MVIN_VENTA in ('S','N'));