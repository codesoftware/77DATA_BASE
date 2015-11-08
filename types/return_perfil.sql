--
-- DROP TYPE IF EXISTS return_usuario CASCADE;
--
CREATE TYPE return_perfil AS (
  primary_key       int,
  nombre            varchar(50),
  descripcion       varchar(500),
  perimisos         varchar(200),
  estado            varchar(1)  
);
