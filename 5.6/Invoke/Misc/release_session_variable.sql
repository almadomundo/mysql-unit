-- Release session variable, used for safe launches

DROP PROCEDURE IF EXISTS RELEASE_SESSION_VARIABLE;
DELIMITER //
CREATE PROCEDURE RELEASE_SESSION_VARIABLE(var_name VARCHAR(255))
BEGIN
   IF @release_session_checker_mysql_unit IS NOT NULL THEN
      SIGNAL SQLSTATE '80600' SET MESSAGE_TEXT = 'Session variable "@release_session_checker_mysql_unit" is in use';
   END IF;
   IF @release_session_eval_mysql_unit IS NOT NULL THEN
      SIGNAL SQLSTATE '80600' SET MESSAGE_TEXT = 'Session variable "@release_session_eval_mysql_unit" is in use';
   END IF;
   SET @release_session_checker_mysql_unit = NULL;
   SET @release_session_eval_mysql_unit    = NULL;

   IF SUBSTR(var_name, 1, 1)!='@' THEN
      SET var_name=CONCAT('@', var_name);
   END IF;

   SET @release_session_eval_mysql_unit = CONCAT('SELECT NULL INTO ', var_name);
   PREPARE eval_release_mysql_unit FROM @release_session_eval_mysql_unit;
   EXECUTE eval_release_mysql_unit;

   SET @release_session_checker_mysql_unit = NULL;
   SET @release_session_eval_mysql_unit    = NULL;
END//
DELIMITER ;