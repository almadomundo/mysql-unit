DROP PROCEDURE IF EXISTS dummy_proc;
DELIMITER //
CREATE PROCEDURE dummy_proc(t VARCHAR(255), c VARCHAR(255), f VARCHAR(255))
BEGIN
   SET @dummy_sql_mysql_unit = CONCAT('DROP TABLE IF EXISTS ', t);
   PREPARE eval_dummy_mysql_unit FROM @dummy_sql_mysql_unit;
   EXECUTE eval_dummy_mysql_unit;

   SET @dummy_sql_mysql_unit = CONCAT(
      'CREATE TABLE ',
      t,
      '(',
      c,
      ' ',
      f,
      ')'
   );
   PREPARE eval_dummy_mysql_unit FROM @dummy_sql_mysql_unit;
   EXECUTE eval_dummy_mysql_unit;
END//
DELIMITER ;