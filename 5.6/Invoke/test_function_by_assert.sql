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
      -- From ASSERT()
      IF @thrown_sqlstate_mysql_unit = '80000' THEN
         IF d THEN
            SELECT 
               @record_id_mysql_unit AS test_id,
               @record_expression_mysql_unit AS test_expression,
               @record_value_mysql_unit AS test_value,
               @record_is_error_mysql_unit AS test_is_error,
               NULL AS test_error_code_expected,
               NULL AS test_error_code_thrown,
               NULL AS test_error_message_thrown,
               CONCAT('Test id < ', @record_id_mysql_unit, ' > : assertion that expression ( ', @record_expression_mysql_unit, ' ) is "', @record_value_mysql_unit, '", failed.') AS test_trace;
         END IF;
         SET message = CONCAT('Test id < ', @record_id_mysql_unit, ' > : assertion failed');
         SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = message;
      END IF;
      IF @thrown_sqlstate_mysql_unit = '80100' THEN
         SET message = 'Tests for function specified name or test number were not found';
         SIGNAL SQLSTATE '80100' SET MESSAGE_TEXT = message;
      END IF;
      -- From checking if it was error mismatch
      IF @thrown_sqlstate_mysql_unit = '80200' THEN
         IF @record_is_error_mysql_unit THEN
            SET message = CONCAT('Test id < ', @record_id_mysql_unit, ' > : expectation of ERROR failed.');
            IF d THEN
               SELECT 
                  @record_id_mysql_unit AS test_id,
                  @record_expression_mysql_unit AS test_expression,
                  @record_value_mysql_unit AS test_value,
                  @record_is_error_mysql_unit AS test_is_error,
                  @record_error_code_mysql_unit AS test_error_code_expected,
                  NULL AS test_error_code_thrown,
                  NULL AS test_error_message_thrown,
                  CONCAT('Test id < ', @record_id_mysql_unit, ' > : expectation that expression ( ', @record_expression_mysql_unit, ' ) throws ERROR, failed.') AS test_trace;
            END IF;
         END IF;
         IF !@record_is_error_mysql_unit THEN
            SET message = CONCAT('Test id < ', @record_id_mysql_unit, ' > : expectation of validity failed.');
            IF d THEN
               SELECT 
                  @record_id_mysql_unit AS test_id,
                  @record_expression_mysql_unit AS test_expression,
                  @record_value_mysql_unit AS test_value,
                  @record_is_error_mysql_unit AS test_is_error,
                  NULL AS test_error_code_expected,
                  @record_thrown_code_mysql_unit AS test_error_code_thrown,
                  @record_error_text_mysql_unit AS test_error_message_thrown, 
                  CONCAT('Test id < ', @record_id_mysql_unit, ' > : expectation that expression ( ', @record_expression_mysql_unit, ' ) is valid, failed. ERROR thrown: ', @record_error_text_mysql_unit) AS test_trace;
            END IF;
         END IF;
         SIGNAL SQLSTATE '80200' SET MESSAGE_TEXT = message;
      END IF;
      IF @thrown_sqlstate_mysql_unit = '80300' THEN
         SET message = CONCAT('Test id < ', @record_id_mysql_unit, ' > : expectation of ERROR code failed.');
         IF d THEN
            SELECT 
               @record_id_mysql_unit AS test_id,
               @record_expression_mysql_unit AS test_expression,
               @record_value_mysql_unit AS test_value,
               @record_is_error_mysql_unit AS test_is_error,
               @record_error_code_mysql_unit AS test_error_code_expected,
               @record_thrown_code_mysql_unit AS test_error_code_thrown,
               @record_error_text_mysql_unit AS test_error_message_thrown,
               CONCAT('Test id < ', @record_id_mysql_unit, ' > : expectation that expression ( ', @record_expression_mysql_unit, ' ) throws ERROR wich code ', @record_error_code_mysql_unit,', failed. Actual ERROR code thrown is "', @record_thrown_code_mysql_unit, '" with message: ', @record_error_text_mysql_unit) AS test_trace;
         END IF;
         SIGNAL SQLSTATE '80300' SET MESSAGE_TEXT = message;
      END IF;
      SET error = @thrown_message_mysql_unit;
   END;
   SELECT COUNT(1) INTO tests_count FROM TEST_ASSERTIONS WHERE IF(CHAR_LENGTH(f), function_name=f, 1) && IF(CHAR_LENGTH(t), id=t, 1);
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
      SET record_assertion = ASSERT(@expression_mysql_unit, record_value);
   END LOOP;
   CLOSE tests;
END//
DELIMITER ;