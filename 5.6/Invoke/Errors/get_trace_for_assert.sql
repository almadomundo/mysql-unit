-- Get error trace for assertion (State 80000)
DROP PROCEDURE IF EXISTS GET_TRACE_FOR_ASSERT;
DELIMITER //
CREATE PROCEDURE GET_TRACE_FOR_ASSERT(
   test_id INT, 
   test_expression VARCHAR(255),
   test_value VARCHAR(255)
)
BEGIN
   SELECT 
      test_id,
      test_expression,
      test_value,
      NULL AS test_is_error,
      NULL AS test_error_code_expected,
      NULL AS test_error_code_thrown,
      NULL AS test_error_message_thrown,
      CONCAT(
         'Test id < ', 
         test_id, 
         ' > : assertion that expression ( ', 
         test_expression, 
         ' ) is "', 
         test_value, 
         '", failed.'
      ) AS test_trace;
END//
DELIMITER ;