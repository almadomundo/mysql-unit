-- Table for service variables, which are used in mysql-unit
-- It will be used for environment integrity check before tests run

DROP TABLE IF EXISTS test_service_variables;

CREATE TABLE test_service_variables
(
   id INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
   origin VARCHAR(255) NOT NULL,
   var_name VARCHAR(255) NOT NULL,
   init_value VARCHAR(255)
);