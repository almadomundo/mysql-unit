-- Release session variables

DROP PROCEDURE IF EXISTS RELEASE_VARIABLES;
DELIMITER //
CREATE PROCEDURE RELEASE_VARIABLES(scope VARCHAR(255))
BEGIN
   DECLARE done              INT DEFAULT FALSE;
   DECLARE record_var_name   VARCHAR(255) DEFAULT '';
   DECLARE error             VARCHAR(255) DEFAULT '';
   DECLARE message           VARCHAR(255) DEFAULT '';
   DECLARE variables CURSOR FOR 
      SELECT
         var_name
      FROM
         test_service_variables
      WHERE
         origin = scope;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   BEGIN
      GET DIAGNOSTICS CONDITION 1
         error   = RETURNED_SQLSTATE,
         message = MESSAGE_TEXT;
      -- Popup exception in stack, if it's derived from released variable
      IF error = '80600' THEN
         SIGNAL SQLSTATE '80600' SET MESSAGE_TEXT = message;
      END IF;
      -- Throw custom exception otherwise 
      -- (like test_service_variables table does not exist):
      SIGNAL SQLSTATE '80700' SET MESSAGE_TEXT = 'Release session variables failed';
   END;

   OPEN variables;
   read_loop: LOOP
      FETCH variables INTO record_var_name;
      IF done THEN
         LEAVE read_loop;
      END IF;
      CALL RELEASE_SESSION_VARIABLE(record_var_name);
   END LOOP;
   CLOSE variables;
END//
DELIMITER ;