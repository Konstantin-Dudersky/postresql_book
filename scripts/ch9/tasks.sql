-- 1
-- 2
DROP TABLE IF EXISTS aircrafts_tmp;
CREATE TABLE aircrafts_tmp
AS SELECT * FROM bookings.aircrafts;
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range < 2000;
UPDATE aircrafts_tmp
SET range = 2100
WHERE aircraft_code = 'CN1';
UPDATE aircrafts_tmp
SET range = 1900
WHERE aircraft_code = 'CR2';
-- второй
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range < 2000;
DELETE FROM aircrafts_tmp WHERE range < 2000;
-- первый
COMMIT;
-- второй
COMMIT;
-- первый
SELECT * FROM aircrafts_tmp;
-- решение
DROP TABLE IF EXISTS aircrafts_tmp;
CREATE TABLE aircrafts_tmp
AS SELECT * FROM bookings.aircrafts;
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range < 2000;
UPDATE aircrafts_tmp
SET range = 2100
WHERE aircraft_code = 'CN1';
UPDATE aircrafts_tmp
SET range = 1900
WHERE aircraft_code = 'CR2';
-- второй
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range < 2000;
DELETE FROM aircrafts_tmp WHERE range < 2000;
-- первый
ROLLBACK;
-- второй
COMMIT;
-- первый
SELECT * FROM aircrafts_tmp;
-- 3
-- 4
DROP TABLE IF EXISTS aircrafts_tmp;
CREATE TABLE aircrafts_tmp
AS SELECT * FROM bookings.aircrafts;
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range > 6000;
-- второй
BEGIN;
UPDATE aircrafts_tmp
SET range = 6100
WHERE aircraft_code = '320';
END;
-- первый
SELECT * FROM aircrafts_tmp
WHERE range > 6000;
END;
-- решение
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range > 6000;
-- второй
BEGIN;
INSERT INTO aircrafts_tmp VALUES ('IL9', 'Test', 6100);
END;
-- первый
SELECT * FROM aircrafts_tmp
WHERE range > 6000;
END;
-- 5
DROP TABLE IF EXISTS aircrafts_tmp;
CREATE TABLE aircrafts_tmp
AS SELECT * FROM bookings.aircrafts;
-- 5.1 подмножество
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range < 10000
FOR UPDATE;
-- второй
SELECT * FROM aircrafts_tmp
WHERE range < 9000
FOR UPDATE;
-- 5.2 надмножество
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range < 9000
FOR UPDATE;
-- второй
SELECT * FROM aircrafts_tmp
WHERE range < 10000
FOR UPDATE;
-- 5.3 пересечение
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range < 9000
FOR UPDATE;
-- второй
SELECT * FROM aircrafts_tmp
WHERE range > 5000
FOR UPDATE;
-- 5.4 нет пересечения
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp
WHERE range < 5000
FOR UPDATE;
-- второй
SELECT * FROM aircrafts_tmp
WHERE range >= 5000
FOR UPDATE;
-- 6
-- 7
-- 8
-- 9
CREATE TABLE modes AS
SELECT num::integer, 'LOW' || num::text AS mode
FROM generate_series(1, 100000) AS gen_ser(num)
UNION ALL
SELECT num::integer, 'HIGH' || (num - 100000)::text AS mode
FROM generate_series(100001, 200000) AS gen_ser(num);
CREATE INDEX modes_ind ON modes(num);
SELECT *
FROM modes
WHERE mode IN ('LOW1', 'HIGH1');
-- первый
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE modes
SET mode = 'HIGH1'
WHERE num = 1;
-- второй
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE modes
SET mode = 'LOW1'
WHERE num = 100001;
-- первый
COMMIT;
-- второй
COMMIT;
SELECT *
FROM modes
WHERE mode IN ('LOW1', 'HIGH1');
-- 10