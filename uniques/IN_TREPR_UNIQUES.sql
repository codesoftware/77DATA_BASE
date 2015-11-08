--
--Llave con la cual se garantiza que solo va a ver un producto por cada receta no se duplicaran los productos por receta
--
ALTER TABLE IN_TREPR
ADD CONSTRAINT PRODUCTO_RECE_UNIQUE 
UNIQUE (REPR_DSKA, REPR_RECE)
;
