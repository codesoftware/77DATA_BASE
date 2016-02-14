--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT,MVIN_CODIGO )
values('Devolución del Cliente', 'I','C','N','N','N','DVCL')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT,MVIN_CODIGO)
values('Inventario inicial', 'I', 'N','N','S','N','ININ')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT,MVIN_COMPRA,MVIN_CODIGO)
values('Compra', 'I', 'P','N','N','N','S','COMP')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT,MVIN_CODIGO)
values('Venta', 'E', 'C','S','N','N','VENT')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT,MVIN_PERDIDA,MVIN_CODIGO)
values('Perdida', 'E','N','N','N','N','S','PERD')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT,MVIN_CODIGO)
values('Cancelacion de Factura','I','C','N','N','S','CAFA')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT,MVIN_CAMBSEDE_EGR,MVIN_CODIGO)
values('Cambio de Sede Egreso','E','N','N','N','N','S','CASE')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT, MVIN_CAMBSEDE_ING,MVIN_CODIGO)
values('Cambio de Sede Ingreso','I','N','N','N','N','S', 'CAIN')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT, MVIN_CORRIGE_ING,MVIN_CODIGO)
values('Correccion de ingreso de Productos','E','N','N','N','N','S','COIP')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT, MVIN_CORRIGE_ING,MVIN_CODIGO)
values('Ajuste de inventario automatico Egreso','E','N','N','N','N','N', 'AAIE')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT, MVIN_CORRIGE_ING,MVIN_CODIGO)
values('Ajuste de inventario automatico Ingreso','I','N','N','N','N','N','AAII')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT, MVIN_CORRIGE_ING,MVIN_CODIGO)
values('Ingrso por factura de compra','I','N','N','N','N','N','INFC')
;