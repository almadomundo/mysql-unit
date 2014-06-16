-- Base procedure for testing framework

DROP PROCEDURE IF EXISTS TEST_FUNCTION_BY_ASSERT;
DELIMITER //
CREATE PROCEDURE TEST_FUNCTION_BY_ASSERT(f VARCHAR(255), d TINYINT, t VARCHAR(255))
BEGIN
   DECLARE message           VARCHAR(255) DEFAULT '';
   DECLARE error             VARCHAR(255) DEFAULT '';
   DECLARE done              INT DEFAULT FALSE;
   DECLARE record_is_error   INT DEFAULT FALSE;
   DECLARE record_error_code VARCHAR(255) DEFAULT '';
   DECLARE record_expression VARCHAR(255) DEFAULT '';
   DECLARE record_value      VARCHAR(255) DEFAULT '';
   DECLARE record_assertion  INT DEFAULT 0;
   DECLARE tests_count       INT DEFAULT 0;
   DECLARE record_id         INT DEFAULT 0;
   DECLARE tests CURSOR FOR 
     SELECT `id`, `expression`, `value`, `is_error`, `error_code` FROM TEST_FUNCTION_ASSERTIONS WHERE IF(f, function_name=f, 1) && IF(t, id=t, 1);
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
   BEGIN
      GET DIAGNOSTICS CONDITION 1
         @thrown_sqlstate_mysql_unit = RETURNED_SQLSTATE,
         @thrown_message_mysql_unit  = MESSAGE_TEXT,
         @thrown_code_mysql_unit     = MYSQL_ERRNO;
      CALL GET_ERROR(
         @thrown_sqlstate_mysql_unit,
         @record_id_mysql_unit,
         @record_expression_mysql_unit,
         @record_value_mysql_unit,
         @record_is_error_mysql_unit,
         @record_error_code_mysql_unit,
         @record_thrown_code_mysql_unit,
         @record_error_text_mysql_unit,
         f,
         d,
         t,
         'FUNCTION'
      );
      SET error = @thrown_message_mysql_unit;
   END;

   CALL REGISTER_FUNCTION_VARIABLES();

   SELECT COUNT(1) INTO tests_count FROM TEST_FUNCTION_ASSERTIONS WHERE IF(CHAR_LENGTH(f), function_name=f, 1) && IF(CHAR_LENGTH(t), id=t, 1);
   IF !tests_count THEN
      SIGNAL SQLSTATE '80100';
   END IF;
   
   OPEN tests;
   read_loop: LOOP
      FETCH tests INTO record_id, record_expression, record_value, record_is_error, record_error_code;
      IF done THEN
         LEAVE read_loop;
      END IF;
      SET @statement_mysql_unit = CONCAT('SELECT ', record_expression, ' INTO @expression_mysql_unit');
      PREPARE eval_mysql_unit FROM @statement_mysql_unit;
      EXECUTE eval_mysql_unit;
      SET @record_id_mysql_unit          = record_id;
      SET @record_expression_mysql_unit  = record_expression;
      SET @record_value_mysql_unit       = record_value;
      SET @record_is_error_mysql_unit    = record_is_error;
      SET @record_error_text_mysql_unit  = @thrown_message_mysql_unit;
      SET @record_thrown_code_mysql_unit = @thrown_code_mysql_unit;
      SET @record_error_code_mysql_unit  = record_error_code;
      -- Error expectation:
      IF record_is_error XOR CHAR_LENGTH(error) THEN
         SIGNAL SQLSTATE '80200';
      END IF;
      IF record_is_error && CHAR_LENGTH(error) && record_error_code!=@record_thrown_code_mysql_unit THEN
         SIGNAL SQLSTATE '80300';
      END IF;
      -- Normal assertion:
      IF !record_is_error THEN
         SET record_assertion = ASSERT(@expression_mysql_unit, record_value);
      END IF;
      SET error            = '';
   END LOOP;
   CLOSE tests;

   CALL RELEASE_FUNCTION_VARIABLES();
END//
DELIMITER ;