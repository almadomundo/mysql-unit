-- Get error message for assertion (State 80000)
DROP FUNCTION IF EXISTS GET_ERROR_FOR_ASSERT;
DELIMITER //
CREATE FUNCTION GET_ERROR_FOR_ASSERT(id INT)
RETURNS VARCHAR(255)
BEGIN
   RETURN CONCAT('Test id < ', id, ' > : assertion failed');
END//
DELIMITER ;