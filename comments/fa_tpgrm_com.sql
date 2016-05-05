COMMENT ON TABLE  fa_tpgrm                          IS          'Tabla encargada de llevar control de los pagos de las remisiones y de las facturas';
COMMENT ON COLUMN fa_tpgrm.pgrm_pgrm                IS          'Identificador primario de la tabla';
COMMENT ON COLUMN fa_tpgrm.pgrm_clien               IS          'Identifica el cliente que realiza el pago';
COMMENT ON COLUMN fa_tpgrm.pgrm_fecha               IS          'Fecha en la cual se creo el primer pago.';
COMMENT ON COLUMN fa_tpgrm.pgrm_fact                IS          'Referencia a la factura que se va ha cancelar en el pago';
COMMENT ON COLUMN fa_tpgrm.pgrm_remi                IS          'Referencia a la remision que se va ha cancelar ';
COMMENT ON COLUMN fa_tpgrm.pgrm_estado              IS          'Estado del pago PP(Pago parcial a realizados pagos pero no ha cancelado todo) PT(Factura cancelada al 100%)';
COMMENT ON COLUMN fa_tpgrm.pgrm_comprobante         IS          'Ruta del repositorio de imagenes donde se almaceno el comprobante del pago principal';
COMMENT ON COLUMN fa_tpgrm.pgrm_vlrdeuda            IS          'Valor total de la deuda';