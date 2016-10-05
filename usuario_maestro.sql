--
--Insert para el perfil
--
INSERT INTO us_tperf(
            perf_nomb, perf_desc, perf_permisos, perf_estado)
    VALUES ('Admin', 'Administrador de la aplicacion', '.Adm8.', 'A')
    ;

--insert de pruebas para retefuente

	INSERT INTO co_tveret(
            veret_veret, veret_nombr, veret_comen, veret_finic, veret_ffina, 
            veret_estad, veret_fecha)
    VALUES (1, 'VERSION 2016', 'VERSION 2016', NOW(), to_date('31/12/2016','DD/MM/yyyy'), 
            'V', now());


INSERT INTO co_tretde(
            retde_retde, retde_veret, retde_codig, retde_conce, retde_bauvt, 
            retde_bpeso, retde_tarif, retde_estad, retde_fecha)
    VALUES (1, 1, 'Reco', 'Compras generales (declarantes)', 27, 
            803000.000000, 2.50, 'V', NOW());

INSERT INTO co_tretde(
            retde_retde, retde_veret, retde_codig, retde_conce, retde_bauvt, 
            retde_bpeso, retde_tarif, retde_estad, retde_fecha)
    VALUES (2, 1, 'Reco', 'Compras generales (no declarantes)', 27, 
            803000.000000, 3.50, 'V', NOW());
--
--Insercion de resolucion de facturacion
--
INSERT INTO fa_trsfa(
            rsfa_prefij, rsfa_fechainic, rsfa_consec, rsfa_inicon, 
            rsfa_estado, rsfa_comentario)
    VALUES ('PO', to_date('01/01/2016','dd/mm/yyyy'), 1, 1, 
            'A', 'Resolucion de facturacion por default');

--
--Sede bodega
-- 
insert into em_tsede (sede_nombre,sede_direccion, sede_telefono,sede_rsfa)
    values ('BODEGA', 'Cra 14 No. 112' , '778899',1);
--
insert into em_tsede (sede_nombre,sede_direccion, sede_telefono,sede_rsfa)
    values ('VENTA MOSTRADOR', 'Cra 24 No. 112' , '778899',1);
--
--Usuario administrador
--
select US_FINSERTA_USUA('administrador','sistema','1234','administrdor',to_date('14/01/1991','dd/mm/yyyy'),'admin','admin',1,1);
--
--Categoria inicial del sistema
--
INSERT INTO in_tcate(
            cate_desc, cate_estado, cate_runic, cate_feven)
    VALUES ('GENERICA', 'A', 'S', 'S');
--
--Insercion de un proveedor generico
--
INSERT INTO in_tprov(
            prov_nombre, prov_nit, prov_razon_social, prov_representante, 
            prov_telefono, prov_direccion, prov_celular, prov_estado,prov_retde)
    VALUES ( 'Generico', '123456789', 'Generico', 'Generico', 
            '2334455', 'cra 55 calle 76', '3115566778', 'A',1);
--
--Insercion de subcuentas 
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (1, 1, 1, 'A', 'CAJA MENOR', 
            '01', 'CAJA MENOR', 'D');
--
--Insercion de subcuentas 
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (136, 2, 13, 'A', 'IVA DESCONTABLE', 
            '01', 'IVA DESCONTABLE', 'D');
--
--Insercion de subcuentas 
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (136, 2, 13, 'A', 'IVA GENERADO', 
            '02', 'IVA GENERADO', 'D');
--
--Insercion de subcuentas 
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (278, 5, 32, 'A', 'DESCUENTOS', 
            '35', 'DESCUENTOS', 'D');
--
--Insercion de subcuentas 
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (290, 6, 35, 'A',  'COMERCIO AL POR MAYOR Y AL POR MENOR', 
            '35',  'COMERCIO AL POR MAYOR Y AL POR MENOR', 'D');
--
--Insercion de subcuentas 
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (221, 4, 27, 'A',  'MERCNCIAS AL POR MAYOR Y AL POR MENOR', 
            '35',  'MERCNCIAS AL POR MAYOR Y AL POR MENOR', 'C');
--
--Insercion de subcuentas de retencion en la fuente
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (131, 2, 12, 'A',  'RETENCION EN LA FUENTE', 
            '01', 'RETENCION EN LA FUENTE', 'C');
--
--Insercion de subcuentas 
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (245, 4, 28, 'A',  'AJUSTE AL PESO', 
            '81', 'AJUSTE AL PESO', 'C');
--
--Insercion de subcuentas 
--
INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (36, 1, 3, 'A',  'CUENTAS POR COBRAR DE TERCEROS', 
            '81', 'CUENTAS POR COBRAR DE TERCEROS', 'D');

    INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (32, 1, 3, 'A',  'RETENCION EN LA FUENTE', 
            '15', 'RETENCION EN LA FUENTE', 'D');
--
    INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (36, 1, 3, 'A',  'CUENTAS POR COBRAR', 
            '15', 'CUENTAS POR COBRAR', 'D');
--
--
    INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (329, 7, 53, 'A',  'CUENTA PUENTE IMPORTACION', 
            '05', 'CUENTA PUENTE IMPORTACION', 'D');
--
    INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (115, 2, 11, 'A',  'CUENTA PROVEEDORES', 
            '01', 'CUENTA PROVEEDORES', 'D');
    --
    INSERT INTO co_tsbcu (
        sbcu_cuen,sbcu_clas,sbcu_grup,sbcu_estado,sbcu_nombre,sbcu_codigo,sbcu_descripcion,sbcu_naturaleza)
    values(125,2,12,'A','CUENTAS POR PAGAR','01','CUENTAS POR PAGAR','C');
    --
    INSERT INTO co_tsbcu(
            sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
            sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
    VALUES (189, 3, 19, 'A',  'APORTE SOCIO', 
            '01', 'APORTE SOCIO', 'D');
    --
--PARAMETRIZACIONES DE IVA DE VENTA Y COMPRA DE PRODUCTOS
--
INSERT INTO em_tpara(para_clave, para_valor)
VALUES('IVAPR','16');
--
INSERT INTO em_tpara(para_clave, para_valor)
VALUES('IVAPRVENTA','16');
--
--Parametrizacion de la resolucion de facturacion por defecto
--
insert into fa_trsfa(rsfa_prefij,rsfa_fechaInic,rsfa_consec,rsfa_inicon,rsfa_estado,rsfa_comentario) 
values(' ','01/01/2016',0,0,'A','Prueba de resolucion de facturacion')