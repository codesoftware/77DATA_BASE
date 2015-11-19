COMMENT ON TABLE    IN_TPRHA                      IS     'Tabla encargada de almacenar los precios necesarios para cada servicio ';
COMMENT ON COLUMN   IN_TPRHA.prha_prha            IS     'Identificador primario de la tabla';
COMMENT ON COLUMN   IN_TPRHA.prha_dsha            IS     'Llave foranea con la habitacion';
COMMENT ON COLUMN   IN_TPRHA.prha_precio          IS     'Precio el cual se le data a la habitación';
COMMENT ON COLUMN   IN_TPRHA.prha_tius_crea       IS     'Usuario el cual creo la primera insercion del precio';
COMMENT ON COLUMN   IN_TPRHA.prha_tius_update     IS     'Usuario el cual hizo el ultimo update al registro';
COMMENT ON COLUMN   IN_TPRHA.prha_estado          IS     'Estado en el cual se encuentra la parametrizacion (solo puede haber un Activo A por habitacion)';
COMMENT ON COLUMN   IN_TPRHA.prha_fecha           IS     'Fecha en la cual se asigno el precio a la habitacion';