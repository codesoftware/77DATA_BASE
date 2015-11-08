--Retorna el usuario con los datos completos

-- DROP TYPE return_usua_com;

CREATE TYPE return_usua_com AS (
  cedula            varchar(50),
  nombre            varchar(50),
  apellido          varchar(50),
  correo            varchar(50),
  telefono          varchar(50),
  tipoUsuario       varchar(2),
  usuario           varchar(50),
  perfil            varchar(50),
  fecha_nac         varchar(50),
  estado            varchar(50),
  id_perfil         varchar(50),
  id_tipo_usuario   varchar(50),
  sede              varchar(50)
);