CREATE TABLE in_tpedi(
     pedi_pedi         SERIAL               ,
     pedi_sede         int   NOT NULL       ,
     pedi_usu          int   NOT NULL       ,
     pedi_fech         TIMESTAMP            ,
     pedi_esta         varchar(10) NOT NULL ,
     pedi_clie         int   NOT NULL       ,
     PRIMARY KEY(pedi_pedi)
  ); 
   
