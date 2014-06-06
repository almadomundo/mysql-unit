-- Procedure assertions storage package

DROP TABLE IF EXISTS TEST_PROCEDURE_RESULTS;

CREATE TABLE TEST_PROCEDURE_RESULTS
(
   `id`              INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
   `test_id`         INT(11) UNSIGNED, 
   `ref_type`        VARCHAR(255),
   `ref_name`        VARCHAR(255),
   `ref_state`       VARCHAR(255),
   `ref_expression`  VARCHAR(255),
   `ref_value`       VARCHAR(255),
   `ref_value_type`  VARCHAR(255)
);