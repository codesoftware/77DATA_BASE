--
-- Funcion con la cual se crea la cancelacion de una factura 
--

CREATE OR REPLACE FUNCTION FA_CANCELA_FACTURA (  
                                p_tius              int,
                                p_fact              int,
                            out p_fact_new          int,
                            out p_respuesta         varchar,
                            out p_excepcion         varchar
                         )AS $$
    DECLARE
        --
        --Valida el estado de la factura
        --
        c_valida_fact CURSOR FOR
        SELECT fact_estado 
          FROM fa_tfact
         WHERE fact_fact = p_fact
         ;
        --
        --Obtengo el id de facturacion
        --
        c_fact_fact CURSOR FOR
        SELECT coalesce(max(fact_fact),0) + 1
          FROM fa_tfact     
        ;
        --
        v_fact_fact         INT := 0;
        v_fact_estado       VARCHAR := '';
        --
        --
        --Cursor el cual sirve para obtener el id temporal de transaccion para la tabla temporal
        --de movimientos contables
        --
        c_sec_tem_mvco CURSOR FOR
        SELECT nextval('co_temp_movi_contables') 
        ;
        --
        v_idTrans_con           INT := 0;
        --
    BEGIN
        --
        p_respuesta := '';
        p_excepcion := 'SIN EXCEPCION';
        --
        OPEN c_valida_fact;
        FETCH c_valida_fact INTO v_fact_estado;
        CLOSE c_valida_fact;
        --
        IF v_fact_estado = 'C' THEN
            --
            p_respuesta := 'La factura se encuentra cancelada por tal motivo no se puede cancelar de nuevo';
            --
        ELSE
            --
            --Inicio generacion de una Factura
            --
            OPEN c_fact_fact;
            FETCH c_fact_fact INTO p_fact_new;
            CLOSE c_fact_fact;
            --
            INSERT INTO fa_tfact(   fact_fact        , fact_tius        , fact_fec_cierre  , 
                            fact_clien       , fact_vlr_total   , fact_vlr_iva     , fact_tipo_pago   , 
                            fact_id_voucher  , fact_cometarios  , fact_estado      , fact_naturaleza  , 
                            fact_devolucion  , fact_original    , fact_vlr_dcto    , fact_vlr_efectivo, 
                            fact_vlr_tarjeta , fact_cierre      , fact_sede        ) (
            SELECT p_fact_new       , p_tius           , fact_fec_cierre  , 
                   fact_clien       , fact_vlr_total   , fact_vlr_iva     , fact_tipo_pago   , 
                   fact_id_voucher  , fact_cometarios  , 'P'              , 'I'  , 
                   'S'              , 1                , fact_vlr_dcto    , fact_vlr_efectivo, 
                   fact_vlr_tarjeta , fact_cierre      , fact_sede        
              FROM fa_tfact
             WHERE fact_fact = p_fact)
            ;
            --
            UPDATE fa_tfact
               SET fact_estado = 'C'
             WHERE fact_fact = p_fact
             ;
            --
            --Realizamos el reverso de los productos
            --
            --Realizamos el reverso del detalle de los productos de facturacion
            --
            INSERT INTO fa_tdtpr(
                            dtpr_dska,          dtpr_fact,          dtpr_num_prod,      dtpr_cant, 
                            dtpr_vlr_pr_tot,    dtpr_vlr_uni_prod,  dtpr_vlr_iva_tot,   dtpr_vlr_iva_uni, 
                            dtpr_vlr_venta_tot, dtpr_vlr_venta_uni, dtpr_vlr_total,     dtpr_desc, 
                            dtpr_con_desc,      dtpr_valor_desc,    dtpr_estado,        dtpr_kapr, 
                            dtpr_dev_kapr, dtpr_utilidad)(
            SELECT  dtpr_dska,          p_fact_new,         dtpr_num_prod,      dtpr_cant, 
                    dtpr_vlr_pr_tot,    dtpr_vlr_uni_prod,  dtpr_vlr_iva_tot,   dtpr_vlr_iva_uni, 
                    dtpr_vlr_venta_tot, dtpr_vlr_venta_uni, dtpr_vlr_total,     dtpr_desc, 
                    dtpr_con_desc,      dtpr_valor_desc,    dtpr_estado,        dtpr_kapr, 
                    dtpr_dev_kapr,      dtpr_utilidad
             FROM fa_tdtpr
            WHERE dtpr_fact = p_fact)
            ;
            --
            --Realizamos el reverso de los movimientos contables
            --
            OPEN c_sec_tem_mvco;
            FETCH c_sec_tem_mvco INTO v_idTrans_con;
            CLOSE c_sec_tem_mvco;
            --
            INSERT INTO co_tmvco(mvco_trans, 
                                 mvco_sbcu, mvco_naturaleza, 
                                 mvco_tido, mvco_valor, 
                                 mvco_lladetalle, mvco_id_llave, 
                                 mvco_tercero, mvco_tipo)(
                                 SELECT v_idTrans_con, 
                                        mvco_sbcu, case WHEN UPPER(mvco_naturaleza) = 'C' THEN 'D' ELSE 'C' END, 
                                        mvco_tido, mvco_valor, 
                                        mvco_lladetalle, mvco_id_llave, 
                                        mvco_tercero, mvco_tipo
                                   FROM co_tmvco
                                  WHERE mvco_lladetalle = 'fact'
                                    AND mvco_id_llave = p_fact
                                 )
                                 ;
            --
            p_respuesta := 'Ok';
            --
        END IF;
        --
    EXCEPTION WHEN OTHERS THEN
         p_excepcion := 'Error '|| sqlerrm;
    END;
$$ LANGUAGE 'plpgsql';