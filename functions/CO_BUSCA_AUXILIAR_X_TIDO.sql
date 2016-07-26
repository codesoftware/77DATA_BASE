--
--funcion que realiza la solicitud
--
CREATE OR REPLACE function CO_BUSCA_AUXILIAR_X_TIDO(
                  p_sbcu            bigint,
                  p_tipoDoc         VARCHAR,   --Importacion(impo) Factura compra (facom)
                  p_param_ad        VARCHAR default 'N/A' --Campo con el cual se crean reglas adicionales dependiendo del tipo de documento y la cuenta contable
                  ) RETURNS BIGINT AS $$
    DECLARE
    --
    c_cod_sbcu CURSOR FOR
    SELECT sbcu_codigo,sbcu_nombre
      FROM CO_TSBCU
     WHERE SBCU_SBCU = p_sbcu
     ;
    --
    c_auco_auco CURSOR (vc_codigo varchar) IS
    SELECT auco_auco
      FROM co_tauco
     WHERE auco_codi = vc_codigo
     ;
    --
    v_cod_subcuenta                varchar(10)        := '';
    v_nom_subcuenta                varchar(1000)    := '';
    --
    v_cod_auco                    varchar(12):= '';
    --
    v_accion                     varchar(10):= '';
    --
    v_auco_auco                 bigint := 0;
    --
    BEGIN
    --
    IF p_tipoDoc = 'impo' THEN
        --
        OPEN c_cod_sbcu;
        FETCH c_cod_sbcu INTO v_cod_subcuenta, v_nom_subcuenta;
        CLOSE c_cod_sbcu;
        --
        IF v_cod_subcuenta is null THEN
            --
            raise exception 'La subcuenta referenciada no existe ';
            --
        END IF;
        --
        OPEN c_auco_auco(v_cod_subcuenta||'01');
        FETCH c_auco_auco INTO v_auco_auco;
        CLOSE c_auco_auco;
        --
        IF  v_auco_auco is null THEN
            --
            v_accion := 'INSERTO';
            --
        ELSE
            return v_auco_auco;
        END IF;
        --
    END IF;
    
    IF p_tipoDoc = 'facom' THEN
        --
        OPEN c_cod_sbcu;
        FETCH c_cod_sbcu INTO v_cod_subcuenta, v_nom_subcuenta;
        CLOSE c_cod_sbcu;
        --
        IF v_cod_subcuenta is null THEN
            --
            raise exception 'La subcuenta referenciada no existe ';
            --
        END IF;
        --
        OPEN c_auco_auco(v_cod_subcuenta||'01');
        FETCH c_auco_auco INTO v_auco_auco;
        CLOSE c_auco_auco;
        --
        IF  v_auco_auco is null THEN
            --
            v_accion := 'INSERTO';
            --
        ELSE
            return v_auco_auco;
        END IF;
        --
    END IF;
    --
    IF p_tipoDoc = 'faven' THEN
        --
        OPEN c_cod_sbcu;
        FETCH c_cod_sbcu INTO v_cod_subcuenta, v_nom_subcuenta;
        CLOSE c_cod_sbcu;
        --
        IF v_cod_subcuenta is null THEN
            --
            raise exception 'La subcuenta referenciada no existe ';
            --
        END IF;
        --
        OPEN c_auco_auco(v_cod_subcuenta||'01');
        FETCH c_auco_auco INTO v_auco_auco;
        CLOSE c_auco_auco;
        --
        IF  v_auco_auco is null THEN
            --
            v_accion := 'INSERTO';
            --
        ELSE
            return v_auco_auco;
        END IF;
        --
    END IF;
    --
    IF v_accion = 'INSERTO' THEN    
        --
        v_auco_auco := nextval('co_tauco_auco_auco_seq'::regclass);
        --
        insert into co_tauco (auco_auco, auco_sbcu, auco_nomb, auco_codi,auco_descr)
                       values(v_auco_auco ,p_sbcu,v_nom_subcuenta,'01',v_nom_subcuenta);
        --
        RETURN v_auco_auco;
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