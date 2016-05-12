COMMENT ON TABLE  fa_tdpgr                          IS          'Tabla encargada de llevar control del detalle del pago de las deudas de las remisiones';
COMMENT ON COLUMN fa_tdpgr.dpgr_dpgr                IS          'Identificador primario de la tabla';
COMMENT ON COLUMN fa_tdpgr.dpgr_pgrm                IS          'Llave foranea con la tabla principal de pagos';
COMMENT ON COLUMN fa_tdpgr.dpgr_fecha               IS          'Fecha en la cual se registro el detalle del pago';
COMMENT ON COLUMN fa_tdpgr.dpgr_estado              IS          'Estado en el cual se encuentra el pago (P) pago y (X) Cancelado';
COMMENT ON COLUMN fa_tdpgr.dpgr_tipopago            IS          'Tipo del pago que se desea realizar E(Efectivo), C(Cheque)  ';
COMMENT ON COLUMN fa_tdpgr.dpgr_valor               IS          'Valor cancelado por el cliente';
COMMENT ON COLUMN fa_tdpgr.dpgr_comprobante         IS          'Ruta del repositorio de imagenes donde se almaceno el comprobante del pago';
COMMENT ON COLUMN fa_tdpgr.dpgr_vlrdeuda            IS          'Valor total de la deuda';
COMMENT ON COLUMN fa_tdpgr.dpgr_mvcot               IS          'Id de transaccion contable del pago';
                                 