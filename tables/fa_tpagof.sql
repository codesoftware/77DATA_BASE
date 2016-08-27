--
--TABLA DE PAGOS 
--
CREATE TABLE fa_tpagof(
pagof_pagof        BIGSERIAL                NOT NULL,
pagof_facom        BIGINT                   NOT NULL,
pagof_auco         BIGINT                   NOT NULL,
pagof_valor        NUMERIC(1000,10)         NOT NULL,
pagof_tius         BIGINT                   NOT NULL,
pagof_fecha        TIMESTAMP DEFAULT NOW()  NOT NULL,
pagof_estad        VARCHAR(2)               NOT NULL,
PRIMARY KEY (pagof_pagof)
);              