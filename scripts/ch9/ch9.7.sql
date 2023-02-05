-- @conn pgbook
-- блокировка строк
CREATE TABLE aircrafts_tmp
AS SELECT * FROM bookings.aircrafts;
-- первый
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT * 
FROM aircrafts_tmp 
WHERE model ~ '^Air' 
FOR UPDATE;
-- второй
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT * 
FROM aircrafts_tmp 
WHERE model ~ '^Air' 
FOR UPDATE;
-- первый
UPDATE aircrafts_tmp
SET range = 5800
WHERE aircraft_code = '320';
COMMIT;
-- второй
COMMIT;
-- блокировка таблиц
-- первый
BEGIN ISOLATION LEVEL READ COMMITTED;
LOCK TABLE aircrafts_tmp
IN ACCESS EXCLUSIVE MODE;
-- второй
SELECT *
FROM aircrafts_tmp
WHERE model ~ '^Air';
-- первый
ROLLBACK;