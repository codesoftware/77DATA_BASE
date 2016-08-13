--
--Llave con la cual relaciono la tabla de los municipios
--
ALTER TABLE AD_TSOCI
ADD FOREIGN KEY (SOCI_MPIO)
REFERENCES ub_tdepa(DEPA_DEPA)
;
--
--Llave con la cual relaciono la tabla de las ciudades
--
ALTER TABLE AD_TSOCI
ADD FOREIGN KEY (SOCI_CIUD)
REFERENCES ub_tciud(CIUD_CIUD)
;
--
--Llave con la cual relaciono la tabla de las ciudades
--
ALTER TABLE AD_TSOCI
ADD FOREIGN KEY (SOCI_USUA)
REFERENCES US_TTIUS(TIUS_TIUS)
;


