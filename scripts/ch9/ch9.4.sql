-- @conn pgbook
-- non-repeatable read
-- первый
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM aircrafts_tmp;
-- второй
BEGIN ISOLATION LEVEL REPEATABLE READ;
INSERT INTO aircrafts_tmp
VALUES ('IL9', 'Ilyushin IL96', 9800);
UPDATE aircrafts_tmp
SET range = range + 100
WHERE aircraft_code = '320';
END;
-- первый
SELECT * FROM aircrafts_tmp;
END;
SELECT * FROM aircrafts_tmp;
-- serialization
-- первый
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE aircrafts_tmp
SET range = range + 100
WHERE aircraft_code = '320';
-- второй
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE aircrafts_tmp
SET range = range + 200
WHERE aircraft_code = '320';
-- первый
END;
-- второй
END;
