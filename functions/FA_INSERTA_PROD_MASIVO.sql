--
-- Funcion con la cual se crea la cancelacion de una factura 
--

CREATE OR REPLACE FUNCTION FA_INSERTA_PROD_MASIVO()RETURNS VARCHAR  AS $$
    DECLARE
       --
       --Cursor con el cual obtengo los datos que deseo ingresar las existencias
       --
       c_datosExcel CURSOR FOR 
       SELECT tmpidexc_dska, 2 sede, tmpidexc_costo, tmpidexc_existencia
         FROM in_tmpidexc
         ;
        --
        --Cursor con el cual calculo el valor del movimiento contable que se va ha realizar
        --
        c_valorMvtocont CURSOR(vc_costo NUMERIC) IS
        SELECT ((CAST(para_valor AS INT) * vc_costo)/100) + vc_costo
          FROM em_tpara
         WHERE PARA_CLAVE = 'IVAPR'
         ;
        --
        --
        c_sec_contabilidad CURSOR IS
        SELECT CAST(nextval('co_temp_movi_contables') AS INT)
        ;
        --
        --Cursor con el cual obtengo el porcentaje para calcular el precio dependiendo su categoria
        --
        c_porcentaje_precio CURSOR(vc_dska_dska INT) IS
        select cate_porcentaje
          from in_tdska, in_tcate
         where dska_cate = cate_cate
           and dska_dska = vc_dska_dska
           ;
        --
        c_tipo_cate CURSOR(vc_dska_dska INT) IS
        select upper(cate_desc)
          from in_tdska, in_tcate
         where dska_cate = cate_cate
           and dska_dska = vc_dska_dska
           ;
        --
        v_desc_cat      varchar(500) := '';
        --
        v_sec_cont      INT :=0;
        v_valRegistro   varchar(200) := '';  
        --
        v_precio        NUMERIC(1000,10) := 0;
        --
        v_modulo        NUMERIC(1000,10) := 0;
        --
        v_faltante      NUMERIC(1000,10) := 0;
        --
        v_valorMvto     NUMERIC(1000,10) := 0;
        --
        v_costo_total   NUMERIC(1000,10) := 0;
        --
        v_porc_precio   numeric(1000,10) := 0;
        --
        c_iva_precio CURSOR IS
        SELECT cast(para_valor as numeric)
          FROM em_tpara
         WHERE para_clave = 'IVAPRVENTA'
        ;
        --
        v_iva_precio                NUMERIC(1000,10) := 0;
        --
        v_auxiliar                  NUMERIC(1000,10) := 100.00;
        --
        v_unidad                    numeric(1000,10) := 0;
        v_centenas                  numeric(1000,10) := 0;
        v_millar                    numeric(1000,10) := 0;
        --
        v_modulo_pre_mayor          NUMERIC(1000,10) := 0;
        --
    BEGIN
        --
        FOR dato IN c_datosExcel LOOP
        --  
            OPEN c_porcentaje_precio(dato.tmpidexc_dska);
            FETCH c_porcentaje_precio INTO v_porc_precio;
            CLOSE c_porcentaje_precio;
            --
            v_costo_total := dato.tmpidexc_costo * cast(dato.tmpidexc_existencia as INT);
            --
            OPEN c_sec_contabilidad;
            FETCH c_sec_contabilidad INTO v_sec_cont;
            CLOSE c_sec_contabilidad;
            --
            OPEN c_valorMvtocont(v_costo_total);
            FETCH c_valorMvtocont INTO v_valorMvto;
            CLOSE c_valorMvtocont;
            --
            --
            INSERT INTO co_ttem_mvco(
                            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                VALUES (v_sec_cont, '110501', v_valorMvto ,'C');
            --
            v_valRegistro := IN_ADICIONA_PROD_EXIS(dato.tmpidexc_dska, cast(dato.tmpidexc_existencia as INT) , v_costo_total ,dato.sede,1,v_sec_cont);
            --
            IF UPPER(TRIM(v_valRegistro)) NOT LIKE '%OK%' THEN
                --
                RAISE EXCEPTION 'Error al realizar el ingreso de existencias masivas %', v_valRegistro;
                --
            ELSE
                --
                --Calculo de precios para cada producto
                --                
                UPDATE in_tprpr
                   SET prpr_estado = 'I'
                 WHERE prpr_sede = dato.sede
                   AND prpr_dska = dato.tmpidexc_dska
                   ;
                --
                v_precio := ((dato.tmpidexc_costo*v_porc_precio)/100) + dato.tmpidexc_costo;
                --
                --
                v_precio := round(v_precio);
                --
                IF v_precio < 50 THEN
                    --
                    v_precio := 50;
                    --
                ELSIF v_precio between 50 and 100 THEN
                    --
                    v_precio := 100;
                    --
                ELSIF v_precio between 100 and 10000 THEN
                    --
                    v_modulo := v_precio % 100;
                    v_faltante := 100 - v_modulo;
                    v_precio := v_precio + v_faltante;
                    v_precio := round(v_precio);
                    --
                ELSE
                    --
                    v_modulo := v_precio % 1000;
                    v_faltante := 1000 - v_modulo;
                    v_precio := v_precio + v_faltante;
                    v_precio := round(v_precio);
                    --
                END IF;
                --
                OPEN c_iva_precio;
                FETCH c_iva_precio INTO v_iva_precio;
                CLOSE c_iva_precio;
                --
                --Calculos de precios auxiliares discriminados por categorias
                --
                OPEN c_tipo_cate(dato.tmpidexc_dska);
                FETCH c_tipo_cate INTO v_desc_cat;
                CLOSE c_tipo_cate;
                --
                IF v_desc_cat = 'TORNILLOS' THEN
                    --
                    v_auxiliar := 100.00;
                    --
                    v_auxiliar :=  (v_iva_precio / v_auxiliar)+1;
                    --
                    v_precio :=  v_precio /v_auxiliar;
                    --
                    v_millar := 0;
                    v_centenas := 0;
                    v_unidad := 0;
                    --
                    --Calculos para los precios por unidad, centena y millar
                    --
                    v_millar := ((dato.tmpidexc_costo * 20.00 )/100.00) + dato.tmpidexc_costo;
                    --
                    v_centenas := ((dato.tmpidexc_costo * 25.00 )/100.00) + dato.tmpidexc_costo;
                    --
                    v_unidad := ((dato.tmpidexc_costo * 30.00 )/100.00) + dato.tmpidexc_costo;
                    --
                    v_millar := (( v_millar * v_iva_precio )/100.00) + v_millar;
                    --
                    v_centenas := (( v_centenas * v_iva_precio )/100.00) + v_centenas;
                    --
                    v_unidad := (( v_unidad * v_iva_precio )/100.00) + v_unidad;
                    --
                ELSE
                    --
                    v_auxiliar := 100.00;
                    --
                    v_auxiliar :=  (v_iva_precio / v_auxiliar)+1;
                    --
                    v_precio :=  v_precio /v_auxiliar;
                    --
                    v_millar := 0;
                    v_centenas := 0;
                    v_unidad := 0;
                    --
                    --Calculos para los precios por unidad, centena y millar
                    --
                    v_millar := ((dato.tmpidexc_costo * 18.00 )/100.00) + dato.tmpidexc_costo;
                    --
                    v_centenas := ((dato.tmpidexc_costo * 28.00 )/100.00) + dato.tmpidexc_costo;
                    --
                    v_unidad := ((dato.tmpidexc_costo * 35.00 )/100.00) + dato.tmpidexc_costo;
                    --
                    v_millar := (( v_millar * v_iva_precio )/100.00) + v_millar;
                    --
                    v_centenas := (( v_centenas * v_iva_precio )/100.00) + v_centenas;
                    --
                    v_unidad := (( v_unidad * v_iva_precio )/100.00) + v_unidad;
                    --
                    v_modulo_pre_mayor := v_unidad % 100;
                    v_faltante :=  100 -  v_modulo_pre_mayor;
                    v_unidad := v_unidad + v_faltante;
                    --
                    v_modulo_pre_mayor := v_centenas % 100;
                    v_faltante :=  100 -  v_modulo_pre_mayor;
                    v_centenas := v_centenas + v_faltante;
                    --
                    v_modulo_pre_mayor := v_millar % 100;
                    v_faltante :=  100 -  v_modulo_pre_mayor;
                    v_millar := v_millar + v_faltante;
                    --
                END IF;
                --
                --Insercion del precio
                --
                INSERT INTO in_tprpr(
                            prpr_dska, prpr_precio, prpr_tius_crea, prpr_tius_update, 
                            prpr_estado, prpr_sede, prpr_preu,prpr_prec,prpr_prem)
                    VALUES (dato.tmpidexc_dska, v_precio , 1, 1, 
                            'A', 2,v_unidad,v_centenas,v_millar);
            --
            END IF;
            --
            DELETE FROM co_ttem_mvco
            WHERE tem_mvco_trans = v_sec_cont
            ;
        --
        END LOOP;
        --
        RETURN 'OK';
        --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_INSERTA_PROD_MASIVO  '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';