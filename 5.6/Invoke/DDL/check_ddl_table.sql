-- Check about existence of TABLE `unit_name` in `unit_db`

DROP FUNCTION IF EXISTS CHECK_DDL_TABLE;
DELIMITER //
CREATE FUNCTION CHECK_DDL_TABLE(unit_db VARCHAR(255), unit_name VARCHAR(255), existence INT)
RETURNS INT
BEGIN
   DECLARE unit_count  INT DEFAULT 0;
   SELECT 
      COUNT(1) INTO unit_count 
   FROM 
      `INFORMATION_SCHEMA`.`TABLES` 
   WHERE 
      `TABLE_SCHEMA` = unit_db &&
      `TABLE_NAME`   = unit_name;
   RETURN !(unit_count!=0 XOR existence!=0);
END//
DELIMITER ;
