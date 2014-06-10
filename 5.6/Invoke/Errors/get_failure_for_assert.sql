-- Get error trace for assertion (State 80000)
DROP PROCEDURE IF EXISTS GET_FAILURE_FOR_ASSERT;
DELIMITER //
CREATE PROCEDURE GET_FAILURE_FOR_ASSERT(
   test_id INT, 
   test_expression VARCHAR(255),
   test_value VARCHAR(255),
   d INT
)
BEGIN
   DECLARE message VARCHAR(255) DEFAULT '';
   IF d THEN
      CALL GET_TRACE_FOR_ASSERT(
         test_id,
         test_expression,
         test_value
      );          
   END IF;
   SET message = GET_ERROR_FOR_ASSERT(test_id);
   SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = message;
END//
DELIMITER ;