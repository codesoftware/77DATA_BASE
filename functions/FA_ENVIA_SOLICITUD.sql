--
--funcion que realiza la solicitud
--
CREATE OR REPLACE FA_ENVIASOLICITUD(
                  p_tius         BIGINT,
                  p_soli         BIGINT
                  )AS $$
    DECLARE
    --
    --Cursor encargado de consultar los datos de la solicitud
    --
    c_consultasoli  CURSOR IS 
    SELECT soli_tius,soli_esta,soli_come,soli_sede
    FROM fa_tsoli 
    WHERE soli_soli = p_soli
    ;
    --
    --cursor encargado de consultar los productos de la solicitud|
    --
    c_consultaprdsoli CURSOR FOR
    SELECT sopd_dska,sopd_cant,sopd_cenv,sopd_sede
    FROM fa_tsopd
    WHERE sopd_soli = p_soli
    ;
    