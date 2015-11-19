create or replace view us_vusuarios as
select pers.pers_nombre                         nombre,
       pers.pers_apellido                       apellido,
       pers.pers_cedula                         cedula,
       pers.pers_email                          correo,
       pers.pers_tel                            telefono,
       cast('AD' as varchar )                   tipoUsuario,
       tius.tius_usuario                        usuario,
       tius.tius_contra_act                     contra,
       tius.tius_contra_futura                  contra_aux,
       tius.tius_cambio_contra                  cambio_contra,
       tius.tius_estado                         estado_usuario,
       perf.perf_permisos                       permisos_usuario,
       perf.perf_nomb                           perfil_usuario,
       to_char(pers.pers_fecha_nac,'DD/MM/YYYY')  fecha_nacimiento,
       perf.perf_perf                           id_perfil_usuario,
       tius.tius_tius                           id_tipo_usuario,
       to_char(tius.tius_ultimo_ingreso, 'DD/MM/YYYY HH:MI AM') tius_ultimo_ingreso,
       tius_sede                                sede,
       sede_nombre                              nombreSede
FROM us_ttius tius, us_tpers pers, us_tperf perf, em_tsede
WHERE tius.tius_pers = pers_pers
  AND tius.tius_estado = 'A'
  AND tius.tius_perf = perf.perf_perf
  AND tius_sede = sede_sede
;

