-- Get error message for case when test were not found (State 80100)
DROP FUNCTION IF EXISTS GET_ERROR_FOR_TESTS_COUNT;
DELIMITER //
CREATE FUNCTION GET_ERROR_FOR_TESTS_COUNT()
RETURNS VARCHAR(255)
BEGIN
   RETURN 'Tests for specified entity name or test number were not found';
END//
DELIMITER ;