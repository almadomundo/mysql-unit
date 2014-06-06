-- Was an idea. Currently, impossible because
-- prepared statement doesn't support stored code definition

DROP PROCEDURE IF EXISTS REGISTER_FUNCTION;
DELIMITER //
CREATE PROCEDURE REGISTER_FUNCTION(f VARCHAR(255), d TINYINT)
BEGIN
   SET @statement_mysql_unit = CONCAT(
      -- 'DELIMITER //', "\n",
      'CREATE PROCEDURE TEST_',IF(d, 'FULL_', ''), f, '()', "\n",
      'BEGIN', "\n",
         'CALL TEST_BY_ASSERT_TABLE("',f ,'", ', d, ', "");', "\n",
      'END;', "\n"
      -- 'DELIMITER ;' , "\n"
   );
   PREPARE eval FROM @statement_mysql_unit;
   EXECUTE eval;
END//
DELIMITER ;