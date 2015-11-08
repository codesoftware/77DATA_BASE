--
-- Funcion encargada de realizar el ingreso al inventario y la contabilizacion de los productos ya existentes en el sistema
--
CREATE OR REPLACE FUNCTION IN_ADICIONA_PROD_EXIS (  
                                                        p_dska_dska         INT,
                                                        p_cantidad          INT,
                                                        p_costo             NUMERIC(15,6),
                                                        p_sede              INT,
                                                        p_tius_tius         INT,
                                                        p_idTrans           INT
                                                    ) RETURNS VARCHAR  AS $$
    DECLARE
    
    v_rta_insrt_kar   VARCHAR(500) := '';
    
    c_mvIn_compra CURSOR FOR
    SELECT mvin_mvin
      FROM in_tmvin
     WHERE mvin_compra = 'S'
     ;
    v_mvin_mvin            INT;
    v_valor_iva            NUMERIC(15,6) :=0;
    v_creditos             NUMERIC(15,6) :=0;
    v_debitos              NUMERIC(15,6) :=0;
    v_cred_usu             NUMERIC(15,6) :=0;
    v_debi_usu             NUMERIC(15,6) :=0;
    v_debi_para            NUMERIC(15,6) :=0;
    v_cred_para            NUMERIC(15,6) :=0;
    --
    --Cursor en el cual se obtiene el valor de todos los porcentajes calculados y el valor de estos
    --
    c_deb_param CURSOR FOR
        SELECT (p_costo * (select coalesce(sum(sbft_porcentaje),0) sumaPorc
          FROM co_ttido, co_tsbft
         WHERE tido_nombre = 'FACTCOMPRA'
           AND tido_tido = sbft_tido
           AND sbft_naturaleza = 'D')/100) valorPorcentajes
        ;
    --
    c_cre_param CURSOR FOR
        SELECT (p_costo * (select coalesce(sum(sbft_porcentaje),0) sumaPorc
          FROM co_ttido, co_tsbft
         WHERE tido_nombre = 'FACTCOMPRA'
           AND tido_tido = sbft_tido
           AND sbft_naturaleza = 'C')/100) valorPorcentajes
        ;
    --
    --Obtiene debitos ingresados por el usuario
    --
    c_deb_usua CURSOR FOR
    SELECT coalesce(sum(cast(tem_mvco_valor as numeric)),0)
      FROM co_ttem_mvco
     WHERE tem_mvco_naturaleza = 'D'
       AND tem_mvco_trans = p_idTrans
       ;
    --
    --Obtiene creditos por el usuario por el usuario
    --
    c_cre_usua CURSOR FOR
    SELECT coalesce(sum(cast(tem_mvco_valor as numeric)),0)
      FROM co_ttem_mvco
     WHERE tem_mvco_naturaleza = 'C'
       AND tem_mvco_trans = p_idTrans
       ;
    --
    --Cursor para obtener el codigo de la subcuenta
    --
    c_sbcu_prod CURSOR FOR
    SELECT sbcu_codigo
      FROM in_tdska, co_tsbcu
      WHERE sbcu_sbcu = dska_sbcu
       AND dska_dska = p_dska_dska
       ;
     --
     v_sbcu_prod        VARCHAR(50)     := '';
     v_iva              NUMERIC(15,5)   := 0;
     --
     -- Obtiene el identificador del tipo de documento 
     --
     c_id_ttido CURSOR FOR
     SELECT tido_tido
       FROM co_ttido
      WHERE upper(tido_nombre) = 'FACTCOMPRA'
     ; 
     --
     v_tipoDocumento     integer := 0;
     --
     v_kapr_kapr         integer := 0;
     --
     -- Cursor con el cual encuentro el id del movimiento de inventario
     --
     c_kapr_kapr CURSOR (vc_expresion varchar) IS
     SELECT cast(kapr_kapr as int)
       FROM (
            SELECT regexp_split_to_table(vc_expresion, '-') kapr_kapr
            offset 1) as tabla
     ;
     --
     --Cursor necesario para la realizacion de los movimientos contables
     --
     c_movi_cont CURSOR FOR
     SELECT sbcu_sbcu,cast(tem_mvco_valor as numeric) valor,tem_mvco_naturaleza natu
       FROM co_ttem_mvco, co_tsbcu
      WHERE tem_mvco_sbcu = sbcu_codigo
        AND tem_mvco_trans = p_idTrans
        ;
    --
    --Cursor en el cual obtenemos el porcentaje de iva parametrizado para las compras
    --
    c_iva_compras CURSOR FOR
    SELECT sbft_porcentaje
      FROM co_tsbft
     WHERE SBFT_SBCU_CODIGO = '240801'
       AND sbft_tido = 1
       ;
    --
    v_iva_compra            NUMERIC(15,6) :=0;
    --
    BEGIN
        --
        OPEN c_mvIn_compra;
        FETCH c_mvIn_compra INTO v_mvin_mvin;
        CLOSE c_mvIn_compra;
        --
        IF v_mvin_mvin IS NULL THEN
            --
            RAISE EXCEPTION 'No existe Movimiento de Inventario Parametrizado para las compras de mercancia';
            --
        END IF;
        
    
        v_rta_insrt_kar := IN_FINSERTA_PROD_KARDEX(p_dska_dska,
                                                   v_mvin_mvin,
                                                   p_tius_tius,
                                                   p_cantidad,
                                                   p_costo,
                                                   p_sede                                                   
                                                   );
        IF upper(v_rta_insrt_kar) LIKE '%OK%' THEN
            --
            OPEN c_kapr_kapr(v_rta_insrt_kar);
            FETCH c_kapr_kapr INTO v_kapr_kapr;
            CLOSE c_kapr_kapr;
            --
            --
            --
            OPEN c_deb_param;
            FETCH c_deb_param INTO v_debi_para;
            CLOSE c_deb_param;
            --
            OPEN c_cre_param;
            FETCH c_cre_param INTO v_cred_para;
            CLOSE c_cre_param;
            --
            OPEN c_deb_usua;
            FETCH c_deb_usua INTO v_debi_usu;
            CLOSE c_deb_usua;
            --
            OPEN c_cre_usua;
            FETCH c_cre_usua INTO v_cred_usu;
            CLOSE c_cre_usua;
            --
            --sumamos todos los creditos y los debitos incluyendo el costo
            -- que ira a la subcuenta del producto ingresado
            --
            v_creditos := v_cred_para + v_cred_usu ;
            --
            v_debitos := v_debi_para + v_debi_usu + p_costo;
            --
            IF v_creditos = v_debitos THEN 
                --
                OPEN c_sbcu_prod;
                FETCH c_sbcu_prod INTO v_sbcu_prod;
                CLOSE c_sbcu_prod;                
                --
                IF v_sbcu_prod is not null THEN
                    --
                    --Insercion de la cuenta de inventario 
                    --
                    INSERT INTO co_ttem_mvco(
                                            tem_mvco_trans, 
                                            tem_mvco_sbcu, 
                                            tem_mvco_valor, 
                                            tem_mvco_naturaleza)
                    VALUES (p_idTrans,
                            v_sbcu_prod, 
                            p_costo, 
                            'D')
                            ;
                    OPEN c_iva_compras;
                    FETCH c_iva_compras into v_iva_compra;
                    CLOSE c_iva_compras;
                    --
                    --Insercion del iva
                    --
                    v_iva := (p_costo*v_iva_compra)/100;
                    --
                    INSERT INTO co_ttem_mvco(
                                            tem_mvco_trans, 
                                            tem_mvco_sbcu, 
                                            tem_mvco_valor, 
                                            tem_mvco_naturaleza)
                    VALUES (p_idTrans,
                            '240801', 
                            v_iva, 
                            'D');
                    --
                    OPEN c_id_ttido;
                    FETCH c_id_ttido INTO v_tipoDocumento;
                    CLOSE c_id_ttido;        
                    --
                    FOR movi IN c_movi_cont
                    LOOP
                        --
                        INSERT INTO co_tmvco(mvco_trans, 
                                     mvco_sbcu, mvco_naturaleza, 
                                     mvco_tido, mvco_valor, 
                                     mvco_lladetalle, mvco_id_llave, 
                                     mvco_tercero, mvco_tipo)
                                VALUES ( p_idTrans, 
                                      movi.sbcu_sbcu , movi.natu, 
                                      v_tipoDocumento, movi.valor,
                                      'mvin', v_kapr_kapr,
                                      1, 2);
                        --
                    END LOOP;                    
                    --
                ELSE
                    --
                    RAISE EXCEPTION 'El producto no tiene una subcuenta asociada por favor comuniquese con el administrador del sistema';
                    --
                END IF;
            ELSE
                --
                RAISE EXCEPTION 'La suma de los debitos: % y los creditos: % no coinciden.', v_creditos,  v_debitos;
                --
            END IF;
            
            
        ELSE
            --
            RAISE EXCEPTION 'Error al realizar el movimiento de inventario: % ',v_rta_insrt_kar ;
            --
        END IF;
        --
        RETURN 'Ok';
        --
    EXCEPTION WHEN OTHERS THEN
         RETURN 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';