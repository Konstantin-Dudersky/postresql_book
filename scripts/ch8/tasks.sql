-- @conn pgbook
-- 1
DROP TABLE IF EXISTS test_task1;
CREATE TABLE test_task1 (
    column1 text,
    column2 text
);
CREATE UNIQUE INDEX multiindex
ON test_task1 (column1, column2);
INSERT INTO test_task1 VALUES ('ABC', NULL);
INSERT INTO test_task1 VALUES ('ABC', NULL);
SELECT * FROM test_task1;
INSERT INTO test_task1 VALUES ('ABC', 'DEF');
INSERT INTO test_task1 VALUES ('ABC', 'DEF');
-- 2
SELECT count(*)
FROM bookings.tickets
WHERE passenger_name = 'IVAN IVANOV';
CREATE INDEX ON bookings.tickets (passenger_name);
DROP INDEX bookings.tickets_passenger_name_idx;
-- 3
SELECT count(*)
FROM bookings.ticket_flights
WHERE fare_conditions = 'Comfort';
SELECT count(*)
FROM bookings.ticket_flights
WHERE fare_conditions = 'Business';
SELECT count(*)
FROM bookings.ticket_flights
WHERE fare_conditions = 'Economy';
CREATE INDEX ON bookings.ticket_flights (fare_conditions);
-- before
-- Comfort	0.284	0.289	0.294	0.271	0.292
-- Economy	0.327	0.313	0.318	0.314	0.333
-- after
-- Comfort	0.013	0.043	0.032	0.045	0.025
-- Economy	0.176	0.193	0.171	0.169	0.159
-- 4
DROP INDEX bookings.tickets_passenger_name_idx;
CREATE INDEX ON bookings.tickets (passenger_name DESC NULLS FIRST);
CREATE INDEX ON bookings.tickets (contact_data ASC NULLS LAST);
-- 5
-- 6
-- 7
-- 8
-- 9
-- 10