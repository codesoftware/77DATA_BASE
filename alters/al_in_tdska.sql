--
-- Borrar la columna de marcas en la tabla de productos
--
ALTER TABLE in_tdska 
DROP COLUMN dska_marca;
--
--Adicionar el campo marca de la tabla de productos
--
ALTER TABLE in_tdska 
ADD COLUMN dska_marca INT;
--
--Adicion de llave foranea de productos y marcas
--
ALTER TABLE in_tdska
ADD FOREIGN KEY (dska_marca)
REFERENCES in_tmarca(marca_marca)
;

