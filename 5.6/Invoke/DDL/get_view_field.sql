-- Get "unit_field" for VIEW `unit_name` in database `unit_db`

DROP FUNCTION IF EXISTS GET_VIEW_FIELD;
DELIMITER //
CREATE FUNCTION GET_VIEW_FIELD(unit_db VARCHAR(255), unit_name VARCHAR(255), unit_field VARCHAR(255))
RETURNS VARCHAR(255)
BEGIN
   DECLARE message   VARCHAR(255) DEFAULT '';
   DECLARE ddl_field VARCHAR(255) DEFAULT '';

   IF !CHAR_LENGTH(unit_db) THEN
      SET unit_db = DATABASE();
   END IF;
   IF !CHECK_DDL_COLUMN_EXISTS('INFORMATION_SCHEMA', 'VIEWS', unit_field) THEN
      SET message = CONCAT(
         'View meta-field "', 
         unit_field,
         '" does not exist'
      );
      SIGNAL SQLSTATE '80700' SET MESSAGE_TEXT = message;
   END IF;

   IF !CHECK_DDL_VIEW_EXISTS(unit_db, unit_name) THEN
      SET message = CONCAT(
         'View `', 
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
         WHEN unit_field='VIEW_DEFINITION' THEN `VIEW_DEFINITION`
         WHEN unit_field='CHECK_OPTION' THEN `CHECK_OPTION`
         WHEN unit_field='IS_UPDATABLE' THEN `IS_UPDATABLE`
         WHEN unit_field='DEFINER' THEN `DEFINER`
         WHEN unit_field='SECURITY_TYPE' THEN `SECURITY_TYPE`
         WHEN unit_field='CHARACTER_SET_CLIENT' THEN `CHARACTER_SET_CLIENT`
         WHEN unit_field='COLLATION_CONNECTION' THEN `COLLATION_CONNECTION`
      END
      INTO ddl_field 
   FROM 
      `INFORMATION_SCHEMA`.`VIEWS` 
   WHERE 
      `TABLE_SCHEMA` = unit_db &&
      `TABLE_NAME`   = unit_name;
   RETURN ddl_field;
END//
DELIMITER ;
