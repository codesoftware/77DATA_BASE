--
insert into em_tpara(para_clave, para_valor)
values('NIT', '123456789')
;
--
insert into em_tpara(para_clave, para_valor)
values('NOMBREEMPRESA', 'HOTEL SHAOLOM')
;
--
insert into em_tpara(para_clave, para_valor)
values('DIRECCION', 'Cra 73 a calle 53')
;
--
insert into em_tpara(para_clave, para_valor)
values('TELEFONOS', '2335566-7788995')
;
--
insert into em_tpara(para_clave, para_valor)
values('CIUDAD', 'BOGOTA D.C.')
;
--
insert into em_tpara(para_clave, para_valor)
values('IVAPRVENTA', '16')
;

insert into em_tpara(para_clave, para_valor)
values('FACTURA', '0')
;
insert into em_tpara(para_clave, para_valor)
values('CORREOENVIO', ' ')
; 
insert into em_tpara(para_clave, para_valor)
values('CLAVECORRENV', ' ')
;
insert into em_tpara(para_clave, para_valor)
values('PUERTOENV', ' ')
;
insert into em_tpara(para_clave, para_valor)
values('SERVSMTP', ' ')
;

--
--campo parametrizable para el ajuste al peso
--
INSERT INTO EM_TPARA VALUES(22,NOW(),'VALORAJUSTEPESO','1100');
