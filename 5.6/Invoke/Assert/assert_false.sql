-- Assert that expression is false (or can be coerced to false)

DROP FUNCTION IF EXISTS ASSERT_FALSE;
DELIMITER //
CREATE FUNCTION ASSERT_FALSE(expr VARCHAR(255))
RETURNS INT
BEGIN
   DECLARE m VARCHAR(255) DEFAULT '';
   IF expr THEN
      SET m = CONCAT('Assertion that expression is FALSE, failed');
      SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = m;
   END IF;
   RETURN 1;
END//
DELIMITER ;