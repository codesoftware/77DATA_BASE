 
select * 
from pg_stat_activity 
where datname = 'Hotel'

--REINICIAR SECUENCIAS

ALTER SEQUENCE NOMBRE_SECUENCIA restart 1


update in_tkapr
set kapr_mvin = 2


select * 
from pg_stat_activity
WHERE APPLICATION_NAME <> 'pgAdmin III - Browser'
AND DATNAME = 'SigemcoPRUEBAS'