-- Get error message for sql exception & result mismatch (State 80400)
DROP FUNCTION IF EXISTS GET_ERROR_FOR_EXPRESSION_EXCEPTION;
DELIMITER //
CREATE FUNCTION GET_ERROR_FOR_EXPRESSION_EXCEPTION(id INT, expectation INT)
RETURNS VARCHAR(255)
BEGIN
   RETURN CONCAT(
      'Test id < ', 
      id, 
      ' > : expectation of ',
      IF(expectation, 'ERROR', 'VALIDITY'),
      ' failed.');
END//
DELIMITER ;