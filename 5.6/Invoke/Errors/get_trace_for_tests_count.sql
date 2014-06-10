-- Get error trace for tests not found (State 80100)
DROP PROCEDURE IF EXISTS GET_TRACE_FOR_TESTS_COUNT;
DELIMITER //
CREATE PROCEDURE GET_TRACE_FOR_TESTS_COUNT(
   test_id INT, 
   test_expression VARCHAR(255)
)
BEGIN
   SELECT 
      test_id,
      test_expression,
      NULL test_value,
      NULL AS test_is_error,
      NULL AS test_error_code_expected,
      NULL AS test_error_code_thrown,
      NULL AS test_error_message_thrown,
      IF(test_id>0,
         CONCAT(
            'Test < ', 
            test_id, 
            ' > was not found ( '
         ),
         CONCAT(
            'Tests for entity ( ',
            test_expression, 
            ' ) were not found'
         )
      ) AS test_trace;
END//
DELIMITER ;