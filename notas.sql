Notas:
1. La secuencia que se utiliza para los movimientos contables es co_temp_movi_contables
2. Despues de ejecutar el comand instalador se debe correr los insert que estan en clientes77.sql
3. se debe ejecutar f_cargacliente();

Consulta para identificar que productos no tienen precio parametrizado 

SELECT *
FROM IN_TDSKA
WHERE NOT EXISTS (SELECT * FROM IN_TPRPR WHERE PRPR_DSKA = DSKA_DSKA AND PRPR_SEDE = 2 AND PRPR_ESTADO = 'A')
order by dska_dska

Consulta que me parametro para precio me falta por parametrizar

select dska_cod_ext, dska_desc, cate_desc, refe_nombre, marca_nombre
from in_tdska, in_tcate, in_trefe, in_tmarca
where not exists (select * from in_tpops where pops_estado = 'A' and pops_sede = 2 and pops_cate = dska_cate 
and pops_refe = dska_refe and dska_marca = pops_marca)
and dska_cate = cate_cate
and dska_refe = refe_refe
and dska_marca = marca_marca
order by cate_desc, refe_nombre, marca_nombre