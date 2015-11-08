--
--Llsve foranea que garantiza que simpre exista la subucenta relacionada a la subcuenta
--
ALTER TABLE CO_TSIMC
ADD FOREIGN KEY (SIMC_SBCU)
REFERENCES CO_TSBCU(SBCU_SBCU)
;