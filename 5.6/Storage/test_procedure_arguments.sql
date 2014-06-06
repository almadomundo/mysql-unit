-- Procedure assertions storage package

DROP TABLE IF EXISTS TEST_PROCEDURE_ARGUMENTS;

CREATE TABLE TEST_PROCEDURE_ARGUMENTS
(
   `id`             INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
   `test_id`        INT(11) UNSIGNED, 
   `argument_value` VARCHAR(255),
   `argument_type`  VARCHAR(255)
);