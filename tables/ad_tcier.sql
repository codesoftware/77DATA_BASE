CREATE TABLE AD_TCIER(
    CIER_CIER                   SERIAL                                  ,
    CIER_FECH                   TIMESTAMP       NOT NULL                ,
    CIER_USUA                   INT             NOT NULL                ,
    CIER_VLRI                   NUMERIC(15,5)             NOT NULL      ,
    CIER_VLRT                   NUMERIC(15,5)      		NOT NULL	    ,
    CIER_VLRC                 	NUMERIC(15,5)			    NOT NULL    ,
    CIER_SEDE                   INT     		NOT NULL                ,
    CIER_ESTADO                 VARCHAR(2)    	NOT NULL                ,
PRIMARY KEY (CIER_CIER)
);