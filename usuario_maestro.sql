--
--Insert para el perfil
--
INSERT INTO us_tperf(
            perf_nomb, perf_desc, perf_permisos, perf_estado)
    VALUES ('Admin', 'Administrador de la aplicacion', '.AdUs1..AdUs2..AdUs3..AdUs4..AdUs5..AdEm1..AdEm2..AdPf1..AdPf2..AdPf3..AdPf4..AdSe1..AdSe2..AdSe3..AdSe4..InPr1..InPr2..InPr3..InPr4..InPr5..InPr6..InPr7..InPr8..InCat1..InCat2..InCat3..InSr1..InSr2..InSr3..InSr4..InSr5..InMi1..InMi2..InMi3..FcCr1..FcCr2..FcCr3..FcCr4..RpIn1..InRef1..InRef2..InRef3..CoPu1..CoPu2..InPr9..InPr10..InPr11..InPr12..FcCr5..FcCr6..cieDi1..reGen1..RpUs1..InMarca1.InMarca3..InProved1..InProved3..InArqueo1..InArqueo3..InRec1..InRec2..InRec3..InRec4.', 'A')
    ;
--
--Sede bodega
-- 
insert into em_tsede (sede_nombre,sede_direccion, sede_telefono)
    values ('BODEGA', 'Cra 14 No. 112' , '778899');
--
--Usuario administrador
--
select US_FINSERTA_USUA('aministrador','sistema','1234','administrdor',to_date('14/01/1991','dd/mm/yyyy'),'admin','admin',1,1);
--
--Categoria inicial del sistema
--
INSERT INTO in_tcate(
            cate_desc, cate_estado, cate_runic, cate_feven)
    VALUES ('GENERICA', 'A', 'S', 'S');