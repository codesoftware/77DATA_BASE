--
-- Funcion encargada de realizar toda la facturacion del sistema
--
CREATE OR REPLACE FUNCTION SIMULACION_MVTO_CONTABLES (  
                                                        p_idTrans               INT,                                                        
                                                        p_sede                  INT,
                                                        p_tipoPago              VARCHAR,
                                                        p_valrTarjeta           NUMERIC(15,6)
                                                    ) RETURNS VARCHAR  AS $$
    DECLARE
    --
    --Obtiene el id de la subucenta por medio del codigo
    --
    c_sbcu_sbcu CURSOR(vc_sbcu_codigo VARCHAR) IS
    SELECT sbcu_sbcu
      FROM co_tsbcu
     WHERE sbcu_codigo = vc_sbcu_codigo
     ; 
    --
    --Cursor que obtiene los movimientos contables de la transaccion
    --
    c_sbcu_factura  CURSOR(vc_temIdTrans INT) IS
    SELECT tem_simmvco_sbcu, tem_simmvco_valor, tem_simmvco_naturaleza
      FROM co_ttem_simmvco
     WHERE tem_simmvco_trans = vc_temIdTrans
     ;
    --
    --
    --Cursores necesarios para la contabilizacion
    --
    c_sum_debitos CURSOR(vc_temIdTrans INT) IS
    SELECT sum(coalesce(cast(tem_simmvco_valor as numeric),0) )
      FROM co_ttem_simmvco
     WHERE upper(tem_simmvco_naturaleza) = 'D'
       AND tem_simmvco_trans = vc_temIdTrans
       ;
    --
    c_sum_creditos CURSOR(vc_temIdTrans INT) IS
    SELECT sum(coalesce(cast(tem_simmvco_valor as numeric),0) )
      FROM co_ttem_simmvco
     WHERE upper(tem_simmvco_naturaleza) = 'C'
       AND tem_simmvco_trans = vc_temIdTrans
       ;
    --
    --
    --Cursor el cual encuentra la subcuenta parametrizada en 
    --el sistema para ingresar los pagos con tarjeta
    --
    c_cuenta_tarjeta CURSOR FOR 
    SELECT para_valor
      FROM em_tpara
     WHERE para_clave = 'SBCUTARJETA'
     ;
    --
    v_sbcu_cod_pgtj         varchar(10);
    v_vlr_total_fact_co     NUMERIC(15,6) := 0;
    --
    v_valor_real_apagar         NUMERIC(15,6) := 0;
    v_valor_pago_efectivo       NUMERIC(15,6) := 0;
    --
    --Variables necesarias para la validacion de subcuentas
    --
    v_val_iva_generado          int :=0;
    v_val_costo_ventas          int :=0;
    v_val_mercancias_mm         int :=0;
    v_val_descuentos            int :=0;
    --
    --
    --Logica para validaciones previas a la facturacion
    --
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
    c_sec_sim_tem_mvco CURSOR FOR
    SELECT nextval('co_temp_sim_movi_transcontable') 
    ;
    --
    v_idTrans_con           INT:= 0;
    --
    --
    --Cursor el cual obtiene todos los productos que fueron facturados teniendo en cuenta el id de transaccion
    --
    c_prod_fact CURSOR FOR
    SELECT tem_sifc_dska, tem_sifc_cant,tem_sifc_dcto 
      FROM CO_TTEM_SIFC
     WHERE tem_sifc_trans = p_idTrans
     ;
    --
    --
    --Cursor con el cual obtengo el valor del promedio pornderado del producto
    --
    c_prom_pond_prod CURSOR(vc_dska_dska INT) IS
    SELECT kapr_cost_saldo_uni, kapr_cant_saldo,kapr_cost_saldo_tot
      FROM in_tkapr
     WHERE kapr_kapr = (select max(kapr_kapr) from in_tkapr where kapr_dska = vc_dska_dska)
    ;
    --
    v_vlr_prom_pond        NUMERIC(15,6) := 0;
    v_precio_prod          NUMERIC(15,6) := 0;
    v_diferencia_precio    NUMERIC(15,6) := 0;
    v_vlr_tot_fact_iva     NUMERIC(15,6) := 0;
    v_vlr_total_fact       NUMERIC(15,6) := 0;
    v_vlr_iva_tot          NUMERIC(15,6) := 0;
    --
    --Variables necesarias para la contabilizacion
    --
    v_iva_mvco              NUMERIC(15,6):=0;
    v_sum_deb               NUMERIC(15,6):=0;
    v_sum_cre               NUMERIC(15,6):=0;
    v_sbcu_sbcu             INT := 0;
    v_vlr_dscto_fact        NUMERIC(15,6) := 0;
    --
    v_vlr_total_factura     NUMERIC(15,6) := 0;
    --
    --Cursor en el cual obtengo el valor parametrizado para el  producto en la sede en la cual fue comprado
    --
    c_precio_prod CURSOR(vc_dska_dska  INT)IS
    SELECT prpr_precio
      FROM in_tprpr
     WHERE prpr_estado = 'A'
       and prpr_dska = vc_dska_dska
       and prpr_sede = p_sede
       ;
    --
    --Cursor con el cual se calcula el valor del iva parametrizado
    --
    c_calc_iva CURSOR(vc_valor  NUMERIC)IS
    SELECT (cast(para_valor as numeric) *vc_valor) / 100 vlrIva
    FROM em_tpara where para_clave = 'IVAPR'
    ;
    --
    BEGIN    
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
    OPEN c_sec_sim_tem_mvco;
    FETCH c_sec_sim_tem_mvco INTO v_idTrans_con;
    CLOSE c_sec_sim_tem_mvco;
    --
    FOR prod IN c_prod_fact
    LOOP
        --
        --Obtiene el valor del promedio ponderado
        --
        OPEN c_prom_pond_prod(prod.tem_sifc_dska);
        FETCH c_prom_pond_prod INTO v_vlr_prom_pond;
        CLOSE c_prom_pond_prod;
        --
        --Obtiene el precio de venta del producto
        --
        OPEN c_precio_prod(prod.tem_sifc_dska);
        FETCH c_precio_prod INTO v_precio_prod;
        CLOSE c_precio_prod;
        --
        --Obtenemos el precio en el cual se va ha dejar el producto realmente al cliente
        --
        v_diferencia_precio := v_precio_prod - (prod.tem_sifc_dcto/prod.tem_sifc_cant);
        --
        --Valiamos si el descuento es viable o va ha producir perdidas al negocio
        --
        IF v_diferencia_precio <= v_vlr_prom_pond THEN 
        --
            RAISE EXCEPTION 'El sistema no permite descuentos que superen el valor del promedio ponderado';
        --
        END IF;
        --
        v_vlr_total_fact := prod.tem_sifc_cant * v_precio_prod;
        --
        OPEN c_calc_iva(v_vlr_total_fact);
        FETCH c_calc_iva INTO v_vlr_iva_tot;
        CLOSE c_calc_iva;
        --
        v_vlr_tot_fact_iva := v_vlr_tot_fact_iva + v_vlr_iva_tot;
        --
        --Suma de Iva
        --        
        v_iva_mvco := v_iva_mvco + v_vlr_iva_tot;
        --
        --Suma de valores de descuento
        --
        v_vlr_dscto_fact := v_vlr_dscto_fact + prod.tem_sifc_dcto;
        --
        --Suma el valor total a pagar de cada producto
        --
        v_vlr_total_factura := v_vlr_total_factura + v_vlr_total_fact;
        --
    END LOOP;
    --
    DELETE FROM co_ttem_sifc
    WHERE tem_sifc_trans = p_idTrans
    ;
    --
    --Insercion para contabilizar el iva
    --
    INSERT INTO co_ttem_simmvco(
            tem_simmvco_trans, tem_simmvco_sbcu, tem_simmvco_valor, tem_simmvco_naturaleza) 
    VALUES (v_idTrans_con, '240802' , v_iva_mvco , 'C');
    --
    --Insercion para contabilizar Mercancias al por mayor y menor
    --
    INSERT INTO co_ttem_simmvco(
            tem_simmvco_trans, tem_simmvco_sbcu, tem_simmvco_valor, tem_simmvco_naturaleza) 
    VALUES (v_idTrans_con, '413535' , v_vlr_total_factura , 'C');
    --
    --Insercion para la contabilizacion de descuentos
    --
    INSERT INTO co_ttem_simmvco(
            tem_simmvco_trans, tem_simmvco_sbcu, tem_simmvco_valor, tem_simmvco_naturaleza) 
    VALUES (v_idTrans_con, '530535' , v_vlr_dscto_fact , 'D');
    --
    v_vlr_total_fact_co := (v_vlr_total_factura + v_iva_mvco) - v_vlr_dscto_fact;
    --
    IF upper(p_tipoPago) = 'T' THEN
        --
        OPEN c_cuenta_tarjeta;
        FETCH c_cuenta_tarjeta INTO v_sbcu_cod_pgtj;
        CLOSE c_cuenta_tarjeta;        
        --
        INSERT INTO co_ttem_simmvco(
                tem_simmvco_trans, tem_simmvco_sbcu, tem_simmvco_valor, tem_simmvco_naturaleza) 
                         VALUES (v_idTrans_con, v_sbcu_cod_pgtj , v_vlr_total_fact_co , 'D');        
        --
    ELSIF upper(p_tipoPago) = 'M' THEN
        --
        --Validaciones necesarias para el pago mixto(tarjeta y efectivo)
        --
        IF p_valrTarjeta = 0 THEN
            --
            RAISE EXCEPTION 'SI DESA PAGAR CON TARJETA Y EN EFECTIVO EL VALOR DEL PAGO CON TARJETA NO PUEDE SER 0';
            --
        END IF;
        --
        v_valor_real_apagar := v_vlr_total_fact_co - v_vlr_dscto_fact;
        --
        IF v_valor_real_apagar = p_valrTarjeta THEN
            --
            RAISE EXCEPTION  'Cuando se realiza el pago mixto no es posible que el pago con tarjeta sea la totatalida de la compra y si desea realizarlo asi por favor seleccione PAGO CON TARJETA ';
            --
        END IF;
        
        IF v_valor_real_apagar < p_valrTarjeta THEN
            --
            RAISE EXCEPTION  'El pago con tarjeta no puede ser mayor a la totalidad de la compra';
            --
        END IF;        
        --
        v_valor_pago_efectivo := v_vlr_total_fact_co - p_valrTarjeta;
        --
        OPEN c_cuenta_tarjeta;
        FETCH c_cuenta_tarjeta INTO v_sbcu_cod_pgtj;
        CLOSE c_cuenta_tarjeta;        
        --        
        INSERT INTO co_ttem_simmvco(
                tem_simmvco_trans, tem_simmvco_sbcu, tem_simmvco_valor, tem_simmvco_naturaleza) 
                         VALUES (v_idTrans_con, v_sbcu_cod_pgtj , p_valrTarjeta , 'D');
        --
        INSERT INTO co_ttem_simmvco(
                tem_simmvco_trans, tem_simmvco_sbcu, tem_simmvco_valor, tem_simmvco_naturaleza) 
                         VALUES (v_idTrans_con, '110501' , v_valor_pago_efectivo , 'D');        
        --
    ELSE 
        --
        INSERT INTO co_ttem_simmvco(
                tem_simmvco_trans, tem_simmvco_sbcu, tem_simmvco_valor, tem_simmvco_naturaleza) 
                         VALUES (v_idTrans_con, '110501' , v_vlr_total_fact_co , 'D');        
        --
    END IF;    
    --
    OPEN c_sum_debitos(v_idTrans_con);
    FETCH c_sum_debitos INTO v_sum_deb;
    CLOSE c_sum_debitos;
    --
    OPEN c_sum_creditos(v_idTrans_con);
    FETCH c_sum_creditos INTO v_sum_cre;
    CLOSE c_sum_creditos;
    --
    IF v_sum_deb = v_sum_cre THEN
        --
        FOR movi IN c_sbcu_factura(v_idTrans_con) 
        LOOP
            --
            OPEN c_sbcu_sbcu(movi.tem_simmvco_sbcu);
            FETCH c_sbcu_sbcu INTO v_sbcu_sbcu;
            CLOSE c_sbcu_sbcu;
            --
            INSERT INTO CO_TSIMC(SIMC_TRANS, SIMC_SBCU, 
                                 SIMC_NATURALEZA, SIMC_VALOR
                                 )
                VALUES ( v_idTrans_con, v_sbcu_sbcu , 
                        movi.tem_simmvco_naturaleza, cast(movi.tem_simmvco_valor as NUMERIC)
                         );
            
        END LOOP;
        --
        DELETE FROM co_ttem_simmvco
        WHERE tem_simmvco_trans = v_idTrans_con
        ;
        --         
    ELSE
        --
        RAISE EXCEPTION 'Las sumas de las cuentas al facturar no coinciden por favor contactese con el administrador Debitos %, Creditos %',v_sum_deb,v_sum_cre;
        --
    END IF;
    --
    return 'Ok-'|| v_idTrans_con;
    --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';