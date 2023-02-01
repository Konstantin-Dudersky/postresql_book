-- @conn pgbook
CREATE INDEX ON bookings.airports (airport_name);
SELECT count(*)
FROM bookings.tickets
WHERE passenger_name = 'IVAN IVANOV';
CREATE INDEX passenger_name ON bookings.tickets (passenger_name);
SELECT count(*)
FROM bookings.tickets
WHERE passenger_name = 'IVAN IVANOV';
DROP INDEX passenger_name;