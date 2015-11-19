--
--Referencia con la tabla de detalle de recetas de facturacion fa_tdtre
--
ALTER TABLE FA_TRRKA
ADD FOREIGN KEY (RRKA_DTRE)
REFERENCES FA_TDTRE(DTRE_DTRE)
;
--
--Referencia con la tabla de recetas in_trece
--
ALTER TABLE FA_TRRKA
ADD FOREIGN KEY (RRKA_RECE)
REFERENCES IN_TRECE(RECE_RECE)
;
--
--Referencia con la tabla de productos in_tdska
--
ALTER TABLE FA_TRRKA
ADD FOREIGN KEY (RRKA_DSKA)
REFERENCES IN_TDSKA(DSKA_DSKA)
;
--
--Referencia con la tabla de kardex in_tkapr
--
ALTER TABLE FA_TRRKA
ADD FOREIGN KEY (RRKA_KAPR)
REFERENCES IN_TKAPR(KAPR_KAPR)
;

