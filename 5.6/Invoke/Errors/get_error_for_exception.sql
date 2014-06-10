-- Get error message for sql exception & result mismatch (State 80200)
DROP FUNCTION IF EXISTS GET_ERROR_FOR_EXCEPTION;
DELIMITER //
CREATE FUNCTION GET_ERROR_FOR_EXCEPTION(id INT, expectation INT)
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