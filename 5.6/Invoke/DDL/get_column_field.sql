-- Get "unit_field" for COLUMN `unit_name` in table `unit_db`.`unit_table`

DROP FUNCTION IF EXISTS GET_COLUMN_FIELD;
DELIMITER //
CREATE FUNCTION GET_COLUMN_FIELD(unit_db VARCHAR(255), unit_table VARCHAR(255), unit_name VARCHAR(255), unit_field VARCHAR(255))
RETURNS VARCHAR(255)
BEGIN
   DECLARE message   VARCHAR(255) DEFAULT '';
   DECLARE ddl_field VARCHAR(255) DEFAULT '';

   IF !CHAR_LENGTH(unit_db) THEN
      SET unit_db = DATABASE();
   END IF;
   IF !CHECK_DDL_COLUMN_EXISTS('INFORMATION_SCHEMA', 'COLUMNS', unit_field) THEN
      SET message = CONCAT(
         'Column meta-field "', 
         unit_field,
         '" does not exist'
      );
      SIGNAL SQLSTATE '80700' SET MESSAGE_TEXT = message;
   END IF;

   IF !CHECK_DDL_COLUMN_EXISTS(unit_db, unit_table, unit_name) THEN
      SET message = CONCAT(
         'Column `', 
         unit_db, 
         '`.`',
         unit_table,
         '`.`',
         unit_name,
         '` does not exist'
      );
      SIGNAL SQLSTATE '80700' SET MESSAGE_TEXT = message;
   END IF;
   -- Yes, yes. dynamic sql isn't allowed in functions, so, CASE:
   SELECT 
      CASE
         WHEN unit_field='TABLE_CATALOG' THEN `TABLE_CATALOG`
         WHEN unit_field='TABLE_SCHEMA' THEN `TABLE_SCHEMA`
         WHEN unit_field='TABLE_NAME' THEN `TABLE_NAME`
         WHEN unit_field='COLUMN_NAME' THEN `COLUMN_NAME`
         WHEN unit_field='ORDINAL_POSITION' THEN `ORDINAL_POSITION`
         WHEN unit_field='COLUMN_DEFAULT' THEN `COLUMN_DEFAULT`
         WHEN unit_field='IS_NULLABLE' THEN `IS_NULLABLE`
         WHEN unit_field='DATA_TYPE' THEN `DATA_TYPE`
         WHEN unit_field='CHARACTER_MAXIMUM_LENGTH' THEN `CHARACTER_MAXIMUM_LENGTH`
         WHEN unit_field='CHARACTER_OCTET_LENGTH' THEN `CHARACTER_OCTET_LENGTH`
         WHEN unit_field='NUMERIC_PRECISION' THEN `NUMERIC_PRECISION`
         WHEN unit_field='NUMERIC_SCALE' THEN `NUMERIC_SCALE`
         WHEN unit_field='DATETIME_PRECISION' THEN `DATETIME_PRECISION`
         WHEN unit_field='CHARACTER_SET_NAME' THEN `CHARACTER_SET_NAME`
         WHEN unit_field='COLLATION_NAME' THEN `COLLATION_NAME`
         WHEN unit_field='COLUMN_TYPE' THEN `COLUMN_TYPE`
         WHEN unit_field='COLUMN_KEY' THEN `COLUMN_KEY`
         WHEN unit_field='EXTRA' THEN `EXTRA`
         WHEN unit_field='PRIVILEGES' THEN `PRIVILEGES`
         WHEN unit_field='COLUMN_COMMENT' THEN `COLUMN_COMMENT`
      END
      INTO ddl_field 
   FROM 
      `INFORMATION_SCHEMA`.`COLUMNS` 
   WHERE 
      `TABLE_SCHEMA` = unit_db &&
      `TABLE_NAME`   = unit_table &&
      `COLUMN_NAME`  = unit_name;
   RETURN ddl_field;
END//
DELIMITER ;
