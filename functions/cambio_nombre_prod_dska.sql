-- Function: cambio_nombre_prod()

-- DROP FUNCTION cambio_nombre_prod();

CREATE OR REPLACE FUNCTION cambio_nombre_prod_dska(p_dska_dska      bigint)
  RETURNS character varying AS
$BODY$
   DECLARE 
   
   c_prod cursor for
   select cate_desc || ' '|| marca_nombre || ' ' || refe_desc nombreProd, dska_dska
     from in_tdska, in_tcate, in_tmarca, in_trefe
    where dska_cate = cate_cate
      and marca_marca = dska_marca
      and refe_refe = dska_refe
	  and dska_dska = p_dska_dska
    ;
   --
   v_nombre         varchar(2000):= '';
   --
   BEGIN
   
        open c_prod;
        fetch c_prod into v_nombre;
        close c_prod;
        
        update in_tdska
        set dska_nom_prod = v_nombre
        where dska_dska = p_dska_dska
        ;
      
      return 'Ok';
      EXCEPTION WHEN OTHERS THEN
         RETURN 'ERR' || ' Error postgres: ' || SQLERRM;
END;      
      
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cambio_nombre_prod()
  OWNER TO postgres;
