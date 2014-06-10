-- Check about existense of FUNCTION `unit_name` in `unit_db`

DROP FUNCTION IF EXISTS CHECK_DDL_FUNCTION;
DELIMITER //
CREATE FUNCTION CHECK_DDL_FUNCTION(unit_db VARCHAR(255), unit_name VARCHAR(255), existense INT)
RETURNS INT
BEGIN
   DECLARE unit_count  INT DEFAULT 0;
   SELECT 
      COUNT(1) INTO unit_count 
   FROM 
      `mysql`.`proc` 
   WHERE 
      `db`   = unit_db &&
      `type` = 'FUNCTION' &&
      `name` = unit_name;
   RETURN !(unit_count!=0 XOR existense!=0);
END//
DELIMITER ;
