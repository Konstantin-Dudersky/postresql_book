-- @conn pgbook
-- # 1
CREATE TABLE test_numeric (measurement numeric(5, 2), description text);
SELECT *
FROM test_numeric;
INSERT INTO test_numeric
VALUES (999.9999, 'Какое-то измерение');
INSERT INTO test_numeric
VALUES (999.9009, 'Еще одно измерение');
INSERT INTO test_numeric
VALUES (999.1111, 'И еще одно измерение');
INSERT INTO test_numeric
VALUES (998.9999, 'И еще одно');
INSERT INTO test_numeric
VALUES (1000, '');
-- # 2
DROP TABLE test_numeric;
CREATE TABLE test_numeric (measurement numeric, description text);
INSERT INTO test_numeric
VALUES (1234567890.09876543210, ''),
    (1.5, ''),
    (0.1234567901234567890, ''),
    (1234567890, '');
SELECT *
FROM test_numeric;
-- # 3
SELECT 'NaN'::numeric > 10000;
SELECT 'NaN'::numeric = 'NaN'::numeric;
-- # 4
SELECT '5e-324'::double precision > '4e-324'::double precision;
SELECT '5e307'::double precision > '4e307'::double precision;
-- # 5
SELECT 'Inf'::double precision > '1e+308'::double precision;
SELECT '-Inf'::double precision < '-1e+308'::double precision;
-- # 6
SELECT 0.0 * 'Inf'::real;
SELECT 'NaN'::real = 'NaN'::real;
SELECT 'NaN'::real > '1e308'::double precision;
SELECT 'NaN'::real > 'Inf'::double precision;
-- # 7
CREATE TABLE test_serial (id serial, name text);
INSERT INTO test_serial (name)
VALUES ('Вишневая');
INSERT INTO test_serial (name)
VALUES ('Грушевая');
INSERT INTO test_serial (name)
VALUES ('Зеленая');
SELECT *
FROM test_serial;
INSERT INTO test_serial (id, name)
VALUES (10, 'Прохладная');
SELECT *
FROM test_serial;
INSERT INTO test_serial (name)
VALUES ('Луговая');
SELECT *
FROM test_serial;
-- # 8
DROP TABLE test_serial;
CREATE TABLE test_serial (id serial PRIMARY KEY, name text);
INSERT INTO test_serial (name)
VALUES ('Вишневая');
SELECT *
FROM test_serial;
INSERT INTO test_serial (id, name)
VALUES (2, 'Прохладная');
SELECT *
FROM test_serial;
INSERT INTO test_serial (name)
VALUES ('Грушевая');
INSERT INTO test_serial (name)
VALUES ('Грушевая');
SELECT *
FROM test_serial;
INSERT INTO test_serial (name)
VALUES ('Зеленая');
SELECT *
FROM test_serial;
DELETE FROM test_serial
WHERE id = 4;
SELECT *
FROM test_serial;
INSERT INTO test_serial (name)
VALUES ('Луговая');
SELECT *
FROM test_serial;
-- # 9
-- # 10
-- # 11
SELECT current_time;
SELECT CURRENT_TIME::time(0);
SELECT CURRENT_TIME::time(3);
SELECT current_date;
-- # 12
-- # 13
-- # 14
-- # 15
-- # 16
-- # 17
-- # 18
-- # 19
-- # 20
-- # 21
-- # 22
-- # 23
-- # 24
-- # 25
-- # 26
-- # 27
-- # 28
-- # 29
-- # 30
-- # 31
-- # 32
-- # 33
-- # 34
-- # 35
-- # 36
-- # 37