-- @conn pgbook
-- 1
SELECT count(*)
FROM bookings.tickets;
SELECT passenger_name
FROM bookings.tickets
LIMIT 5;
SELECT count(*)
FROM bookings.tickets
WHERE passenger_name LIKE '% %';
SELECT count(*)
FROM bookings.tickets
WHERE passenger_name LIKE '% % %';
SELECT count(*)
FROM bookings.tickets
WHERE passenger_name LIKE '% %%';
-- 2
SELECT passenger_name
FROM bookings.tickets
WHERE passenger_name LIKE '___ %';
SELECT passenger_name
FROM bookings.tickets
WHERE passenger_name LIKE '% _____';
-- 3
SELECT passenger_name
FROM bookings.tickets
WHERE passenger_name SIMILAR TO '% _____';
-- 4
;
-- 5
;
-- 6
SELECT r.flight_no,
    a.model
FROM bookings.routes AS r
    JOIN bookings.aircrafts AS a ON r.aircraft_code = a.aircraft_code
LIMIT 20;
-- 7
SELECT DISTINCT LEAST(r.departure_city, r.arrival_city),
    GREATEST(r.departure_city, r.arrival_city)
FROM bookings.routes AS r
    JOIN bookings.aircrafts AS a ON r.aircraft_code = a.aircraft_code
WHERE a.model = 'Boeing 777-300'
ORDER BY 1;
-- 8
;
-- 9
SELECT departure_city,
    arrival_city,
    count(*)
FROM bookings.routes
WHERE departure_city = 'Москва'
    AND arrival_city = 'Санкт-Петербург'
GROUP BY departure_city,
    arrival_city;
-- 10
SELECT departure_city,
    count(DISTINCT arrival_city)
FROM bookings.routes
GROUP BY departure_city
ORDER BY count DESC;
-- 11
SELECT r.arrival_city,
    sum(array_length(r.days_of_week, 1))
FROM bookings.routes AS r
WHERE r.departure_city = 'Москва'
GROUP BY r.arrival_city
ORDER BY 2 DESC
LIMIT 10;
-- 12
SELECT dw.name_of_day,
    count(*) AS num_flights
FROM (
        SELECT unnest(days_of_week) AS num_of_day
        FROM bookings.routes
        WHERE departure_city = 'Москва'
    ) AS r,
    unnest(
        '{"Пн.", "Вт.", "Ср.", "Чт.", "Пт.", "Сб.", "Вс."}'::text []
    ) WITH ORDINALITY AS dw (name_of_day)
WHERE r.num_of_day = dw.ordinality
GROUP BY r.num_of_day,
    dw.name_of_day
ORDER BY r.num_of_day;
-- 13
SELECT f.departure_city,
    f.arrival_city,
    max(tf.amount),
    min(tf.amount)
FROM bookings.flights_v AS f
    LEFT OUTER JOIN bookings.ticket_flights AS tf ON f.flight_id = tf.flight_id
GROUP BY 1,
    2
ORDER BY 1,
    2;
-- 14
SELECT right(
        passenger_name,
        length(passenger_name) - strpos(passenger_name, ' ')
    ) AS last_name,
    count(*)
FROM bookings.tickets
GROUP BY 1
ORDER BY 2 DESC;
-- 15
SELECT *,
    rank() OVER (
        PARTITION BY timezone
        ORDER BY latitude
    )
FROM bookings.airports
ORDER BY latitude;
-- 16
SELECT a.model,
    count(*) FILTER (
        WHERE s.fare_conditions = 'Business'
    )
FROM bookings.seats AS s
    JOIN bookings.aircrafts AS a ON s.aircraft_code = a.aircraft_code
GROUP BY a.model
ORDER BY 2 DESC;
-- 17
SELECT a.aircraft_code,
    a.model,
    s.fare_conditions,
    count(*)
FROM bookings.aircrafts AS a
    JOIN bookings.seats AS s ON a.aircraft_code = s.aircraft_code
GROUP BY 1,
    2,
    3
ORDER BY 1;
-- 18
SELECT a.aircraft_code as a_code,
    a.model,
    r.aircraft_code as r_code,
    count(*) AS num_routes,
    count(*) / (
        SELECT count(*)
        FROM bookings.routes AS r
    )::float
FROM bookings.routes r
    JOIN bookings.aircrafts a ON r.aircraft_code = a.aircraft_code
GROUP BY 1,
    2,
    3
