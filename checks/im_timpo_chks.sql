ALTER TABLE im_timpo
ADD CONSTRAINT im_estado_CHK 
CHECK (impo_estado in ('C','X'))
;