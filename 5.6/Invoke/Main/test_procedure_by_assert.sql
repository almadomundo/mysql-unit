-- Base procedure for testing framework

DROP PROCEDURE IF EXISTS TEST_PROCEDURE_BY_ASSERT;
DELIMITER //
CREATE PROCEDURE TEST_PROCEDURE_BY_ASSERT(f VARCHAR(255), d TINYINT, t VARCHAR(255))
BEGIN
-- DECLARATIONS SECTION
-- 
-- All used local variables/cursors e t.c. should be declared here

   DECLARE message               VARCHAR(255) DEFAULT '';
   DECLARE error                 VARCHAR(255) DEFAULT '';
   DECLARE done                  INT DEFAULT FALSE;
   DECLARE record_id             INT DEFAULT 0;
   DECLARE record_prev_id        INT DEFAULT 0;
   DECLARE record_procedure_name VARCHAR(255) DEFAULT '';
   DECLARE record_is_error       INT DEFAULT FALSE;
   DECLARE record_error_code     VARCHAR(255) DEFAULT '';
   DECLARE record_expression     VARCHAR(255) DEFAULT '';
   DECLARE record_value          VARCHAR(255) DEFAULT '';
   DECLARE record_arguments_list VARCHAR(255) DEFAULT '';
   DECLARE record_result_id      INT DEFAULT 0;
   DECLARE record_ref_expression VARCHAR(255) DEFAULT '';
   DECLARE record_ref_value      VARCHAR(255) DEFAULT '';
   DECLARE record_assertion      INT DEFAULT 0;
   DECLARE tests_count           INT DEFAULT 0;
   DECLARE tests CURSOR FOR 
      SELECT 
         `TEST_PROCEDURE_ASSERTIONS`.`id`,
         `procedure_name`, 
         `is_error`, 
         `error_code`,
         GROUP_CONCAT(`argument_value` ORDER BY `TEST_PROCEDURE_ARGUMENTS`.`id`) AS arguments_list,
         `TEST_PROCEDURE_RESULTS`.`id` AS result_id,
         `ref_expression`,
         `ref_value`
      FROM 
         TEST_PROCEDURE_ASSERTIONS
         INNER JOIN
            TEST_PROCEDURE_ARGUMENTS ON `TEST_PROCEDURE_ASSERTIONS`.`id`=`TEST_PROCEDURE_ARGUMENTS`.`test_id`
         INNER JOIN
            TEST_PROCEDURE_RESULTS ON `TEST_PROCEDURE_ASSERTIONS`.`id`=`TEST_PROCEDURE_RESULTS`.`test_id`
      WHERE 
         IF(f, procedure_name=f, 1) && 
         IF(t, `TEST_PROCEDURE_ASSERTIONS`.`id`=t, 1)
      GROUP BY
         `TEST_PROCEDURE_ASSERTIONS`.`id`,
         `TEST_PROCEDURE_RESULTS`.`id`;

-- HANDLERS SECTION
--
-- SQL Exceptions or other catchable events should be processed here

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
         t
      );
      SET error = @thrown_message_mysql_unit;
   END;

-- MAIN SECTION
--
-- Testing logic should be defined here, only here and nowhere else

   SELECT COUNT(1) INTO tests_count FROM TEST_PROCEDURE_ASSERTIONS WHERE IF(CHAR_LENGTH(f), procedure_name=f, 1) && IF(CHAR_LENGTH(t), id=t, 1);
   IF !tests_count THEN
      SIGNAL SQLSTATE '80100';
   END IF;
   
   OPEN tests;
   read_loop: LOOP
      FETCH tests INTO 
         record_id, 
         record_procedure_name,
         record_is_error, 
         record_error_code, 
         record_arguments_list, 
         record_result_id, 
         record_ref_expression, 
         record_ref_value;
      IF done THEN
         LEAVE read_loop;
      END IF;
      -- We can have multiple tests, but it's impossible to define cursor 
      -- dynamically. Thus, iterate & check if id was changed:
      IF record_prev_id!=record_id THEN
         SET @statement_mysql_unit = CONCAT('CALL ', record_procedure_name, '(', record_arguments_list, ')');
         PREPARE eval_mysql_unit FROM @statement_mysql_unit;
         EXECUTE eval_mysql_unit;
      END IF;
      SET @record_id_mysql_unit             = record_id;
      SET @record_is_error_mysql_unit       = record_is_error;
      SET @record_error_code_mysql_unit     = record_error_code;
      SET @record_arguments_list_mysql_unit = record_arguments_list;
      SET @record_result_id_mysql_unit      = record_result_id;
      SET @record_expression_mysql_unit     = CONCAT(record_procedure_name, '(', record_arguments_list, ')');
      SET @record_value_mysql_unit          = NULL;
      SET @record_error_text_mysql_unit     = @thrown_message_mysql_unit;
      SET @record_thrown_code_mysql_unit    = @thrown_code_mysql_unit;
      
      -- Error expectation:
      IF record_is_error XOR CHAR_LENGTH(error) THEN
         SIGNAL SQLSTATE '80200';
      END IF;
      IF record_is_error && CHAR_LENGTH(error) && record_error_code!=@record_thrown_code_mysql_unit THEN
         SIGNAL SQLSTATE '80300';
      END IF;
      -- Normal test run:
      SET @statement_mysql_unit = CONCAT('SELECT ', record_ref_expression, ' INTO @expression_mysql_unit');
      PREPARE eval_mysql_unit FROM @statement_mysql_unit;
      EXECUTE eval_mysql_unit;
      
      SET record_assertion = ASSERT(@expression_mysql_unit, record_ref_value);
      SET record_prev_id   = record_id;
   END LOOP;
   CLOSE tests;
END//
DELIMITER ;