-- Assert that expression is true (or can be coerced to true)

DROP FUNCTION IF EXISTS ASSERT_TRUE;
DELIMITER //
CREATE FUNCTION ASSERT_TRUE(expr VARCHAR(255))
RETURNS INT
BEGIN
   DECLARE m VARCHAR(255) DEFAULT '';
   IF !expr THEN
      SET m = CONCAT('Assertion that expression is TRUE, failed');
      SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = m;
   END IF;
   RETURN 1;
END//
DELIMITER ;