-- @conn pgbook
SET
enable_hashjoin = ON;

SET
enable_nestloop = ON;
-- 1
EXPLAIN
SELECT
    *
FROM
    bookings.bookings
ORDER BY
    book_ref;
-- 2
-- 3
EXPLAIN WITH all_cities AS (
SELECT
    DISTINCT city
FROM
    bookings.airports
)
SELECT
    count(*)
FROM
    all_cities AS a1
JOIN all_cities AS a2 ON
    a1.city <> a2.city;
-- 4
EXPLAIN
SELECT
    total_amount
FROM
    bookings.bookings
ORDER BY
    total_amount DESC
LIMIT 5;
-- 5
EXPLAIN
SELECT
    city,
    count(*)
FROM
    bookings.airports
GROUP BY
    city
HAVING
    count(*) > 1;
-- 6
EXPLAIN
SELECT
    *,
    RANK() OVER (
        PARTITION BY timezone
ORDER BY
    latitude
    )
FROM
    bookings.airports
ORDER BY
    latitude;
-- 7
EXPLAIN
DELETE
FROM
    aircrafts
WHERE
    aircraft_code = '800';
-- 8 
EXPLAIN ANALYZE
SELECT
    a.aircraft_code AS a_code,
    a.model,
    (
    SELECT
        count(r.aircraft_code)
    FROM
        routes r
    WHERE
        r.aircraft_code = a.aircraft_code
) AS num_routes
FROM
    aircrafts a
GROUP BY
    1,
    2
ORDER BY
    3 DESC;

EXPLAIN ANALYZE
SELECT
    a.aircraft_code AS a_code,
    a.model,
    count(r.aircraft_code) AS num_routes
FROM
    aircrafts a
LEFT OUTER JOIN routes r 
ON
    r.aircraft_code = a.aircraft_code
GROUP BY
    1,
    2
ORDER BY
    3 DESC;
-- 9
-- 10
-- 11
-- 12
-- 13
-- 14
-- 15
-- 16
-- 17
-- 18
-- 19