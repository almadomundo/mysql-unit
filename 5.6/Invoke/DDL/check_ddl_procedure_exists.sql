-- Check about existence of PROCEDURE `unit_name` in `unit_db`

DROP FUNCTION IF EXISTS CHECK_DDL_PROCEDURE_EXISTS;
DELIMITER //
CREATE FUNCTION CHECK_DDL_PROCEDURE_EXISTS(unit_db VARCHAR(255), unit_name VARCHAR(255))
RETURNS INT
BEGIN
   DECLARE unit_count  INT DEFAULT 0;
   IF !CHAR_LENGTH(unit_db) THEN
      SET unit_db = DATABASE();
   END IF;

   SELECT 
      COUNT(1) INTO unit_count 
   FROM 
      `mysql`.`proc` 
   WHERE 
      `db`   = unit_db &&
      `type` = 'PROCEDURE' &&
      `name` = unit_name;
   RETURN unit_count>0;
END//
DELIMITER ;
