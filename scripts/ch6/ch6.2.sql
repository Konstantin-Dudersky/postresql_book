-- @conn pgbook
SELECT a.aircraft_code,
    a.model,
    s.seat_no,
    s.fare_conditions
FROM bookings.seats AS s
    JOIN bookings.aircrafts AS a ON s.aircraft_code = a.aircraft_code
WHERE a.model ~ '^Cessna'
ORDER BY s.seat_no;
-- variant 1
SELECT count(*)
FROM bookings.airports a1,
    bookings.airports a2
WHERE a1.city <> a2.city;
-- variant 2
SELECT count(*)
FROM bookings.airports a1
    JOIN bookings.airports a2 ON a1.city <> a2.city;
-- variant 3
SELECT count(*)
FROM bookings.airports a1
    CROSS JOIN bookings.airports a2
WHERE a1.city <> a2.city;
-- сколько маршрутов обслуживают самолеты каждого типа
SELECT r.aircraft_code,
    a.model,
    count(*) AS num_routes
FROM bookings.routes r
    JOIN bookings.aircrafts a ON r.aircraft_code = a.aircraft_code
GROUP BY 1,
    2
ORDER BY 3 DESC;
SELECT a.aircraft_code as a_code,
    a.model,
    r.aircraft_code as r_code,
    count(*) AS num_routes
FROM bookings.aircrafts a
    LEFT OUTER JOIN bookings.routes r ON r.aircraft_code = a.aircraft_code
GROUP BY 1,
    2,
    3
ORDER BY 4 DESC;
-- число пассажиров, не пришедших на регистрацию билетов
SELECT COUNT(*)
FROM (
        bookings.ticket_flights t
        JOIN bookings.flights f ON t.flight_id = f.flight_id
    )
    LEFT OUTER JOIN bookings.boarding_passes b ON t.ticket_no = b.ticket_no
    AND t.flight_id = b.flight_id
WHERE f.actual_departure IS NOT NULL
    AND b.flight_id IS NULL;
-- UNION
SELECT arrival_city
FROM bookings.routes
WHERE departure_city = 'Москва'
UNION
SELECT arrival_city
FROM bookings.routes
WHERE departure_city = 'Санкт-Петербург';
SELECT DISTINCT arrival_city
FROM bookings.routes
WHERE departure_city = 'Москва'
    OR departure_city = 'Санкт-Петербург';
-- INTERSECT
SELECT arrival_city
FROM bookings.routes
WHERE departure_city = 'Москва'
INTERSECT
SELECT arrival_city
FROM bookings.routes
WHERE departure_city = 'Санкт-Петербург'
ORDER BY arrival_city;
-- EXCEPT
SELECT arrival_city
FROM bookings.routes
WHERE departure_city = 'Санкт-Петербург'
EXCEPT
SELECT arrival_city
FROM bookings.routes
WHERE departure_city = 'Москва'
ORDER BY arrival_city;