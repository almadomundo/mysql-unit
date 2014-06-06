-- Basic tests assertion

DROP FUNCTION IF EXISTS ASSERT;
DELIMITER //
CREATE FUNCTION ASSERT(expr VARCHAR(255), val VARCHAR(255))
RETURNS INT
BEGIN
   DECLARE m VARCHAR(255) DEFAULT '';
   IF expr!=val THEN
      SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = 'Assertion failed';
   END IF;
   RETURN 1;
END//
DELIMITER ;