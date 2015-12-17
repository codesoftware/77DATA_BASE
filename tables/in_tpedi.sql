CREATE TABLE in_tpedi(
     pedi_pedi         BIGSERIAL                                ,
     pedi_sede         BIGINT               NOT NULL            ,
     pedi_usu          BIGINT               NOT NULL            ,
     pedi_fech         TIMESTAMP            DEFAULT     now()   ,
     pedi_esta         varchar(10)          NOT NULL            ,
     pedi_clie         BIGINT               NOT NULL            ,
     pedi_fact         BIGINT                                   ,
     PRIMARY KEY(pedi_pedi)
  ); 