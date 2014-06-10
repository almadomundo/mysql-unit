-- Get failure output for sql exception & result mismatch (State 80200)
DROP PROCEDURE IF EXISTS GET_FAILURE_FOR_EXCEPTION;
DELIMITER //
CREATE PROCEDURE GET_FAILURE_FOR_EXCEPTION(
   test_id INT, 
   test_expression VARCHAR(255),
   test_value VARCHAR(255),
   test_is_error INT,
   test_code_expected VARCHAR(255),
   test_code_thrown VARCHAR(255),
   test_message_thrown VARCHAR(255),
   d INT
)
BEGIN
   DECLARE message VARCHAR(255) DEFAULT '';
   IF d THEN
      CALL GET_TRACE_FOR_EXCEPTION(
         test_id,
         test_expression,
         test_value,
         test_is_error,
         test_code_expected,
         test_code_thrown,
         test_message_thrown
      );          
   END IF;
   SET message = GET_ERROR_FOR_EXCEPTION(test_id, test_is_error);
   SIGNAL SQLSTATE '80200' SET MESSAGE_TEXT = message;
END//
DELIMITER ;