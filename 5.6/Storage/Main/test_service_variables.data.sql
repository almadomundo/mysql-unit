TRUNCATE test_service_variables;

INSERT INTO test_service_variables
(origin, var_name, init_value)
VALUES
('PROCEDURE', '@thrown_sqlstate_mysql_unit', ''),
('PROCEDURE', '@thrown_message_mysql_unit', ''),
('PROCEDURE', '@thrown_code_mysql_unit', ''),
('PROCEDURE', '@record_id_mysql_unit', 0),
('PROCEDURE', '@record_expression_mysql_unit', ''),
('PROCEDURE', '@record_value_mysql_unit', ''),
('PROCEDURE', '@record_is_error_mysql_unit', 0),
('PROCEDURE', '@record_error_code_mysql_unit', ''),
('PROCEDURE', '@record_thrown_code_mysql_unit', ''),
('PROCEDURE', '@record_error_text_mysql_unit', ''),
('PROCEDURE', '@statement_mysql_unit', ''),
('PROCEDURE', '@expression_mysql_unit', ''),

('FUNCTION', '@thrown_sqlstate_mysql_unit', ''),
('FUNCTION', '@thrown_message_mysql_unit', ''),
('FUNCTION', '@thrown_code_mysql_unit', ''),
('FUNCTION', '@record_id_mysql_unit', 0),
('FUNCTION', '@record_expression_mysql_unit', ''),
('FUNCTION', '@record_value_mysql_unit', ''),
('FUNCTION', '@record_is_error_mysql_unit', 0),
('FUNCTION', '@record_error_code_mysql_unit', ''),
('FUNCTION', '@record_thrown_code_mysql_unit', ''),
('FUNCTION', '@record_error_text_mysql_unit', ''),
('FUNCTION', '@statement_mysql_unit', ''),
('FUNCTION', '@expression_mysql_unit', '');