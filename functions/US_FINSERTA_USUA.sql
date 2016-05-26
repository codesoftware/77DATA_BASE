-- Funcion encargada de insertar la base de los usuarios

CREATE OR REPLACE FUNCTION US_FINSERTA_USUA (   p_nombre      varchar(500),
                                                p_apellido    varchar(500),
                                                p_cedula      varchar(500),
                                                p_email       varchar(500),
                                                p_fecha_nac   DATE,
                                                p_usuario     varchar(500),
                                                p_contra      varchar(500),
                                                p_perfil      BIGINT      ,
                                                p_sede        BIGINT
                                    ) RETURNS VARCHAR AS $$
   DECLARE 
   c_pers_usua cursor for
      select coalesce(pers_pers,-1)
      from us_tpers
      where pers_cedula = p_cedula
      and pers_email = p_email
      ;
   
   v_pers_pers     bigint;
   v_rta           varchar;       
   
   BEGIN
   
      insert into us_tpers (pers_apellido, pers_nombre, pers_cedula, pers_email, pers_fecha_nac)
                    values (upper(trim(p_apellido)), upper(trim(p_nombre)),trim(p_cedula), trim(p_email),p_fecha_nac);
      
      OPEN c_pers_usua;
      FETCH c_pers_usua INTO v_pers_pers;
      CLOSE c_pers_usua;
      
      IF v_pers_pers <> -1  THEN
         --
         insert into us_ttius (tius_tius,tius_pers, tius_tipo_usuario, tius_usuario, tius_contra_act,tius_perf,tius_cambio_contra,tius_sede)
         values (nextval('us_ttius_tius_tius_seq'::regclass),v_pers_pers,'AD', UPPER(trim(p_usuario)), trim(p_contra), p_perfil, 'S',p_sede)
         ;
         RETURN 'OK';
      ELSE 
         RETURN 'ERR';
      END IF;
      
      EXCEPTION WHEN OTHERS THEN
         RETURN 'ERR' || ' Error postgres: ' || SQLERRM;
END;      
      
 $$ LANGUAGE 'plpgsql';
                                    