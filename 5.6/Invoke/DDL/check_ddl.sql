-- Assertion about existense on DDL unit

DROP FUNCTION IF EXISTS CHECK_DDL;
DELIMITER //
CREATE FUNCTION CHECK_DDL(unit_type VARCHAR(255), unit_db VARCHAR(255), unit_table VARCHAR(255), unit_name VARCHAR(255), existense INT)
RETURNS INT
BEGIN
   IF unit_type='FUNCTION' THEN
      RETURN CHECK_DDL_FUNCTION(unit_db, unit_name, existense);
   END IF;
   IF unit_type='PROCEDURE' THEN
      RETURN CHECK_DDL_PROCEDURE(unit_db, unit_name, existense);
   END IF;
   IF unit_type='TABLE' THEN
      RETURN CHECK_DDL_TABLE(unit_db, unit_name, existense);
   END IF;
   IF unit_type='VIEW' THEN
      RETURN CHECK_DDL_VIEW(unit_db, unit_name, existense);
   END IF;
   IF unit_type='COLUMN' THEN
      RETURN CHECK_DDL_COLUMN(unit_db, unit_table, unit_name, existense);
   END IF;
   IF unit_type='TRIGGER' THEN
      RETURN CHECK_DDL_TRIGGER(unit_db, unit_table, unit_name, existense);
   END IF;
   SIGNAL SQLSTATE '80500' SET MESSAGE_TEXT='Specified DDL unit is not yet supported';
END//
DELIMITER ;
