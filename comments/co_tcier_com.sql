COMMENT ON TABLE    AD_TCIER                         IS     'Tabla encargada de almacenar los cierres diarios por sede';
COMMENT ON COLUMN   AD_TCIER.CIER_CIER               IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   AD_TCIER.CIER_FECH               IS     'Fecha del cierre';
COMMENT ON COLUMN   AD_TCIER.CIER_USUA        		 IS     'Codigo del usuario que realizo el cierre';
COMMENT ON COLUMN   AD_TCIER.CIER_VLRI         		 IS     'Valor total del iva de todas las facturas del dia';
COMMENT ON COLUMN   AD_TCIER.CIER_VLRT         		 IS     'Valor total de las facturas del dia';
COMMENT ON COLUMN   AD_TCIER.CIER_VLRC            	 IS     'Valor de la caja';
COMMENT ON COLUMN   AD_TCIER.CIER_SEDE            	 IS     'Sede donde se aplica cierre';