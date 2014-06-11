-- Get "unit_field" for TABLE `unit_name` in database `unit_db`

DROP FUNCTION IF EXISTS GET_TABLE_FIELD;
DELIMITER //
CREATE FUNCTION GET_TABLE_FIELD(unit_db VARCHAR(255), unit_name VARCHAR(255), unit_field VARCHAR(255))
RETURNS VARCHAR(255)
BEGIN
   DECLARE message   VARCHAR(255) DEFAULT '';
   DECLARE ddl_field VARCHAR(255) DEFAULT '';

   IF !CHAR_LENGTH(unit_db) THEN
      SET unit_db = DATABASE();
   END IF;
   IF !CHECK_DDL_COLUMN_EXISTS('INFORMATION_SCHEMA', 'TABLES', unit_field) THEN
      SET message = CONCAT(
         'Table meta-field "', 
         unit_field,
         '" does not exist'
      );
      SIGNAL SQLSTATE '80700' SET MESSAGE_TEXT = message;
   END IF;

   IF !CHECK_DDL_TABLE_EXISTS(unit_db, unit_name) THEN
      SET message = CONCAT(
         'Table `', 
         unit_db, 
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
         WHEN unit_field='TABLE_TYPE' THEN `TABLE_TYPE`
         WHEN unit_field='ENGINE' THEN `ENGINE`
         WHEN unit_field='VERSION' THEN `VERSION`
         WHEN unit_field='ROW_FORMAT' THEN `ROW_FORMAT`
         WHEN unit_field='TABLE_ROWS' THEN `TABLE_ROWS`
         WHEN unit_field='AVG_ROW_LENGTH' THEN `AVG_ROW_LENGTH`
         WHEN unit_field='DATA_LENGTH' THEN `DATA_LENGTH`
         WHEN unit_field='MAX_DATA_LENGTH' THEN `MAX_DATA_LENGTH`
         WHEN unit_field='INDEX_LENGTH' THEN `INDEX_LENGTH`
         WHEN unit_field='DATA_FREE' THEN `DATA_FREE`
         WHEN unit_field='AUTO_INCREMENT' THEN `AUTO_INCREMENT`
         WHEN unit_field='CREATE_TIME' THEN `CREATE_TIME`
         WHEN unit_field='UPDATE_TIME' THEN `UPDATE_TIME`
         WHEN unit_field='CHECK_TIME' THEN `CHECK_TIME`
         WHEN unit_field='TABLE_COLLATION' THEN `TABLE_COLLATION`
         WHEN unit_field='CHECKSUM' THEN `CHECKSUM`
         WHEN unit_field='CREATE_OPTIONS' THEN `CREATE_OPTIONS`
         WHEN unit_field='TABLE_COMMENT' THEN `TABLE_COMMENT`
      END
      INTO ddl_field 
   FROM 
      `INFORMATION_SCHEMA`.`TABLES` 
   WHERE 
      `TABLE_SCHEMA` = unit_db &&
      `TABLE_NAME`   = unit_name;
   RETURN ddl_field;
END//
DELIMITER ;
