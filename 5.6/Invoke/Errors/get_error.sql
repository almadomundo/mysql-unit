-- Error handler routing

DROP PROCEDURE IF EXISTS GET_ERROR;
DELIMITER //
CREATE PROCEDURE GET_ERROR(
   sql_state VARCHAR(255),
   test_id INT, 
   test_expression VARCHAR(255),
   test_value VARCHAR(255),
   test_is_error INT,
   test_code_expected VARCHAR(255),
   test_code_thrown VARCHAR(255),
   test_message_thrown VARCHAR(255),
   tested_entity VARCHAR(255),
   tested_is_verbose INT,
   tested_test_id VARCHAR(255),
   tested_origin VARCHAR(255)
)
BEGIN
   -- Important: release variables ONLY if it is not related to
   -- variables register/release issue. Otherwise env. will be harmed:
   IF sql_state!='80600' THEN
      CALL RELEASE_VARIABLES(tested_origin);
   END IF;
   -- Assertion failed somewhere
   IF sql_state = '80000' THEN
      CALL GET_FAILURE_FOR_ASSERT(
         test_id,
         test_expression,
         test_value,
         tested_is_verbose
      );
   END IF;
   -- Tests were not found:
   IF sql_state = '80100' THEN
      CALL GET_FAILURE_FOR_TESTS_COUNT(
         tested_test_id, 
         tested_entity, 
         tested_is_verbose
      );
   END IF;
   -- From checking if it was error mismatch for expressions
   IF sql_state = '80200' THEN
      CALL GET_FAILURE_FOR_EXCEPTION(
         test_id,
         test_expression,
         test_value,
         test_is_error,
         test_code_expected,
         test_code_thrown,
         test_message_thrown,
         tested_is_verbose
      );
   END IF;
   -- Error thrown, but code was wrong:
   IF sql_state = '80300' THEN
      CALL GET_FAILURE_FOR_SPECIFIC_CODE(
         test_id,
         test_expression,
         test_value,
         test_is_error,
         test_code_expected,
         test_code_thrown,
         test_message_thrown,
         tested_is_verbose
      );
   END IF;
   -- From checking if it was error mismatch for procedures
   IF sql_state = '80400' THEN
      CALL GET_FAILURE_FOR_EXPRESSION_EXCEPTION(
         test_id,
         test_expression,
         test_value,
         test_is_error,
         test_code_expected,
         test_code_thrown,
         test_message_thrown,
         tested_is_verbose
      );
   END IF;
   -- Variable register error:
   IF sql_state = '80600' THEN
      CALL GET_FAILURE_FOR_REGISTER_VARIABLE(
         '', 
         tested_is_verbose
      );
   END IF;
END//
DELIMITER ;