--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT )
values('Devolución del Cliente', 'I','C','N','N','N')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT)
values('Inventario inicial', 'I', 'N','N','S','N')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT,MVIN_COMPRA)
values('Compra', 'I', 'P','N','N','N','S')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT)
values('Venta', 'E', 'C','S','N','N')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT,MVIN_PERDIDA)
values('Perdida', 'E','N','N','N','N','S')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL, MVIN_REVFACT)
values('Cancelacion de Factura','I','C','N','N','S')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT,MVIN_CAMBSEDE_EGR)
values('Cambio de Sede Egreso','E','N','N','N','N','S')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT, MVIN_CAMBSEDE_ING)
values('Cambio de Sede Ingreso','I','N','N','N','N','S')
;
--
insert into IN_TMVIN (MVIN_DESCR, MVIN_NATU, MVIN_USIM, MVIN_VENTA, MVIN_INICIAL,MVIN_REVFACT, MVIN_CORRIGE_ING)
values('Correccion de ingreso de Productos','E','N','N','N','N','S')
;
