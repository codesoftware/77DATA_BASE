--
--LLave con la tabla de pago de remisiones principal
--
ALTER TABLE fa_tdpgr
ADD FOREIGN KEY(dpgr_pgrm)
REFERENCES fa_tpgrm(pgrm_pgrm)
;