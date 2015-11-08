--
-- drop SEQUENCE co_temp_tran_factu
--


--
--Secuencia utilizada para indicar que una remision fue generada
--
CREATE SEQUENCE in_tsec_trans_rmce
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9999999999
  START 1
  CACHE 1
  cycle
  ;

