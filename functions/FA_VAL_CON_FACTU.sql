--
-- Funcion con la cual se validan las precondiciones necesarias para facturar como lo son 
--
CREATE OR REPLACE FUNCTION FA_VAL_CON_FACTU (  
                                p_sede              BIGINT
                         )RETURNS VARCHAR AS $$
    DECLARE
    --
    --Logica para validaciones previas a la facturacion
    --
    --Cursor el cual valida si la subcuenta para el iva generado existe
    --
    c_val_iva_generado CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '240802'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para el costo por ventas
    --
    c_costo_ventas CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '613535'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para la Mercancia al por mayor y menor
    --
    c_mercancia_mm CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '413535'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para los descuentos
    --
    c_descuentos CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '530535'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para los las retenciones en la fuente
    --
    c_retefuente CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '135515'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para los ajustes al peso
    --
    c_ajustePeso CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '429581'
      ;
    --
    --Cursor el cual verifica si existe la subcuenta para las cuentas por cobrar
    --
    c_cuentasCobrar CURSOR FOR
    SELECT count(*)
      FROM co_tsbcu
     WHERE sbcu_codigo = '138020'
      ;
    --
    --Variables necesarias para la validacion de subcuentas
    --
    v_val_iva_generado          BIGINT :=0;
    v_val_costo_ventas          BIGINT :=0;
    v_val_mercancias_mm         BIGINT :=0;
    v_val_descuentos            BIGINT :=0;
    v_val_retefuente            BIGINT :=0;
    v_val_ajustepeso            BIGINT :=0;
    v_val_cuentaCobrar          BIGINT :=0;
    --
    --Cursor con el cual evaluo si la sede puede facturar osea que no esta marcada como bodega
    --
    c_sedeBodega CURSOR FOR
    SELECT sede_bodega
      FROM em_tsede
     WHERE sede_sede = p_sede 
     ;
    --
    v_bodega_sede       varchar(5) := '';
    --
    --Cursor con el cual evaluo si la sede tiene una subcuenta para la facturacion en caja
    --
    c_sbcu_caja CURSOR FOR
    SELECT sede_sbcu_caja
      FROM em_tsede
     WHERE sede_sede = p_sede
     ;
    --
    v_sbcu_caja_val             BIGINT :=0;
    --
    --Da la primera posibilidad para la creacion de la subcuenta de caja
    --
    c_futuraSubcuenta CURSOR FOR
    SELECT case 
            when count(1)+1 < 9 then '11050'||count(1)+1
            else '1105'||count(1)+1 end subcuenta
      FROM co_tcuen, co_tsbcu
     WHERE cuen_codigo = 1105
       AND sbcu_cuen = cuen_cuen
       ;
    --
    v_sbcu_caja         varchar(200) := '';
    --
    c_validaCreacionSbcu CURSOR(vc_sbcu_codigo VARCHAR) FOR
    SELECT count(1)
      FROM co_tsbcu
     WHERE sbcu_codigo = vc_sbcu_codigo
     ;
    --
    v_validaSbcu        BIGINT :=0;
    --
    v_contador          BIGINT := 0;
    --
    --Obtiene el valor de la secuencia para la insecion de subcuentas
    --
    c_sec_sbcu CURSOR FOR
    SELECT nextval('co_tsbcu_sbcu_sbcu_seq');
    --
    v_sbcu_sbcu     BIGINT := 0;        --Id de la futura subcuenta
    --
    --Cursor en el cual obtengo el nombre de la sede teniendo como base el nombre de la sede
    --
    c_nombresede CURSOR FOR
    SELECT sede_nombre
      FROM em_tsede
     WHERE sede_sede = p_sede
     ;
    --
    v_sede_nombre           varchar(500):= '';
    --
    --Obtiene el codigo que tendra la subcuenta
    --
    c_obtiene_codsbcu CURSOR(vc_sbcu VARCHAR) FOR
    SELECT substring(vc_sbcu from (select length(vc_sbcu))-1 for (select length(vc_sbcu)));
    --
    v_codigo_subcuenta          varchar(500):= '';
    --
    c_subcu_tarj CURSOR FOR
    SELECT count(1)
      FROM em_tpara
     WHERE para_clave = 'PAGOTARJETA'
       AND  para_valor is not null
     ;
    --
    v_valida_tarj           bigint := 0;
    --
    c_exist_sbcu_tj CURSOR FOR
    SELECT COUNT(*)
      FROM co_tauco
     WHERE auco_codi = (SELECT trim(para_valor) valor
                          FROM em_tpara
                         WHERE para_clave = 'PAGOTARJETA')
    ;
    --
    BEGIN
    --
    --Valido si la sede puede facturar
    --
    OPEN c_sedeBodega;
    FETCH c_sedeBodega INTO  v_bodega_sede;
    CLOSE c_sedeBodega;
    --
    IF upper(v_bodega_sede) = 'S' THEN
        --
        RAISE EXCEPTION 'La sede en la cual desea facturar esta marcada como bodega en la cual es imposible facturar, Cambie su sede e intente facturar de nuevo';
        --
    END IF;
    --
    --Inicio de Validacion de Subcuentas Contables necesarias para la contabilizacion
    --
    --
    OPEN c_val_iva_generado;
    FETCH c_val_iva_generado INTO v_val_iva_generado;
    CLOSE c_val_iva_generado;
    --
    OPEN c_costo_ventas;
    FETCH c_costo_ventas INTO v_val_costo_ventas;
    CLOSE c_costo_ventas;
    --
    OPEN c_mercancia_mm;
    FETCH c_mercancia_mm INTO v_val_mercancias_mm;
    CLOSE c_mercancia_mm;
    --
    OPEN c_descuentos;
    FETCH c_descuentos INTO v_val_descuentos;
    CLOSE c_descuentos;
    --
    OPEN c_retefuente;
    FETCH c_retefuente INTO v_val_retefuente;
    CLOSE c_retefuente;
    --
    OPEN c_ajustePeso;
    FETCH c_ajustePeso INTO v_val_ajustepeso;
    CLOSE c_ajustePeso;
    --
    OPEN c_cuentasCobrar;
    FETCH c_cuentasCobrar INTO v_val_cuentaCobrar;
    CLOSE c_cuentasCobrar;
    --
    IF v_val_iva_generado <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de iva generado 240802 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_costo_ventas <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de costo de ventas 613535 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_mercancias_mm <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de mercancias al por menor y mayor 413535 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_descuentos <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de descuentos por ventas 530535 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_retefuente <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de retenciones en la fuente o anticipos de impuestos 135515 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_ajustepeso <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de ajuste al peso 429581 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    IF v_val_cuentaCobrar <> 1 THEN
        --
        RAISE EXCEPTION 'Error cuenta de cuentas por cobrar 138020 no se encuentra parametrizada por favor comunicarse con el administrador del sistema ';
        --
    END IF;
    --
    OPEN c_subcu_tarj;
    FETCH c_subcu_tarj INTO v_valida_tarj;
    CLOSE c_subcu_tarj;
    --
    IF v_valida_tarj = 0 THEN
        --
        RAISE EXCEPTION 'Error no existe cuenta parametrizada para los pagos con tarjeta de credito ';
        --
    END IF;
    --
    v_valida_tarj := 0;
    --
    OPEN c_exist_sbcu_tj;
    FETCH c_exist_sbcu_tj INTO v_valida_tarj;
    CLOSE c_exist_sbcu_tj;
    --
    IF v_valida_tarj = 0 THEN
        --
        RAISE EXCEPTION 'Error la subcuenta que tiene parametrizada para pagos con tarjeta no se encuentra creada en los auxiliares contables del PUC ';
        --
    END IF;
    --
    --Hacemos la logica para la creacion de la subcuenta de caja menor
    --
    OPEN c_sbcu_caja;
    FETCH c_sbcu_caja INTO v_sbcu_caja_val;
    CLOSE c_sbcu_caja;
    --
    IF v_sbcu_caja_val = 0 or v_sbcu_caja_val is null THEN 
        --
        --Logica para la creacion de una nueva subcuenta
        --
        OPEN c_futuraSubcuenta;
        FETCH c_futuraSubcuenta INTO v_sbcu_caja;
        CLOSE c_futuraSubcuenta;
        --
        OPEN c_validaCreacionSbcu(v_sbcu_caja);
        FETCH c_validaCreacionSbcu INTO v_validaSbcu;
        CLOSE c_validaCreacionSbcu;
        --
        IF v_validaSbcu <> 0 THEN 
            --
            LOOP 
                IF v_contador < 10 THEN 
                    --
                    v_sbcu_caja := '11050' || v_contador;
                    --
                ELSE 
                    --
                    v_sbcu_caja := '1105'|| v_contador;
                    --
                END IF;
                --
                v_contador := v_contador + 1;
                --
                OPEN c_validaCreacionSbcu(v_sbcu_caja);
                FETCH c_validaCreacionSbcu INTO v_validaSbcu;
                CLOSE c_validaCreacionSbcu;
                --
                IF v_validaSbcu = 0  or v_contador = 99 THEN
                    --
                    exit;
                    --
                END IF;
                
            END LOOP;
            --
        END IF;
        --
        OPEN c_sec_sbcu;
        FETCH c_sec_sbcu INTO v_sbcu_sbcu;
        CLOSE c_sec_sbcu;
        --
        OPEN c_nombresede;
        FETCH c_nombresede INTO v_sede_nombre;
        CLOSE c_nombresede;
        --
        OPEN c_obtiene_codsbcu(v_sbcu_caja);
        FETCH c_obtiene_codsbcu INTO v_codigo_subcuenta;
        CLOSE c_obtiene_codsbcu;
        --
        INSERT INTO co_tsbcu(
                    sbcu_sbcu,sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
                    sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
            VALUES (v_sbcu_sbcu,1, 1, 1, 'A', 'CAJA MENOR '|| upper(v_sede_nombre) , 
                    v_codigo_subcuenta,'Se almacenara el dinero que ingrese o salga de la caja de la sede' || upper(v_sede_nombre) , 'D');
        --
        UPDATE em_tsede
           SET sede_sbcu_caja = v_sbcu_sbcu
         WHERE sede_sede = p_sede
         ;
        --
    END IF;
    --
    RETURN 'OK';
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_VAL_CON_FACTU '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';