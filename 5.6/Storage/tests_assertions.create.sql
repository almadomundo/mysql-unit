-- Table for all tests

DROP TABLE If EXISTS TEST_ASSERTIONS;
CREATE TABLE TEST_ASSERTIONS
(
   `id`            INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
   `function_name` VARCHAR(255) NOT NULL,
   `expression`    VARCHAR(255) NOT NULL,
   `value`         VARCHAR(255),
   `is_error`      TINYINT,
   `error_code`    VARCHAR(255)
);