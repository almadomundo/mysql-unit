-- Version

DELIMITER //
CREATE FUNCTION MYSQL_UNIT_VERSION()
RETURNS VARCHAR(255)
BEGIN
   RETURN '0.1-alfa';
END//
DELIMITER ;