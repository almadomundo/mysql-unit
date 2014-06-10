-- Procedure assertions storage package

DROP TABLE IF EXISTS TEST_PROCEDURE_RESULTS;

CREATE TABLE TEST_PROCEDURE_RESULTS
(
   `id`              INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
   `test_id`         INT(11) UNSIGNED, 
   `ref_expression`  VARCHAR(255),
   `ref_value`       VARCHAR(255)
);