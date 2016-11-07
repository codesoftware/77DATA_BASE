--
--tabla temporal de facturas
--
CREATE TABLE FA_TFACMIG(
  factMIG_factMIG bigserial not null,	
  factMIG_fact 	bigint NOT NULL, -- Identificador primario de la tabla
  factMIG_tius bigint NOT NULL, -- Identifica el usuario del sistema que creo la factura
  factMIG_fec_ini date NOT NULL, -- Fecha en la cual se creo la factura.
  factMIG_fec_cierre date, -- Fecha en la cual se cerro la facturasactura
  factMIG_clien bigint NOT NULL, -- Cleinte del cual es la factura
  factMIG_clien_cedula varchar(500) not null,
  factMIG_vlr_total numeric(1000,10) NOT NULL, -- Valor total de la factura
  factMIG_vlr_iva numeric(1000,10) NOT NULL, -- Iva el cual cobra toda la factura
  factMIG_tipo_pago character varying(1) NOT NULL DEFAULT 'E'::character varying, -- Tipo de pago Efectivo (E), Tarjeta (T) y Mixto (M) mixto indica que pago una parte en tarjeta y otra parte en efectivo
  factMIG_id_voucher character varying(200) NOT NULL DEFAULT 'N/A'::character varying,
  factMIG_cometarios character varying(1), -- Comentarios de la factura
  factMIG_estado character varying(1) NOT NULL DEFAULT 'P'::character varying, -- Estado en el cual se encuentra la factura Pendiente(P), Cancelada (C) y en uso (U)
  factMIG_naturaleza character varying(2) NOT NULL DEFAULT 'E'::character varying, -- Naturaleza de la factura (E) Egreso e Ingreso(I) ingreso es una cancelacion de la factura
  factMIG_devolucion character varying(1) NOT NULL DEFAULT 'N'::character varying, -- Indica si la factura es una devoluciÃ³n (S) si, (N) No
  factMIG_original bigint NOT NULL DEFAULT 0, -- Si es una cancelacion de otra factura indica cual es la que esta cancelando
  factMIG_vlr_dcto numeric(1000,10) NOT NULL DEFAULT 0, -- Indica cual fue el descuento total que se le realizo a la factura
  factMIG_vlr_efectivo numeric(1000,10) NOT NULL DEFAULT 0, -- Indica el valor que pago el cliente en efectivo
  factMIG_vlr_tarjeta numeric(1000,10) NOT NULL DEFAULT 0, -- Indica el valor que pago el cliente en tarjeta
  factMIG_cierre bigint, -- Referencia el id del cierre en el cual fue realizado la factura
  factMIG_sede bigint NOT NULL, -- Referencia el id de la sede en la cual fue realizada la factura
  factMIG_pedi bigint DEFAULT 0, -- Referencia el id de la tabla de pedidos en el caso en el que el campo sea cero quiere decir que no tiene un pedido asociado
  factMIG_fechaex timestamp without time zone DEFAULT now(),
  factMIG_retefun character varying(200) NOT NULL DEFAULT 'N'::character varying, -- Indica si a la factura se le aplico retencion en la fuente Si(S) o No(N)
  factMIG_vlrrtfu numeric(1000,10) NOT NULL DEFAULT 0, -- Indica el valor de la retencion en la fuente en caso de que no halla sera cero
  factMIG_ajpeso numeric(1000,10) NOT NULL DEFAULT 0,
  factMIG_cons numeric(1000,10) DEFAULT 0,
  factMIG_rsfa bigint,
  factMIG_vlr_acobrar numeric(1000,10) NOT NULL DEFAULT 0,
  factMIG_vlr_abonos numeric(1000,10) NOT NULL DEFAULT 0,
  PRIMARY KEY(factMIG_factMIG)
);
--
--tabla temporal de productos
--
CREATE TABLE fa_tdtprMIG
(
	
  dtprMIG_dtpr BIGSERIAL NOT NULL, -- Identificador primario de la tabla
  dtprMIG_dska bigint NOT NULL, -- Llave foranea con el producto la tabla in_tdska
  dtprMIG_fact bigint NOT NULL, -- Factura asociada a al detalle del producto
  dtprMIG_fecha timestamp without time zone NOT NULL, -- Fecha en la cual se registro la venta
  dtprMIG_num_prod integer NOT NULL, -- Numero de productos vendidos en la factura
  dtprMIG_cant integer NOT NULL, -- Cantidad de productos vendidos
  dtprMIG_vlr_pr_tot numeric(50,6) NOT NULL, -- Valor del total de la venta de todos los productos (Valor del promedio pondendarado del inventario)
  dtprMIG_vlr_uni_prod numeric(50,6) NOT NULL, -- Valor de la unidad del producto (Valor del promedio pondendarado del inventario)
  dtprMIG_vlr_iva_tot numeric(50,6) NOT NULL, -- Valor total que se debe pagar por el o los productos adquiridos
  dtprMIG_vlr_iva_uni numeric(50,6) NOT NULL, -- Valor del iva por cada unidad del producto
  dtprMIG_vlr_venta_tot numeric(50,6) NOT NULL, -- Valor total de los productos con el precio parametrizado para cada sede
  dtprMIG_vlr_venta_uni numeric(50,6) NOT NULL, -- Valor que en el momento de ser vendido estaba parametrizado en el sistema
  dtprMIG_vlr_total numeric(50,6) NOT NULL, -- Valor total de la venta por todos los productos con el iva y el precio parametrizado
  dtprMIG_desc character varying(1) NOT NULL, -- Identificador del descuento del cual se aplico al detalle de la venta
  dtprMIG_con_desc character varying(1) NOT NULL DEFAULT 'N'::character varying, -- Valor de los productos con descuentos
  dtprMIG_valor_desc numeric(50,6) NOT NULL DEFAULT 0, -- Valor del descuento del detalle del producto
  dtprMIG_estado character varying(1) NOT NULL DEFAULT 'A'::character varying, -- Indica el estado en el cual se encuentra el detalle del producto A(Activa) C(Cancelada)
  dtprMIG_kapr integer NOT NULL DEFAULT 0, -- Llave foranea con la tabla que referencia el kardex del producto movimiento de venta
  dtprMIG_dev_kapr integer DEFAULT 0, -- Llave foranea con la tabla que referencia el kardex del producto movimiento de devolucion solo aplica si es una devolucion de lo contrario sera 0
  dtprMIG_utilidad numeric(50,6) NOT NULL DEFAULT 0,
  dtprMIG_cod_ext       varchar(1000) not null,
  PRIMARY KEY(dtprMIG_dtpr)
 );