ORDER BY 4 DESC;
-- 19
WITH RECURSIVE ranges (min_sum, max_sum, level) AS (
    VALUES (0, 100000, 0),
        (100000, 200000, 0),
        (200000, 300000, 0)
    UNION
    SELECT min_sum + 100000,
        max_sum + 100000,
        level + 1
    FROM ranges
    WHERE max_sum < (
            SELECT max(total_amount)
            FROM bookings.bookings
        )
)
SELECT *
FROM ranges;
-- 20
WITH RECURSIVE ranges (min_sum, max_sum) AS (
    VALUES (0, 100000)
    UNION ALL
    SELECT min_sum + 100000,
        max_sum + 100000
    FROM ranges
    WHERE max_sum < (
            SELECT max(total_amount)
            FROM bookings.bookings
        )
)
SELECT r.min_sum,
    r.max_sum,
    --count(b.*)
    count(*)
FROM bookings.bookings AS b
    RIGHT OUTER JOIN ranges as r ON b.total_amount >= r.min_sum
    AND b.total_amount < r.max_sum
GROUP BY r.min_sum,
    r.max_sum
ORDER BY r.min_sum;
-- 21
SELECT DISTINCT a.city
FROM bookings.airports AS a
WHERE NOT EXISTS (
        SELECT *
        FROM bookings.routes AS r
        WHERE r.departure_city = 'Москва'
            AND r.arrival_city = a.city
    )
    AND a.city <> 'Москва'
ORDER BY city;
SELECT city
FROM bookings.airports
WHERE city <> 'Москва'
EXCEPT
SELECT arrival_city
FROM bookings.routes
WHERE departure_city = 'Москва'
ORDER BY city;
-- 22
SELECT aa.city,
    aa.airport_code,
    aa.airport_name
FROM (
        SELECT city
        FROM bookings.airports
        GROUP BY city
        HAVING count(*) > 1
    ) AS a
    JOIN bookings.airports AS aa ON a.city = aa.city
ORDER BY aa.city,
    aa.airport_name;
-- 23
with all_cities AS (
    SELECT DISTINCT city
    FROM bookings.airports
)
SELECT count(*)
FROM all_cities AS a1
    JOIN all_cities AS a2 ON a1.city <> a2.city;
-- 24
SELECT departure_city,
    count(*)
FROM bookings.routes
GROUP BY departure_city
HAVING departure_city = ANY (
        SELECT city
        FROM bookings.airports
        WHERE longitude > 150
    )
ORDER BY count DESC;
-- 25
WITH tickets_seats AS (
    SELECT f.flight_id,
        f.flight_no,
        f.departure_city,
        f.arrival_city,
        f.aircraft_code,
        tf.fare_conditions,
        count(tf.ticket_no) AS fact_passangers,
        (
            SELECT count(s.seat_no)
            FROM bookings.seats AS s
            WHERE s.aircraft_code = f.aircraft_code
        ) AS total_seats
    FROM bookings.flights_v AS f
        JOIN bookings.ticket_flights AS tf ON f.flight_id = tf.flight_id
    WHERE f.status = 'Arrived'
    GROUP BY 1,
        2,
        3,
        4,
        5,
        6
)
SELECT ts.departure_city,
    ts.arrival_city,
    ts.fare_conditions,
    sum(ts.fact_passangers) AS sum_pass,
    sum(ts.total_seats) AS sum_seats,
    round(
        sum(ts.fact_passangers)::numeric / sum(ts.total_seats)::numeric,
        2
    ) AS frac
FROM tickets_seats as ts
GROUP BY ts.departure_city,
    ts.arrival_city,
    ts.fare_conditions
ORDER BY ts.departure_city,
    frac DESC;
-- 26
WITH passengers AS (
    SELECT t.passenger_name,
        b.seat_no,
        t.contact_data->'email' AS email
    FROM (
            bookings.ticket_flights AS tf
            JOIN bookings.tickets AS t ON tf.ticket_no = t.ticket_no
        )
        JOIN bookings.boarding_passes AS b ON tf.ticket_no = b.ticket_no
        AND tf.flight_id = b.flight_id
    WHERE tf.flight_id = 27584
)
SELECT s.seat_no,
    p.passenger_name,
    p.email,
    s.fare_conditions
FROM bookings.seats AS s
    LEFT OUTER JOIN passengers AS p ON s.seat_no = p.seat_no
WHERE s.aircraft_code = 'SU9'
ORDER BY left(s.seat_no, length(s.seat_no) - 1)::integer,
    right(s.seat_no, 1);