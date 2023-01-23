-- @conn pgbook
SELECT *
FROM bookings.aircrafts;
SELECT *
FROM bookings.airports;
SELECT *
FROM bookings.aircrafts
WHERE model LIKE 'Airbus%';
SELECT *
FROM bookings.aircrafts
WHERE model NOT LIKE 'Airbus%'
    AND model NOT LIKE 'Boeing%';
SELECT *
FROM bookings.airports
WHERE airport_name LIKE '___';
SELECT *
FROM bookings.aircrafts
WHERE model ~ '^(A|Boe)';
SELECT *
FROM bookings.aircrafts
WHERE model !~ '300$';
SELECT *
FROM bookings.aircrafts
WHERE range BETWEEN 3000 AND 6000;
SELECT model,
    range,
    range / 1.609 AS miles
FROM bookings.aircrafts;
SELECT model,
    range,
    round(range / 1.609, 2) AS miles
FROM bookings.aircrafts;
SELECT *
FROM bookings.aircrafts
ORDER BY range DESC;
-- аэропорты
SELECT timezone
FROM bookings.airports;
SELECT DISTINCT timezone
FROM bookings.airports
ORDER BY 1;
SELECT airport_name,
    city,
    longitude
FROM bookings.airports
ORDER BY longitude DESC
LIMIT 3;
SELECT airport_name,
    city,
    longitude
FROM bookings.airports
ORDER BY longitude DESC
LIMIT 3 OFFSET 3;
SELECT model,
    range,
    CASE
        WHEN range < 2000 THEN 'Ближнемагистральный'
        WHEN range < 5000 THEN 'Среднемагистральный'
        ELSE 'Дальнемагистральный'
    END AS type
FROM bookings.aircrafts
ORDER BY model;