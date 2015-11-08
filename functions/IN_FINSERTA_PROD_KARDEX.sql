-- Funcion la cual se encargara de ingresar los detalles del inventario de cada producto

CREATE OR REPLACE FUNCTION IN_FINSERTA_PROD_KARDEX (  
                                                    p_id_producto     INTEGER ,         -- Identificador unico del producto (DSKA_DSKA) al cual se le realizara el movimiento de inventario
                                                    p_id_moviInv      INTEGER ,         -- Identificador unico del movimiento de inventario
                                                    p_id_tius         INTEGER ,         -- Identificador del usuario que esta realizando la insercion
                                                    p_numProd         INTEGER ,         -- Numero de productos que van a ingresar al inventario
                                                    p_costoTotal      NUMERIC(50,6),     -- Costo total de todos los productos que ingresaron al inventario
                                                    p_sede            INTEGER
                                    ) RETURNS VARCHAR AS $$
      DECLARE 
      
      v_natMov              varchar(1) := '';    -- Naturaleza del movimiento que se va ha realizar
      v_valorUnitario       NUMERIC(50,6) := 0;  -- Valor unitario del producto antes del movimiento
      v_costTotProdOld      NUMERIC(50,6) := 0;  -- Costo total de todos los productos existentes en el inventario antes del inventario
      v_costTotProdNew      NUMERIC(50,6) := 0;  -- Costo total de todos los productos existentes en el inventario despues del inventario
      v_consecutivo         INTEGER := 0;        -- Nuevo consecutivo del movimiento de inventario
      v_cantSaldoAnt        INTEGER := 0;        -- Cantidad de unidades antes del movimiento de inventario
      v_cantSaldoSig        INTEGER := 0;        -- Cantidad de unidades despues del movimiento
      v_uniPonderado        NUMERIC(50,6) := 0;  --Valor ponderado del producto respecto a los anteriores movimientos de inventario
      
      v_costUniSalAnt       NUMERIC(50,6) := 0;  -- Costo promedio de la unidad antes del movimiento
      v_costoTotalMovi      NUMERIC(50,6) := 0;  -- Costo total del egreso calculado con el costo de las
      
      c_movInv_nat CURSOR FOR
      SELECT mvin_natu
        FROM in_tmvin
       WHERE mvin_mvin = p_id_moviInv
       ;
       
       c_sig_serie CURSOR FOR
       select max(kapr_cons_pro) + 1 
        from in_tkapr
        where kapr_dska = p_id_producto
        ;
        
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
       
       v_kapr_kapr          INTEGER:=0;
      
      BEGIN
      
      OPEN c_movInv_nat;
      FETCH c_movInv_nat INTO v_natMov;
      CLOSE c_movInv_nat;
      
      OPEN c_sig_serie;
      FETCH c_sig_serie INTO v_consecutivo;
      CLOSE c_sig_serie;
      
      OPEN c_ultReg(v_consecutivo-1);
      FETCH c_ultReg INTO v_cantSaldoAnt, v_costTotProdOld, v_costUniSalAnt;
      CLOSE c_ultReg;
      
      IF v_natMov = 'I' THEN
        
        v_valorUnitario := p_costoTotal / p_numProd;
        
        v_cantSaldoSig = v_cantSaldoAnt + p_numProd;
        
        v_costTotProdNew = v_costTotProdOld + p_costoTotal;
        
        v_uniPonderado = v_costTotProdNew / v_cantSaldoSig;
        
        v_costoTotalMovi = p_costoTotal;
        
      ELSIF v_natMov = 'E' THEN
        
        v_cantSaldoSig = v_cantSaldoAnt - p_numProd;
        
        IF v_cantSaldoSig = 0 THEN 
            --
            v_valorUnitario = v_costUniSalAnt; 
        
            v_costoTotalMovi = v_valorUnitario * p_numProd;
        
            v_costTotProdNew = 0;

            v_uniPonderado = 0;
            --
        ELSE 
            --
            v_valorUnitario = v_costUniSalAnt; 
        
            v_costoTotalMovi = v_valorUnitario * p_numProd;
        
            v_costTotProdNew = v_costTotProdOld - v_costoTotalMovi;

            v_uniPonderado = v_costTotProdNew / v_cantSaldoSig;
            -- 
        END IF;
        
      END IF;
      
      OPEN c_kapr_kapr;
      FETCH c_kapr_kapr INTO v_kapr_kapr;
      CLOSE c_kapr_kapr;
      
      INSERT INTO in_tkapr(
            kapr_kapr,kapr_cons_pro, kapr_dska, 
            kapr_mvin, kapr_cant_mvto, kapr_cost_mvto_uni, 
            kapr_cost_mvto_tot, kapr_cost_saldo_uni, kapr_cost_saldo_tot, 
            kapr_cant_saldo, kapr_tius, kapr_sede)
      VALUES(
            v_kapr_kapr, v_consecutivo, p_id_producto, 
            p_id_moviInv, p_numProd, v_valorUnitario, 
            v_costoTotalMovi, v_uniPonderado, v_costTotProdNew, 
            v_cantSaldoSig, p_id_tius,p_sede);
            
        RETURN 'OK-'||v_kapr_kapr;
      
        EXCEPTION WHEN OTHERS THEN
               RETURN 'ERR IN_FINSERTA_PROD_KARDEX ' || ' Error postgres: ' || SQLERRM;
       END;
$$ LANGUAGE 'plpgsql';