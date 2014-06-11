-- Register session variable, used for safe launches

DROP PROCEDURE IF EXISTS REGISTER_SESSION_VARIABLE;
DELIMITER //
CREATE PROCEDURE REGISTER_SESSION_VARIABLE(var_name VARCHAR(255), init_value VARCHAR(255))
BEGIN
   DECLARE message VARCHAR(255) DEFAULT '';

   IF @register_session_checker_mysql_unit IS NOT NULL THEN
      SIGNAL SQLSTATE '80600' SET MESSAGE_TEXT = 'Session variable "@register_session_checker_mysql_unit" is in use';
   END IF;
   IF @register_session_eval_mysql_unit IS NOT NULL THEN
      SIGNAL SQLSTATE '80600' SET MESSAGE_TEXT = 'Session variable "@register_session_eval_mysql_unit" is in use';
   END IF;
   SET @register_session_checker_mysql_unit = NULL;
   SET @register_session_eval_mysql_unit    = NULL;

   IF SUBSTR(var_name, 1, 1)!='@' THEN
      SET var_name=CONCAT('@', var_name);
   END IF;
   -- Get variable "var_name" value:
   SET @register_session_eval_mysql_unit = CONCAT('SELECT ', var_name, ' INTO @register_session_checker_mysql_unit');
   PREPARE eval_register_mysql_unit FROM @register_session_eval_mysql_unit;
   EXECUTE eval_register_mysql_unit;
   -- If it is not null, then variable is used. Terminate:
   IF @register_session_checker_mysql_unit IS NOT NULL THEN
      SET @register_session_checker_mysql_unit = NULL;
      SET @register_session_eval_mysql_unit    = NULL;
      SET message = CONCAT('Session variable "', var_name, '" is in use');
      SIGNAL SQLSTATE '80600' SET MESSAGE_TEXT = message;
   END IF;
   -- Finally, init "var_name" with "init_value"
   SET @register_session_eval_mysql_unit = CONCAT('SELECT "', init_value, '" INTO ', var_name);
   PREPARE eval_register_mysql_unit FROM @register_session_eval_mysql_unit;
   EXECUTE eval_register_mysql_unit;

   SET @register_session_checker_mysql_unit = NULL;
   SET @register_session_eval_mysql_unit    = NULL;
END//
DELIMITER ;