-- YYYY-MM-DD date validator:
DROP FUNCTION IF EXISTS VALIDATE_DATE;
DELIMITER //
CREATE FUNCTION VALIDATE_DATE(d VARCHAR(255))
RETURNS INT
BEGIN
   DECLARE date_year  VARCHAR(255) DEFAULT '';
   DECLARE date_month VARCHAR(255) DEFAULT '';
   DECLARE date_day   VARCHAR(255) DEFAULT '';
   DECLARE ym_delim   INT DEFAULT 0;
   DECLARE md_delim   INT DEFAULT 0;
   -- First, if it's just not xxx-yyy-zzz format:
   SET ym_delim = LOCATE('-', d);
   SET md_delim = LOCATE('-', d, ym_delim+1);
   IF !ym_delim || !md_delim THEN
   
      RETURN FALSE;
   END IF;
   -- Second, if resulted members are not YYYY, MM od DD:
   SET date_year  = SUBSTR(d, 1, ym_delim-1);
   SET date_month = SUBSTR(d, ym_delim+1, md_delim-ym_delim-1);
   SET date_day   = SUBSTR(d, md_delim+1);
   IF  date_year  NOT REGEXP '^[0-9]{4}$'
    || date_month NOT REGEXP '^[0-9]{2}$'
    || date_day   NOT REGEXP '^[0-9]{2}$' THEN
      RETURN FALSE;
   END IF;
   -- Finally, check if date itself is ok, like 2014-02-30 isn't ok:
   IF DATE(CONCAT(date_year, '-', date_month, '-', date_day)) IS NULL THEN
      RETURN FALSE;
   END IF;
   RETURN TRUE;
END//
DELIMITER ;