-- @conn pgbook
CREATE VIEW bookings.seats_by_fare_cond AS
SELECT aircraft_code,
    fare_conditions,
    count(*)
FROM bookings.seats
GROUP BY aircraft_code,
    fare_conditions
ORDER BY aircraft_code,
    fare_conditions;
SELECT *
FROM bookings.seats_by_fare_cond;
-- изменить название столбца 1
DROP VIEW bookings.seats_by_fare_cond;
CREATE OR REPLACE VIEW bookings.seats_by_fare_cond AS
SELECT aircraft_code,
    fare_conditions,
    count(*) AS num_seats
FROM bookings.seats
GROUP BY aircraft_code,
    fare_conditions
ORDER BY aircraft_code,
    fare_conditions;
SELECT *
FROM bookings.seats_by_fare_cond;
-- изменить название столбца 2
DROP VIEW bookings.seats_by_fare_cond;
CREATE OR REPLACE VIEW bookings.seats_by_fare_cond (code, fare_cond, num_seats) AS
SELECT aircraft_code,
    fare_conditions,
    count(*)
FROM bookings.seats
GROUP BY aircraft_code,
    fare_conditions
ORDER BY aircraft_code,
    fare_conditions;
SELECT *
FROM bookings.seats_by_fare_cond;
-- мат. представление
REFRESH MATERIALIZED VIEW bookings.routes;