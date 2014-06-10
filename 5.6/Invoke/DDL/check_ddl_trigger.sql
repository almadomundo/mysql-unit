-- Check about existense of TRIGGER `unit_name` in table `unit_db`.`unit_table`

DROP FUNCTION IF EXISTS CHECK_DDL_TRIGGER;
DELIMITER //
CREATE FUNCTION CHECK_DDL_TRIGGER(unit_db VARCHAR(255), unit_table VARCHAR(255), unit_name VARCHAR(255), existense INT)
RETURNS INT
BEGIN
   DECLARE unit_count  INT DEFAULT 0;
   SELECT 
      COUNT(1) INTO unit_count 
   FROM 
      `INFORMATION_SCHEMA`.`TRIGGERS` 
   WHERE 
      `TRIGGER_SCHEMA`     = unit_db &&
      `EVENT_OBJECT_TABLE` = unit_table &&
      `TRIGGER_NAME`       = unit_name;
   RETURN !(unit_count!=0 XOR existense!=0);
END//
DELIMITER ;
