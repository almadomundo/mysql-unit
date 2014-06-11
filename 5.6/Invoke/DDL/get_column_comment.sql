-- Get DDL comment for COLUMN `unit_name` in table `unit_db`.`unit_table`

DROP FUNCTION IF EXISTS GET_COLUMN_COMMENT;
DELIMITER //
CREATE FUNCTION GET_COLUMN_COMMENT(unit_db VARCHAR(255), unit_table VARCHAR(255), unit_name VARCHAR(255))
RETURNS VARCHAR(255)
BEGIN
   RETURN GET_COLUMN_FIELD(unit_db, unit_table, unit_name, 'COLUMN_COMMENT');
END//
DELIMITER ;