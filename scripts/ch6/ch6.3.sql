-- @conn pgbook
SELECT avg(total_amount),
    max(total_amount),
    min(total_amount)
FROM bookings.bookings;
SELECT arrival_city,
    count(*)
FROM bookings.routes
WHERE departure_city = 'Москва'
GROUP BY arrival_city
ORDER BY count DESC;
SELECT array_length(days_of_week, 1) AS days_per_week,
    count(*) AS num_routes
FROM bookings.routes
GROUP BY days_per_week
ORDER BY 1 DESC;
SELECT departure_city,
    count(*)
FROM bookings.routes
GROUP BY departure_city
HAVING count(*) >= 15
ORDER BY count DESC;
SELECT city,
    count(*)
FROM bookings.airports
GROUP BY city
HAVING count(*) > 1;
SELECT b.book_ref,
    b.book_date,
    EXTRACT(
        'month'
        from b.book_date
    ) AS month,
    EXTRACT(
        'day'
        from b.book_date
    ) AS day,
    count(*) OVER (
        PARTITION BY date_trunc('month', b.book_date)
        ORDER BY b.book_date
    ) AS count
FROM bookings.ticket_flights tf
    JOIN bookings.tickets t ON tf.ticket_no = t.ticket_no
    JOIN bookings.bookings b ON t.book_ref = b.book_ref
WHERE tf.flight_id = 1
ORDER BY b.book_date;
SELECT airport_name,
    city,
    round(latitude::numeric, 2) AS ltd,
    timezone,
    rank() OVER(
        PARTITION BY timezone
        ORDER BY latitude
    )
FROM bookings.airports
WHERE timezone IN ('Asia/Irkutsk', 'Asia/Krasnoyarsk')
ORDER BY timezone,
    rank;
SELECT airport_name,
    city,
    timezone,
    latitude,
    first_value(latitude) OVER tz AS first_in_timezone,
    latitude - first_value(latitude) OVER tz AS delta,
    rank() OVER tz
FROM bookings.airports
WHERE timezone IN ('Asia/Irkutsk', 'Asia/Krasnoyarsk') WINDOW tz AS (
        PARTITION BY timezone
        ORDER BY latitude DESC
    )
ORDER BY timezone,
    rank