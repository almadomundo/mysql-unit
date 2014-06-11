-- Get error trace for register session variable (State 80600)
DROP PROCEDURE IF EXISTS GET_TRACE_FOR_REGISTER_VARIABLE;
DELIMITER //
CREATE PROCEDURE GET_TRACE_FOR_REGISTER_VARIABLE(
   var_name VARCHAR(255)
)
BEGIN
   SELECT 
      NULL AS test_id,
      NULL AS test_expression,
      NULL AS test_value,
      NULL AS test_is_error,
      NULL AS test_error_code_expected,
      NULL AS test_error_code_thrown,
      NULL AS test_error_message_thrown,
      CONCAT(
         'Session variable is already in use'
      ) AS test_trace;
END//
DELIMITER ;