-- Funcion encargada de insertar en la base de datos un producto por primera vez

CREATE OR REPLACE FUNCTION US_FINSERT_NUEVO_PROD (    p_ref        INT          ,       -- Referencia del producto
                                                      p_cod        VARCHAR(10)  ,       -- Codigo Unico que identificara el producto para la empresa
                                                      p_nom_prod   VARCHAR(50)  ,       -- Nombre del producto
                                                      p_desc       VARCHAR(50)  ,       -- Pequeña descripción del producto
                                                      p_iva        VARCHAR(1)   ,       -- Identifica si el producto es gravado con iva
                                                      p_porc_iva   INTEGER      ,       -- Porcentaje con el cual se gravara el producto
                                                      p_marca      INTEGER      ,       -- Marca del producto el cual se 
                                                      p_cant       INTEGER      ,       -- Cantidad de productos que se desean inventariar
                                                      p_cost       NUMERIC(50,6),       -- Costo del producto por unidad
                                                      p_usua       VARCHAR(50)  ,       -- Usuario el cual registra el inventario
                                                      p_sede       INTEGER      ,       -- Sede a la cual ingresa el producto al sitema
                                                      p_cate       INTEGER      ,       -- Categoria a la cual pertenece el producto
                                                      p_runic      VARCHAR(200) ,       -- Valor el cual es un registro unico para los productos si aplica
                                                      p_fecVen     DATE         ,       -- Fecha de vencimiento del producto si aplica
                                                      p_idTrans    INTEGER      ,       -- Id Utilizado para las transacciones de movimientos contables
                                                      p_prov       INTEGER              -- Id del proveedor con el cual se adquirio el producto
                                    ) RETURNS VARCHAR AS $$
      DECLARE 
      
         v_cod_prod     varchar(1);
         v_tius_tius    integer;
         rta            varchar(10) := 'Err';
         v_cost_tot     Numeric(50,6) := 0;         
         
         c_dska_dska CURSOR FOR
         SELECT coalesce(max(dska_dska),0)+ 1 as dska_dska
           FROM in_tdska
           ;
        v_dska_dska     INTEGER := 0;
        
        c_kapr_kapr CURSOR FOR
         SELECT coalesce(max(kapr_kapr),0)+ 1 as kapr_kapr
           FROM in_tkapr
           ;
        --
        c_mvin_inicial CURSOR FOR
        SELECT mvin_mvin, count(1) contador
         FROM in_tmvin
        WHERE mvin_inicial = 'S'
        GROUP BY mvin_mvin
        ;
        --
        c_valor_unidad CURSOR FOR
        select p_cost/p_cant::numeric(15,5) vlr_Unidad
        ;
        --
        c_codigo CURSOR FOR
        SELECT '1-' || coalesce(count(*), 0 )+1 AS Id
          FROM in_tdska 
          ;
         --
         --Obtiene el valor de la secuencia para la insecion de subcuentas
         --
        c_sec_sbcu CURSOR FOR
        SELECT nextval('co_tsbcu_sbcu_sbcu_seq');
        
        --
        v_kapr_kapr     INTEGER := 0;
        v_cont_mvin     INTEGER := 0;       -- cuenta cuantos movimientos de inventario inicial existen
        v_mvin_inicial  INTEGER := 0;       -- Obtiene el identificador del movimiento inicial de inventario 
        v_codigo        varchar(100) := '';
        v_codigosbcu    varchar(50) :='';
        v_sbcu_sbcu     INTEGER := 0;        --Id de la futura subcuenta
        v_costo_unidad  numeric(15,5) := 0;
        --
        --Contabilidad
        --
        --
        --Verifica si existen subcuentas parametrizadas para el documento factura de compra
        --
        c_cn_sbcu_para CURSOR FOR
        SELECT count(*)
          FROM co_ttido,co_tsbft
         WHERE upper(tido_nombre) = 'FACTCOMPRA'
           AND sbft_tido = tido_tido
        ;
        --
        -- Obtiene el identificador del tipo de documento 
        --
        c_id_ttido CURSOR FOR
        SELECT tido_tido
          FROM co_ttido
         WHERE upper(tido_nombre) = 'FACTCOMPRA'
         ;
        --
        --Obtiene los datos necesarios para la contabilizacion de una factura de compra
        --
        c_tido_sbcu CURSOR FOR
        SELECT sbft_sbcu_codigo , sbft_naturaleza,sbft_porcentaje
          FROM co_ttido,co_tsbft,co_tsbcu
         WHERE upper(tido_nombre) = 'FACTCOMPRA'
           AND sbft_tido = tido_tido 
          AND sbcu_codigo = sbft_sbcu_codigo
        ;
        
        v_creditos          numeric(15,5) := 0;
        v_debitos           numeric(15,5) := 0;
        v_cre_usu           numeric(15,5) := 0;
        v_deb_usu           numeric(15,5) := 0;
        v_tipoDocumento     integer := 0;
        --
        --Obtiene debtitos parametrizados en el sistema
        --
        c_deb_param CURSOR FOR
        SELECT (p_cost * (select coalesce(sum(sbft_porcentaje),0) sumaPorc
          FROM co_ttido, co_tsbft
         WHERE tido_nombre = 'FACTCOMPRA'
           AND tido_tido = sbft_tido
           AND sbft_naturaleza = 'D')/100) valorPorcentajes
        ;
        --
        --Obtiene creditos parametrizados en el sistema
        --
        c_cre_param CURSOR FOR
        SELECT (p_cost * (select coalesce(sum(sbft_porcentaje),0) sumaPorc
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
        --Obtiene todas las subcuentas implicadas para validar que todas existan antes de empezar a insertar los movimientos contables
        --
        c_sbcu_impli CURSOR (codigoProd varchar) IS
        SELECT tem_mvco_sbcu subcuenta
          FROM co_ttem_mvco
         WHERE tem_mvco_trans = p_idTrans
         UNION ALL
        SELECT sbft_sbcu_codigo
          FROM co_ttido,co_tsbft
         WHERE upper(tido_nombre) = 'FACTCOMPRA'
           AND sbft_tido = tido_tido 
         UNION ALL
        SELECT '1435' || codigoProd 
        ;        
        --
        --Cursor en el cual valido que una subucuenta exista
        --
        c_valida_sbcu CURSOR (vc_sbcu_codigo varchar) IS
        SELECT count(*)
          FROM co_tsbcu
         WHERE sbcu_codigo = vc_sbcu_codigo
         ;
        
        v_dummy             varchar(500) := '';
        --Variable con la cual se evaluara si existe la subcuenta
        v_con_sub           INTEGER := 0;
        --
        c_mov_cont  CURSOR (vc_cod_prod varchar) IS
        SELECT sbcu_sbcu, movimSbCu.valor, movimSbCu.natu
          FROM co_tsbcu,
        (SELECT tem_mvco_sbcu subcuenta,cast(tem_mvco_valor as numeric) valor, tem_mvco_naturaleza natu
          FROM co_ttem_mvco
         WHERE tem_mvco_trans = p_idTrans
         UNION ALL
        SELECT '1435' || vc_cod_prod , p_cost,'D'
         UNION ALL 
        SELECT sbft_sbcu_codigo, cast(coalesce(((sbft_porcentaje*p_cost)/100),0) as numeric) ,sbft_naturaleza
          FROM co_ttido,co_tsbft
         WHERE upper(tido_nombre) = 'FACTCOMPRA'
           AND sbft_tido = tido_tido) movimSbCu
        WHERE movimSbCu.subcuenta = sbcu_codigo
         ;
        --
        --Cursor con el cual obtengo el valor de la subcuenta de la categoria
        --
        c_categoria CURSOR FOR
        SELECT cate_sbcu, cate_cate,cate_desc
          FROM in_tcate
         WHERE cate_cate = p_cate
           AND cate_estado = 'A'
         ;
        --
        v_cate_cate             int := 0;
        v_cate_sbcu             int := 0;
        v_cate_desc             varchar(100):= '';
        --
        --
        --
        c_codigo_sbcu CURSOR (vc_sbcu_sbcu int) IS
        SELECT substring(sbcu_codigo from character_length(sbcu_codigo)-1 for character_length(sbcu_codigo))
          FROM co_tsbcu
         WHERE sbcu_sbcu = vc_sbcu_sbcu
         ;
        --
        --
        --
        v_nom_prod  varchar(50):= '';
        --
        --
        --
        c_creaRefeProd CURSOR FOR
        SELECT (
            (SELECT cate_desc from in_tcate where cate_cate = p_cate)
        || ' ' ||
            (SELECT marca_nombre from in_tmarca where marca_marca = p_marca)
        || ' ' ||
            (select refe_desc from in_trefe where refe_refe = p_ref)
        )
        ;
      BEGIN
        --
        --
        --
        OPEN c_creaRefeProd;
        FETCH c_creaRefeProd INTO v_nom_prod;
        CLOSE c_creaRefeProd;
        --
         OPEN c_dska_dska;
         FETCH c_dska_dska INTO v_dska_dska;
         CLOSE c_dska_dska;
         
         OPEN c_kapr_kapr;
         FETCH c_kapr_kapr INTO v_kapr_kapr;
         CLOSE c_kapr_kapr;
         --
         OPEN c_codigo;
         FETCH c_codigo INTO v_codigo ;
         CLOSE c_codigo;
         --         
         v_cod_prod  :=   US_FVERIFICA_COD_PROD(v_codigo);
         
         
         IF v_cod_prod = 'N' THEN
            --
            insert into in_tdska(dska_dska,DSKA_REFE,DSKA_COD, DSKA_NOM_PROD, DSKA_DESC, DSKA_IVA, DSKA_PORC_IVA, DSKA_MARCA,DSKA_CATE,DSKA_PROV)
                          values(v_dska_dska,p_ref,v_codigo,v_nom_prod,v_nom_prod,upper(p_iva),p_porc_iva,p_marca,p_cate,p_prov);
                         
             IF v_dska_dska IS NOT NULL THEN
               
               v_cost_tot := p_cost;
               
               OPEN c_valor_unidad;
               FETCH c_valor_unidad INTO v_costo_unidad;
               CLOSE c_valor_unidad;
               
               v_tius_tius := US_FRETORNA_ID_USUARIO(trim(p_usua));
               
               OPEN c_mvin_inicial;
               FETCH c_mvin_inicial INTO v_mvin_inicial, v_cont_mvin;
               CLOSE c_mvin_inicial;
               
               IF v_cont_mvin = 1 THEN
                    --
                    --Creacion de la subcuenta por categoria                    
                    --
                    OPEN c_categoria;
                    FETCH c_categoria INTO v_cate_sbcu,v_cate_cate,v_cate_desc;
                    CLOSE c_categoria;
                    --
                    IF v_cate_cate is not null THEN                        
                        --
                        IF v_cate_sbcu is null THEN
                            --
                            IF v_cate_cate < 10 THEN
                                --
                                v_codigosbcu := '0'||CAST(v_cate_cate AS VARCHAR);
                                --
                            ELSE
                                --
                                v_codigosbcu := cast(v_cate_cate as VARCHAR);
                                --
                            END IF;
                            --
                            OPEN c_sec_sbcu;
                            FETCH c_sec_sbcu INTO v_sbcu_sbcu;
                            CLOSE c_sec_sbcu;
                            
                            
                            INSERT INTO co_tsbcu(
                                    sbcu_sbcu,sbcu_cuen, sbcu_clas, sbcu_grup, sbcu_estado, sbcu_nombre, 
                                    sbcu_codigo, sbcu_descripcion, sbcu_naturaleza)
                            VALUES (v_sbcu_sbcu,47, 1, 4, 'A', 'CATEGORIA '|| v_cate_desc , 
                                    v_codigosbcu,'Se almacenaran las entradas y salidas de los producto que pertenescan a la categoria ' || v_cate_desc  , 'C')
                                    ;
                            --
                            UPDATE in_tcate
                               SET cate_sbcu = v_sbcu_sbcu
                             WHERE cate_cate = v_cate_cate
                             ;
                            --
                        ELSE
                            --
                            v_sbcu_sbcu := v_cate_sbcu;
                            --
                            OPEN c_codigo_sbcu(v_cate_sbcu);
                            FETCH c_codigo_sbcu INTO v_codigosbcu;
                            CLOSE c_codigo_sbcu;
                            --
                        END IF;
                        --
                    ELSE
                        RAISE EXCEPTION 'La categoria asociada al producto no existe o se encuentra inactiva por favor intente de nuevo. ';
                    END IF;
                    --
                    insert into in_tkapr (KAPR_KAPR,                KAPR_DSKA,                  KAPR_FECHA, 
                                          KAPR_MVIN,                KAPR_CANT_MVTO,             KAPR_COST_MVTO_UNI, 
                                          KAPR_COST_MVTO_TOT,       KAPR_COST_SALDO_UNI,        KAPR_COST_SALDO_TOT, 
                                          KAPR_CANT_SALDO,          KAPR_TIUS,                  KAPR_CONS_PRO,    
                                          KAPR_SEDE)
                                   values(v_kapr_kapr,              v_dska_dska,                now(),         
                                          v_mvin_inicial,           p_cant,                     v_costo_unidad,      
                                          v_cost_tot,               v_costo_unidad,             v_cost_tot,
                                          p_cant,                   v_tius_tius,                1,
                                          p_sede );
                    --
                    UPDATE in_tdska
                       SET dska_sbcu = v_sbcu_sbcu
                     WHERE dska_dska = v_dska_dska
                     ;
                    --
               ELSIF v_cont_mvin = 0 OR v_cont_mvin is null THEN 
                    --
                    RAISE EXCEPTION 'Error US_FINSERT_NUEVO_PROD no esta referenciado ningun movimiento de inventario en el sistema para inventario inicial porfavor referencie un movimiento e intente de nuevo';
                    --
               ELSE
                    --
                    RAISE EXCEPTION 'Error US_FINSERT_NUEVO_PROD hay mas de un movimiento de inventario parametrizado en el sistema ';
                    --
               END IF;
               
               
             END IF;
                          
            rta = 'Ok';
         ELSE 
            rta = 'Error existe un codigo repetido';
         END IF;
         --
         --
         --
         
         --
         --Acciones para realizar la contabilidad de las facturas de compra
         --
         
         OPEN c_deb_param;
         FETCH c_deb_param INTO v_debitos;
         CLOSE c_deb_param;
         
         OPEN c_cre_param;
         FETCH c_cre_param INTO v_creditos;
         CLOSE c_cre_param;
         
         v_debitos := v_debitos + p_cost;
         
         OPEN c_deb_usua;
         FETCH c_deb_usua INTO v_deb_usu;
         CLOSE c_deb_usua;
         
         OPEN c_cre_usua;
         FETCH c_cre_usua INTO v_cre_usu;
         CLOSE c_cre_usua;
         
        v_debitos :=  v_deb_usu + v_debitos;
         
        v_creditos := v_creditos + v_cre_usu;
        
        IF v_debitos = v_creditos THEN
            --
            OPEN c_id_ttido;
            FETCH c_id_ttido INTO v_tipoDocumento;
            CLOSE c_id_ttido;
            --        
            FOR subcuenta in c_sbcu_impli(v_codigosbcu)
            LOOP
                --
                OPEN c_valida_sbcu(subcuenta.subcuenta);
                FETCH c_valida_sbcu INTO v_con_sub;
                CLOSE c_valida_sbcu;
                --
                IF v_con_sub = 0 THEN 
                
                    RAISE EXCEPTION 'La subcuenta % no existe por favor verifique he intente de nuevo ', subcuenta.subcuenta;
                    
                END IF;               
                --
            END LOOP; 
            --
            FOR movi IN c_mov_cont(v_codigosbcu)
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
                         p_prov, 2);

                --
            END LOOP;
            --
        ELSE 
            --
            RAISE EXCEPTION 'Las sumas de los debitos y los creditos no coinciden DEBITOS: %, CREDITOS: % ', v_debitos,v_creditos;
            --
        END IF;
        
        DELETE FROM co_ttem_mvco
        WHERE tem_mvco_trans = p_idTrans
        ;
        
        RETURN rta||'&'||v_codigo;
         
        EXCEPTION 
            WHEN OTHERS THEN
               RETURN 'ERR' || ' Error postgres: ' || SQLERRM;
        END;
$$ LANGUAGE 'plpgsql';