CREATE TABLE in_tpedi(
     pedi_pedi         bigserial                        ,
     pedi_sede         int              NOT NULL        ,
     pedi_usu          int              NOT NULL        ,
     pedi_fech         TIMESTAMP        default now()   ,
     pedi_esta         varchar(10)      NOT NULL        ,
     pedi_clie         int              NOT NULL        ,
     pedi_fact         integer                          ,
     PRIMARY KEY(pedi_pedi)
  ); 