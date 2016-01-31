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
        v_valida                    varchar(4000):= '';
        --
    BEGIN
        --
        FOR dato IN c_datosExcel LOOP
        --  
            IF dato.tmpidexc_existencia <> 0 THEN
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
                DELETE FROM co_ttem_mvco
                WHERE tem_mvco_trans = v_sec_cont
                ;
                --
                IF UPPER(TRIM(v_valRegistro)) NOT LIKE '%OK%' THEN
                    --
                    RAISE EXCEPTION 'Error al realizar el ingreso de existencias masivas %', v_valRegistro;
                    --
                ELSE
                    --
                    v_valida := IN_PARA_PRECIO_PROD_PORCE(1,dato.sede,dato.tmpidexc_dska, 0);
                    --
                    IF upper(v_valida) NOT LIKE '%OK%' THEN
                        --
                        RAISE EXCEPTION ' % ',v_valida;
                        --
                    END IF;
                    --
                END IF;
                --
            END IF;
        --
        commit;
        --
        END LOOP;
        --
        RETURN 'OK';
        --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error FA_INSERTA_PROD_MASIVO  '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';