--
-- Funcion con la cual se crea la cancelacion de una factura 
--

CREATE OR REPLACE FUNCTION FA_INSERTA_PROD_MASIVO()RETURNS VARCHAR  AS $$
    DECLARE
       --
       --Cursor con el cual obtengo los datos que deseo ingresar las existencias
       --
       c_datosExcel CURSOR FOR 
       SELECT tmpidexc_dska, 1 sede, tmpidexc_costo, tmpidexc_existencia
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
        v_sec_cont      INT :=0;
        v_valRegistro   varchar(200) := '';  
        --
        v_precio        NUMERIC(50,6) := 0;
        --
        v_modulo        NUMERIC(50,6) := 0;
        --
        v_faltante      NUMERIC(50,6) := 0;
        --
        v_valorMvto     NUMERIC(50,6) := 0;
        --
        v_costo_total   NUMERIC(15,6) := 0;
        --
        v_porc_precio   numeric(15,6) := 0;
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
                RAISE EXCEPTION 'Error al realizar el ingreso de existencias masivas ', v_valRegistro;
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
                --Insercion del precio
                --
                INSERT INTO in_tprpr(
                            prpr_dska, prpr_precio, prpr_tius_crea, prpr_tius_update, 
                            prpr_estado, prpr_sede)
                    VALUES (dato.tmpidexc_dska, v_precio , 1, 1, 
                            'A', 1);
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