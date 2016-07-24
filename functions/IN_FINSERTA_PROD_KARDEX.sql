-- Funcion la cual se encargara de ingresar los detalles del inventario de cada producto

CREATE OR REPLACE FUNCTION IN_FINSERTA_PROD_KARDEX (  
                                                    p_id_producto     bigint ,         -- Identificador unico del producto (DSKA_DSKA) al cual se le realizara el movimiento de inventario
                                                    p_id_moviInv      bigint ,         -- Identificador unico del movimiento de inventario
                                                    p_id_tius         bigint ,         -- Identificador del usuario que esta realizando la insercion
                                                    p_numProd         bigint ,         -- Numero de productos que van a ingresar al inventario
                                                    p_costoTotal      NUMERIC(1000,10),     -- Costo total de todos los productos que ingresaron al inventario
                                                    p_sede            bigint
                                    ) RETURNS VARCHAR AS $$
    DECLARE 
        --
        v_natMov              varchar(1) := '';    -- Naturaleza del movimiento que se va ha realizar
        v_valorUnitario       NUMERIC(1000,10) := 0;  -- Valor unitario del producto antes del movimiento
        v_costTotProdOld      NUMERIC(1000,10) := 0;  -- Costo total de todos los productos existentes en el inventario antes del inventario
        v_costTotProdNew      NUMERIC(1000,10) := 0;  -- Costo total de todos los productos existentes en el inventario despues del inventario
        v_consecutivo         bigint := 0;        -- Nuevo consecutivo del movimiento de inventario
        v_cantSaldoAnt        bigint := 0;        -- Cantidad de unidades antes del movimiento de inventario
        v_cantSaldoSig        bigint := 0;        -- Cantidad de unidades despues del movimiento
        v_uniPonderado        NUMERIC(1000,10) := 0;  --Valor ponderado del producto respecto a los anteriores movimientos de inventario
        --
        v_costUniSalAnt       NUMERIC(1000,10) := 0;  -- Costo promedio de la unidad antes del movimiento
        v_costoTotalMovi      NUMERIC(1000,10) := 0;  -- Costo total del egreso calculado con el costo de las
        --
        c_movInv_nat CURSOR FOR
        SELECT mvin_natu
        FROM in_tmvin
        WHERE mvin_mvin = p_id_moviInv
        ;
        --
        c_sig_serie CURSOR FOR
        select coalesce(max(kapr_cons_pro),0) + 1 
        from in_tkapr
        where kapr_dska = p_id_producto
        ;
        --
        c_ultReg CURSOR (consecId INTEGER) IS
        SELECT kapr_cant_saldo, kapr_cost_saldo_tot, kapr_cost_saldo_uni
        FROM in_tkapr
        WHERE kapr_dska = p_id_producto
        AND kapr_cons_pro = consecId
        ;
        --
        -- Encuentra la llave primaria de la tabla
        --
        c_kapr_kapr CURSOR FOR
        SELECT coalesce(max(kapr_kapr),0)+ 1 as kapr_kapr
         FROM in_tkapr
         ;
        --
        v_kapr_kapr          bigint:=0;
        --
        --Desarrollo para el control de las existencias en las sedes
        --
        --Cursor el cual valida si exite el producto en los consolidados de existencias
        c_exist_cepr CURSOR FOR
        SELECT count(*)
          FROM in_tcepr
         WHERE cepr_dska = p_id_producto
         ;
        --
        v_exist_cepr    int := 0;
        --
        --
        --Cursor con el cual evaluo si existe un producto en la tabla consolidada de existencias por sede
        --
        c_ex_prod_sede CURSOR FOR
        SELECT eprs_eprs
          FROM in_teprs
         WHERE eprs_dska = p_id_producto
           AND eprs_sede = p_sede
           ;
        --
        c_exist_prod_sede CURSOR FOR
        SELECT eprs_existencia
          FROM in_teprs
         WHERE eprs_dska = p_id_producto
           AND eprs_sede = p_sede
           ;
        --
        v_existencia_sede           bigint:=0;
        --
        v_total_sede                bigint:=0;
        --
        v_ext_pr_sede   bigint := 0;
        v_natuMovi      varchar(2) := '';
        --
        v_mvto_cant_total   bigint:= 0;
        --
    BEGIN
        --
        OPEN c_movInv_nat;
        FETCH c_movInv_nat INTO v_natMov;
        CLOSE c_movInv_nat;
        --
        OPEN c_sig_serie;
        FETCH c_sig_serie INTO v_consecutivo;
        CLOSE c_sig_serie;
        --  
        OPEN c_ultReg(v_consecutivo-1);
        FETCH c_ultReg INTO v_cantSaldoAnt, v_costTotProdOld, v_costUniSalAnt;
        CLOSE c_ultReg;
        --  
        IF v_natMov = 'I' THEN
            --
            v_valorUnitario := p_costoTotal / p_numProd;
            --
            v_cantSaldoSig = v_cantSaldoAnt + p_numProd;
            --
            v_costTotProdNew = v_costTotProdOld + p_costoTotal;
            --
            v_uniPonderado = v_costTotProdNew / v_cantSaldoSig;
            --
            v_costoTotalMovi = p_costoTotal;
            --
        ELSIF v_natMov = 'E' THEN
            --
            v_cantSaldoSig = v_cantSaldoAnt - p_numProd;
            --
            IF v_cantSaldoSig = 0 THEN 
                --
                v_valorUnitario = v_costUniSalAnt; 
                --
                v_costoTotalMovi = v_valorUnitario * p_numProd;
                --
                v_costTotProdNew = 0;
                --
                v_uniPonderado = 0;
                --
            ELSE 
                --
                v_valorUnitario = v_costUniSalAnt; 
                --
                v_costoTotalMovi = v_valorUnitario * p_numProd;
                --
                v_costTotProdNew = v_costTotProdOld - v_costoTotalMovi;
                --
                v_uniPonderado = v_costTotProdNew / v_cantSaldoSig;
                -- 
            END IF;
            --
        END IF;
        --
        OPEN c_kapr_kapr;
        FETCH c_kapr_kapr INTO v_kapr_kapr;
        CLOSE c_kapr_kapr;
        --  
        INSERT INTO in_tkapr(
              kapr_kapr,            kapr_cons_pro,          kapr_dska, 
              kapr_mvin,            kapr_cant_mvto,         kapr_cost_mvto_uni, 
              kapr_cost_mvto_tot,   kapr_cost_saldo_uni,    kapr_cost_saldo_tot, 
              kapr_cant_saldo,      kapr_tius,              kapr_sede)
        VALUES(
              v_kapr_kapr,          v_consecutivo,          p_id_producto, 
              p_id_moviInv,         p_numProd,              v_valorUnitario, 
              v_costoTotalMovi,     coalesce(v_uniPonderado,v_valorUnitario), coalesce(v_costTotProdNew,v_costoTotalMovi), 
              coalesce(v_cantSaldoSig,p_numProd), p_id_tius,p_sede);
        --
        --Desarrollo para controlar las existencias en las sedes
        --
        --
        OPEN c_exist_cepr;
        FETCH c_exist_cepr INTO v_exist_cepr;
        CLOSE c_exist_cepr;
        --
        IF v_exist_cepr = 0 THEN
        --
            INSERT INTO in_tcepr(
                        cepr_dska, cepr_existencia, cepr_promedio_uni, cepr_promedio_total)
            VALUES ( p_id_producto, coalesce(v_cantSaldoSig,p_numProd), coalesce(v_uniPonderado,v_valorUnitario), coalesce(v_costTotProdNew,v_costoTotalMovi));
        --
        ELSE
        --
            UPDATE in_tcepr
               SET  cepr_existencia         = coalesce(v_cantSaldoSig,p_numProd)            ,
                    cepr_promedio_uni       = coalesce(v_uniPonderado,v_valorUnitario)      ,
                    cepr_promedio_total     = coalesce(v_costTotProdNew,v_costoTotalMovi)
             WHERE cepr_dska = p_id_producto
             ;
        --
        END IF;
        --
        OPEN c_ex_prod_sede;
        FETCH c_ex_prod_sede INTO v_ext_pr_sede;
        CLOSE c_ex_prod_sede;
        --
        IF v_ext_pr_sede is null THEN 
            --
            INSERT INTO IN_TEPRS(eprs_dska,eprs_existencia,eprs_sede)
            VALUES(p_id_producto, p_numProd,p_sede);
            --
        ELSE
            --
            IF upper(v_natMov) = 'E' then
                --
                v_mvto_cant_total := p_numProd * (-1);
                --
            END IF;
            --
            OPEN c_exist_prod_sede;
            FETCH c_exist_prod_sede into v_existencia_sede;
            CLOSE c_exist_prod_sede;
            --
            v_total_sede := v_existencia_sede +  v_mvto_cant_total;
            --
            UPDATE IN_TEPRS
               SET eprs_existencia = v_total_sede
             WHERE eprs_eprs = v_ext_pr_sede
               AND eprs_dska = p_numProd
             ;
        END IF;
        --
    RETURN 'OK-'||v_kapr_kapr;
    --
    EXCEPTION WHEN OTHERS THEN
           RETURN 'ERR IN_FINSERTA_PROD_KARDEX ' || ' Error postgres: ' || SQLERRM;
       END;
$$ LANGUAGE 'plpgsql';