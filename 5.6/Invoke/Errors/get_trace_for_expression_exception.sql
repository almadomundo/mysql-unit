-- Get error trace for sql exception & result mismatch (State 80400)
DROP PROCEDURE IF EXISTS GET_TRACE_FOR_EXPRESSION_EXCEPTION;
DELIMITER //
CREATE PROCEDURE GET_TRACE_FOR_EXPRESSION_EXCEPTION(
   test_id INT, 
   test_expression VARCHAR(255),
   test_value VARCHAR(255),
   test_is_error INT,
   test_code_expected VARCHAR(255),
   test_code_thrown VARCHAR(255),
   test_message_thrown VARCHAR(255)
)
BEGIN
   SELECT 
      test_id,
      test_expression,
      test_value,
      test_is_error,
      IF(test_is_error, test_code_expected, NULL) AS test_error_code_expected,
      IF(test_is_error, NULL, test_code_thrown) AS test_error_code_thrown,
      IF(test_is_error, NULL, test_message_thrown) AS test_error_message_thrown,
      CONCAT(
         'Test id < ', 
         test_id, 
         ' > : expectation that expression ( ', 
         test_expression, 
         ' ) ',
         IF(test_is_error, 'throws ERROR', 'is VALID'), 
         ' failed.'
      ) AS test_trace;
END//
DELIMITER ;