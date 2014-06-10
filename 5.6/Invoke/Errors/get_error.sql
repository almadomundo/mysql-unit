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
   tested_test_id VARCHAR(255)
)
BEGIN
   IF sql_state = '80000' THEN
      CALL GET_FAILURE_FOR_ASSERT(
         test_id,
         test_expression,
         test_value,
         d
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
   -- From checking if it was error mismatch
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
END//
DELIMITER ;