COMMENT ON TABLE ub_tdepa IS 'Tabla en la cual se almacenara la informacion necesaria para los paises';

COMMENT ON COLUMN ub_tdepa.depa_depa             IS 'Identificador primario de la tabla';
COMMENT ON COLUMN ub_tdepa.depa_pais             IS 'Identifica la llave con la tabla paises';
COMMENT ON COLUMN ub_tdepa.depa_nombre           IS 'Nombres del pais';
COMMENT ON COLUMN ub_tdepa.depa_descripcion      IS 'Descripcion del pais';
COMMENT ON COLUMN ub_tdepa.depa_default          IS 'Indica si el pais ira por default en la lista';
COMMENT ON COLUMN ub_tdepa.depa_codigo           IS 'Codigo de la ciudad del dane';