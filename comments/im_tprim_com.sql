COMMENT  ON TABLE   IM_TPRIM                          IS 'Tabla encargada de almacenar los productos asociados a una importacion';
COMMENT  ON COLUMN  IM_TPRIM.prim_prim                IS 'id unico de la tabla';
COMMENT  ON COLUMN  IM_TPRIM.prim_impo                IS 'Llave con la tabla de importaciones';
COMMENT  ON COLUMN  IM_TPRIM.prim_dska                IS 'Llave con la tabla de productos';
COMMENT  ON COLUMN  IM_TPRIM.prim_cant                IS 'Cantidad de productos que tiene la importacion';
COMMENT  ON COLUMN  IM_TPRIM.prim_vlrDolar            IS 'Valor unitario de cada producto en dolares';
COMMENT  ON COLUMN  IM_TPRIM.prim_vlrPesTRM           IS 'Valor en pesos unitario calculado con la trm del dolar';
COMMENT  ON COLUMN  IM_TPRIM.prim_vlrPesTzProm        IS 'Valor en pesos unitario calculado con la taza promedio del dolar';