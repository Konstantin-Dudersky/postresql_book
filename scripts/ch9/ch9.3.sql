-- @conn pgbook
-- lost update
-- первый
BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;
UPDATE aircrafts_tmp
SET range = range + 100
WHERE aircraft_code = 'SU9';
SELECT * FROM aircrafts_tmp
WHERE aircraft_code = 'SU9';
-- второй
BEGIN;
UPDATE aircrafts_tmp
SET range = range + 200
WHERE aircraft_code = 'SU9';
-- первый
COMMIT;
-- второй
SELECT * FROM aircrafts_tmp
WHERE aircraft_code = 'SU9';
END;
-- non-repeatable read
-- первый
BEGIN;
SELECT * FROM aircrafts_tmp;
-- второй
BEGIN;
DELETE FROM aircrafts_tmp
WHERE model ~ '^Бои';
SELECT * FROM aircrafts_tmp;
END;
-- первый
SELECT * FROM aircrafts_tmp;
END;