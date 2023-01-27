-- @conn pgbook
SELECT count(*)
FROM bookings.bookings
WHERE total_amount > (
        SELECT avg(total_amount)
        FROM bookings.bookings
    );
SELECT count(*)
FROM bookings.bookings
WHERE total_amount > (
        SELECT avg(total_amount)
        FROM bookings.bookings
    );
SELECT flight_no,
    departure_city,
    arrival_city
FROM bookings.routes
WHERE departure_city IN (
        SELECT city
        FROM bookings.airports
        WHERE timezone ~ 'Krasnoyarsk'
    )
    AND arrival_city IN (
        SELECT city
        FROM bookings.airports
        WHERE timezone ~ 'Krasnoyarsk'
    );
SELECT airport_name,
    city,
    longitude
FROM bookings.airports
WHERE longitude IN (
        (
            SELECT max(longitude)
            from bookings.airports
        ),
        (
            SELECT min(longitude)
            from bookings.airports
        )
    )
ORDER BY longitude;
SELECT DISTINCT a.city
FROM bookings.airports a
WHERE NOT EXISTS (
        SELECT *
        FROM bookings.routes r
        WHERE r.departure_city = 'Москва'
            AND r.arrival_city = a.city
    )
ORDER BY city;
SELECT a.model,
    (
        SELECT count(*)
        FROM bookings.seats s
        WHERE s.aircraft_code = a.aircraft_code
            AND s.fare_conditions = 'Business'
    ) AS business,
    (
        SELECT count(*)
        FROM bookings.seats s
        WHERE s.aircraft_code = a.aircraft_code
            AND s.fare_conditions = 'Comfort'
    ) AS comfort,
    (
        SELECT count(*)
        FROM bookings.seats s
        WHERE s.aircraft_code = a.aircraft_code
            AND s.fare_conditions = 'Economy'
    ) AS economy
FROM bookings.aircrafts a
ORDER BY 1;
SELECT s2.model,
    string_agg(
        s2.fare_conditions || ' (' || s2.num || ')',
        ', '
    )
FROM (
        SELECT a.model,
            s.fare_conditions,
            count(*) AS num
        FROM bookings.aircrafts a
            JOIN bookings.seats s ON a.aircraft_code = s.aircraft_code
        GROUP BY 1,
            2
        ORDER BY 1,
            2
    ) AS s2
GROUP BY s2.model
ORDER BY s2.model;
SELECT aa.city,
    aa.airport_code,
    aa.airport_name
FROM (
        SELECT city,
            count(*)
        FROM bookings.airports
        GROUP BY city
        HAVING count(*) > 1
    ) AS a
    JOIN bookings.airports AS aa ON a.city = aa.city
ORDER BY aa.city,
    aa.airport_name;
SELECT departure_airport,
    departure_city,
    count(*)
FROM bookings.routes
GROUP BY departure_airport,
    departure_city
HAVING departure_airport IN (
        SELECT airport_code
        FROM bookings.airports
        WHERE longitude > 150
    )
ORDER BY count DESC;