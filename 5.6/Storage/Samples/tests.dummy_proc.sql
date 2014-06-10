-- Tests for dummy procedure
-- dummy_proc should:
-- 1. Create table in current database with name as passed first argument
-- 2. Add second argument to created table as a column
-- 3. Set type of column as third argument

DELETE FROM TEST_PROCEDURE_ASSERTIONS WHERE procedure_name='dummy_proc';

INSERT INTO TEST_PROCEDURE_ASSERTIONS
(`procedure_name`, `is_error`, `error_code`)
VaLUES
('dummy_proc', 0, NULL);

SET @test_id_tmp_mysql_unit:=LAST_INSERT_ID();
SET @test_db_tmp_mysql_unit:=DATABASE();

INSERT INTO TEST_PROCEDURE_ARGUMENTS
(`test_id`, `argument_value`)
VALUES
(@test_id_tmp_mysql_unit, '"foo"'),
(@test_id_tmp_mysql_unit, '"bar"'),
(@test_id_tmp_mysql_unit, '"VARCHAR(255)"');

INSERT INTO TEST_PROCEDURE_RESULTS
(`test_id`, `ref_type`, `ref_database`, `ref_table`, `ref_name`, `ref_exists`, `ref_expression`, `ref_value`)
VALUES
(@test_id_tmp_mysql_unit, 'TABLE', @test_db_tmp_mysql_unit, NULL, 'foo', 1, '1=1', '1'),
(@test_id_tmp_mysql_unit, 'COLUMN', @test_db_tmp_mysql_unit, 'foo', 'bar', 1, CONCAT('GET_TYPE("', @test_db_tmp_mysql_unit, '", "foo", "bar")'), 'VARCHAR(255)');