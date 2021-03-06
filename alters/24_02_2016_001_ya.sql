--
--Campo con el cual se marcara un producto con el cual se iniciara un conteo
--
alter table in_tdska add dska_inicont  varchar(2) default 'N';
--
--Check para no permitir que el campo ingresen valores no validos
--
ALTER TABLE in_tdska 
ADD CONSTRAINT IN_DSKA_INICONT_CHK 
CHECK (dska_inicont in ('S','N'))
;
--
--Adicion de columna en la tabla temporal para el codigo de barras
--
alter table in_tmprefe
add tmprefe_codbarr varchar(1000);
--