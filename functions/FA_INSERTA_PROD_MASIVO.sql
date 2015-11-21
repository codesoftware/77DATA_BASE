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
        --
        c_sec_contabilidad CURSOR IS
        SELECT CAST(nextval('co_temp_tran_factu_sec') AS INT)
        ;
        --
        v_sec_cont      INT :=0;
        v_valRegistro   varchar(200) := '';  
        --
    BEGIN
        --
        FOR dato IN c_datosExcel LOOP
        --
            OPEN c_sec_contabilidad;
            FETCH c_sec_contabilidad INTO v_sec_cont;
            CLOSE c_sec_contabilidad;
            --
            INSERT INTO co_ttem_mvco(
                            tem_mvco_trans, tem_mvco_sbcu, tem_mvco_valor, tem_mvco_naturaleza)
                VALUES (v_sec_cont, '110501', dato.tmpidexc_costo ,'C');
            --
            v_valRegistro := IN_ADICIONA_PROD_EXIS(dato.tmpidexc_dska, cast(dato.tmpidexc_existencia as INT) ,dato.tmpidexc_costo,dato.sede,1,v_sec_cont);
            --
            IF UPPER(TRIM(v_valRegistro)) NOT LIKE '%OK%' THEN
                --
                RAISE EXCEPTION 'Error al realizar el ingreso de existencias masivas ', v_valRegistro;
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