-- CREAMOS LA TABLA PARAMETROS
-- Tabla en la cual se almacenara los datos unicos de la empresa
-- 

--DROP TABLE IF EXISTS em_tpara;

CREATE TABLE em_tpara(
   para_para               BIGSERIAL                                ,  -- Llave primaria de la tabla
   para_fecha              DATE             DEFAULT now()           ,  -- Fecha en la cual se crea la parametrizacion
   para_clave              varchar(500)                              ,  -- Clave de la parametrizacion
   para_valor              varchar(500)                             ,  -- Valor de la parametrizacion
   PRIMARY KEY (para_para)
); 