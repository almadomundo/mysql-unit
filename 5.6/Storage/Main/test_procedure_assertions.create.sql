-- Procedure assertions storage package

DROP TABLE IF EXISTS TEST_PROCEDURE_ASSERTIONS;

CREATE TABLE TEST_PROCEDURE_ASSERTIONS
(
   `id` INT(11)     UNSIGNED PRIMARY KEY AUTO_INCREMENT,
   `procedure_name` VARCHAR(255),
   `is_error`       TINYINT,
   `error_code`     VARCHAR(255)
);