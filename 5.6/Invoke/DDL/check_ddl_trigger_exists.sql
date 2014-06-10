-- Check about existence of TRIGGER `unit_name` in table `unit_db`.`unit_table`

DROP FUNCTION IF EXISTS CHECK_DDL_TRIGGER_EXISTS;
DELIMITER //
CREATE FUNCTION CHECK_DDL_TRIGGER_EXISTS(unit_db VARCHAR(255), unit_table VARCHAR(255), unit_name VARCHAR(255))
RETURNS INT
BEGIN
   DECLARE unit_count  INT DEFAULT 0;
   IF !CHAR_LENGTH(unit_db) THEN
      SET unit_db = DATABASE();
   END IF;

   SELECT 
      COUNT(1) INTO unit_count 
   FROM 
      `INFORMATION_SCHEMA`.`TRIGGERS` 
   WHERE 
      `TRIGGER_SCHEMA`     = unit_db &&
      `EVENT_OBJECT_TABLE` = unit_table &&
      `TRIGGER_NAME`       = unit_name;
   RETURN unit_count>0;
END//
DELIMITER ;
