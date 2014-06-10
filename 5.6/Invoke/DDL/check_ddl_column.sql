-- Check about existense of COLUMN `unit_name` in table `unit_db`.`unit_table`

DROP FUNCTION IF EXISTS CHECK_DDL_COLUMN;
DELIMITER //
CREATE FUNCTION CHECK_DDL_COLUMN(unit_db VARCHAR(255), unit_table VARCHAR(255), unit_name VARCHAR(255), existense INT)
RETURNS INT
BEGIN
   DECLARE unit_count  INT DEFAULT 0;
   SELECT 
      COUNT(1) INTO unit_count 
   FROM 
      `INFORMATION_SCHEMA`.`COLUMNS` 
   WHERE 
      `TABLE_SCHEMA` = unit_db &&
      `TABLE_NAME`   = unit_table &&
      `COLUMN_NAME`  = unit_name;
   RETURN !(unit_count!=0 XOR existense!=0);
END//
DELIMITER ;
