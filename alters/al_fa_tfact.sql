ALTER TABLE fa_tfact ADD fact_cierre int;
ALTER TABLE FA_TFACT ADD COLUMN FACT_FECHAEX TIMESTAMP DEFAULT NOW();
ALTER TABLE  US_TCLIEN ALTER COLUMN CLIEN_CEDULA TYPE VARCHAR(200); 
ALTER TABLE  US_TCLIEN ALTER COLUMN CLIEN_NOMBRES TYPE VARCHAR(200); 
ALTER TABLE  US_TCLIEN ALTER COLUMN CLIEN_APELLIDOS TYPE VARCHAR(200); 
ALTER TABLE  US_TCLIEN ALTER COLUMN CLIEN_DIRECCION TYPE VARCHAR(200); 
