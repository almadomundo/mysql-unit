-- Get error message for test & result error code mismatch (State 80300)
DROP FUNCTION IF EXISTS GET_ERROR_FOR_SPECIFIC_CODE;
DELIMITER //
CREATE FUNCTION GET_ERROR_FOR_SPECIFIC_CODE(id INT)
RETURNS VARCHAR(255)
BEGIN
   RETURN CONCAT(
      'Test id < ', 
      id, 
      ' > : expectation of specific ERROR CODE failed.'
   );
END//
DELIMITER ;