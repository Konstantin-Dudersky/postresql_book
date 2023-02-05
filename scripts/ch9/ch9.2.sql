-- @conn pgbook
CREATE TABLE aircrafts_tmp
AS SELECT * FROM bookings.aircrafts;
-- первый
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SHOW transaction_isolation;
UPDATE aircrafts_tmp
SET range = range + 100
WHERE aircraft_code = 'SU9';
SELECT * FROM aircrafts_tmp
WHERE aircraft_code = 'SU9';
-- второй
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM aircrafts_tmp
WHERE aircraft_code = 'SU9';
-- первый
ROLLBACK;
-- второй
ROLLBACK;
