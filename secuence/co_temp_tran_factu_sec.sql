--
-- drop SEQUENCE co_temp_tran_factu
--


--
--Secuencia utilizada para realizar los movimientos contables en una sola transaccion
--
CREATE SEQUENCE co_temp_tran_factu_sec
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9999999999
  START 1
  CACHE 1
  cycle
  ;

