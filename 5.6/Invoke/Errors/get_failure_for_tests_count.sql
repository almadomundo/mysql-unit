-- Get failure state when tests were not found (State 80100)
DROP PROCEDURE IF EXISTS GET_FAILURE_FOR_TESTS_COUNT;
DELIMITER //
CREATE PROCEDURE GET_FAILURE_FOR_TESTS_COUNT(
   test_id INT, 
   test_expression VARCHAR(255),
   d INT
)
BEGIN
   DECLARE message VARCHAR(255) DEFAULT '';
   IF d THEN
      CALL GET_TRACE_FOR_TESTS_COUNT(
         test_id,
         test_expression
      );          
   END IF;
   SET message = GET_ERROR_FOR_TESTS_COUNT();
   SIGNAL SQLSTATE '80100' SET MESSAGE_TEXT = message;
END//
DELIMITER ;