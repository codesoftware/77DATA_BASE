COMMENT ON TABLE   	IN_TCOPR                    IS     'Tabla encargada de guardar la informacion primordial de un conteo de inventario ';
COMMENT ON COLUMN   IN_TCOPR.COPR_COPR          IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   IN_TCOPR.COPR_ESTADO        IS     'Estado en el cual se encuentra el inventario C (Creado), A(Abierto o en conteo) y Cerrado(X)';
COMMENT ON COLUMN   IN_TCOPR.COPR_TIUS          IS     'Usuario el cual creo el inventario';
COMMENT ON COLUMN   IN_TCOPR.COPR_FECHA         IS     'Fecha en la cual se creo el inventario';
COMMENT ON COLUMN   IN_TCOPR.COPR_SEDE          IS     'Sede en la cual se realizara el inventario ';
COMMENT ON COLUMN   IN_TCOPR.COPR_FEC_INI       IS     'Fecha en la cual se inicio el inventario';
COMMENT ON COLUMN   IN_TCOPR.COPR_FEC_FIN       IS     'Fecha en la cual se termino el inventario';
COMMENT ON COLUMN   IN_TCOPR.COPR_DESC          IS     'Descripcion, comentario o razon por la cual se realiza el inventario';