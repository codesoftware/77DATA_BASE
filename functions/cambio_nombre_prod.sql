-- Function: cambio_nombre_prod()

-- DROP FUNCTION cambio_nombre_prod();

CREATE OR REPLACE FUNCTION cambio_nombre_prod()
  RETURNS character varying AS
$BODY$
   DECLARE 
   
   c_prod cursor for
   select cate_desc || ' '|| marca_nombre || ' ' || refe_desc nombreProd, dska_dska
     from in_tdska, in_tcate, in_tmarca, in_trefe
    where dska_cate = cate_cate
      and marca_marca = dska_marca
      and refe_refe = dska_refe
    ;
   
   BEGIN
   
      FOR nombre in c_prod
        LOOP
        
        update in_tdska
        set dska_nom_prod = nombre.nombreProd,
        dska_desc = nombre.nombreProd
        where dska_dska = nombre.dska_dska
        ;
      END LOOP;
      
      return 'Ok';
      EXCEPTION WHEN OTHERS THEN
         RETURN 'ERR' || ' Error postgres: ' || SQLERRM;
END;      
      
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cambio_nombre_prod()
  OWNER TO postgres;
