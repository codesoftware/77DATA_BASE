--
--funcion que realiza la solicitud
--
CREATE OR REPLACE function CO_BUSCA_AUXILIAR_X_TIDO(
                  p_sbcu            bigint,
                  p_tipoDoc         VARCHAR   --Importacion(impo)
                  ) RETURNS BIGINT AS $$
    DECLARE
    --
    c_val_inven CURSOR FOR
    SELECT case  when count(*) > 0 then 'SI' ELSE 'NO' END
      FROM co_tsbcu
     WHERE sbcu_sbcu = p_sbcu
       AND sbcu_codigo like '1435%'
       ;
    --
    c_val_sbcu CURSOR FOR
    SELECT case  when count(*) > 0 then 'SI' ELSE 'NO' END
      FROM co_tsbcu
     WHERE sbcu_sbcu = p_sbcu
       AND sbcu_codigo like '790505'
       ;
    --
    v_valida        varchar(3):= 0;
    --
    c_cod_sbcu CURSOR FOR
    SELECT sbcu_codigo,sbcu_nombre
      FROM CO_TSBCU
     WHERE SBCU_SBCU = p_sbcu
     ;
    --
    c_cod_auco CURSOR (vc_codigo varchar) IS
    SELECT count(*)
      FROM co_tauco
     WHERE auco_codi = vc_codigo ||'01'
     ;
    --
    c_auco_auco CURSOR (vc_codigo varchar) IS
    SELECT auco_auco
      FROM co_tauco
     WHERE auco_codi = vc_codigo
     ;
    --
    v_sbcu_codigo           varchar(12):= '';
    --
    v_valida_auco           bigint:= 0;
    --
    v_sbcu_nombre           varchar(1000):= '';
    --
    v_auco_auco             bigint := 0;
    --
    BEGIN
    --
    IF p_tipoDoc = 'impo' THEN
        --
        --Valido si la cuenta es de inventarios
        --
        OPEN c_val_inven;
        FETCH c_val_inven INTO v_valida;
        CLOSE c_val_inven;
        --
        IF v_valida = 'SI' THEN
            --
            OPEN c_cod_sbcu;
            FETCH c_cod_sbcu INTO v_sbcu_codigo,v_sbcu_nombre;
            CLOSE c_cod_sbcu;
            --
            OPEN c_cod_auco(v_sbcu_codigo);
            FETCH c_cod_auco INTO v_valida_auco;
            CLOSE c_cod_auco;
            --
            IF v_valida_auco = 0 THEN
                --
                v_auco_auco := nextval('co_tauco_auco_auco_seq'::regclass);
                --
                insert into co_tauco (auco_auco, auco_sbcu, auco_nomb, auco_codi,auco_descr)
                values(v_auco_auco ,p_sbcu,v_sbcu_nombre,'01',v_sbcu_nombre);
                --
            ELSE
                --
                OPEN c_auco_auco(v_sbcu_codigo||'01');
                FETCH c_auco_auco INTO v_auco_auco;
                CLOSE c_auco_auco;
                --
            END IF;
            --
            RETURN v_auco_auco;
            --
        END IF;
        --
        OPEN c_val_sbcu;
        FETCH c_val_sbcu INTO v_valida;
        CLOSE c_val_sbcu;
        --
        IF v_valida = 'SI' THEN
            --
            OPEN c_cod_sbcu;
            FETCH c_cod_sbcu INTO v_sbcu_codigo,v_sbcu_nombre;
            CLOSE c_cod_sbcu;
            --
            OPEN c_cod_auco(v_sbcu_codigo);
            FETCH c_cod_auco INTO v_valida_auco;
            CLOSE c_cod_auco;
            --
            IF v_valida_auco = 0 THEN
                --
                v_auco_auco := nextval('co_tauco_auco_auco_seq'::regclass);
                --
                insert into co_tauco (auco_auco, auco_sbcu, auco_nomb, auco_codi,auco_descr)
                values(v_auco_auco ,p_sbcu,v_sbcu_nombre,v_sbcu_codigo||'01',v_sbcu_nombre);
                --
            ELSE
                --
                OPEN c_auco_auco(v_sbcu_codigo||'01');
                FETCH c_auco_auco INTO v_auco_auco;
                CLOSE c_auco_auco;
                --
            END IF;
            --
            RETURN v_auco_auco;
            --
        END IF;
        --
    END IF;
    --
    RETURN -1;
    --
    EXCEPTION WHEN 
        OTHERS THEN
            --
            return 'Error CO_BUSCA_AUXILIAR_X_TIDO ' || sqlerrm;
    END;
    $$ LANGUAGE 'plpgsql';