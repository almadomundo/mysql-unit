-- Register session variables

DROP PROCEDURE IF EXISTS REGISTER_VARIABLES;
DELIMITER //
CREATE PROCEDURE REGISTER_VARIABLES(scope VARCHAR(255))
BEGIN
   DECLARE done              INT DEFAULT FALSE;
   DECLARE record_var_name   VARCHAR(255) DEFAULT '';
   DECLARE record_init_value VARCHAR(255) DEFAULT '';
   DECLARE error             VARCHAR(255) DEFAULT '';
   DECLARE message           VARCHAR(255) DEFAULT '';
   DECLARE variables CURSOR FOR 
      SELECT
         var_name,
         init_value
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
      -- Popup exception in stack, if it's derived from registered variable
      IF error = '80600' THEN
         SIGNAL SQLSTATE '80600' SET MESSAGE_TEXT = message;
      END IF;
      -- Throw custom exception otherwise 
      -- (like test_service_variables table does not exist):
      SIGNAL SQLSTATE '80700' SET MESSAGE_TEXT = 'Register session variables failed';
   END;

   OPEN variables;
   read_loop: LOOP
      FETCH variables INTO record_var_name, record_init_value;
      IF done THEN
         LEAVE read_loop;
      END IF;
      CALL REGISTER_SESSION_VARIABLE(record_var_name, record_init_value);
   END LOOP;
   CLOSE variables;
END//
DELIMITER ;