-- Get error trace for sql exception code & result mismatch (State 80300)
DROP PROCEDURE IF EXISTS GET_TRACE_FOR_SPECIFIC_CODE;
DELIMITER //
CREATE PROCEDURE GET_TRACE_FOR_SPECIFIC_CODE(
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
      test_code_expected AS test_error_code_expected,
      test_code_thrown AS test_error_code_thrown,
      test_message_thrown AS test_error_message_thrown,
      CONCAT(
         'Test id < ', 
         test_id, 
         ' > : expectation that expression ( ', 
         test_expression, 
         ' ) throws ERROR CODE ', 
         test_code_expected,
         ', failed. Actual ERROR CODE thrown is "', 
         test_code_thrown, 
         '" with message: ', 
         test_message_thrown
      ) AS test_trace;
END//
DELIMITER ;