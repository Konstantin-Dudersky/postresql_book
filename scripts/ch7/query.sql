-- @conn pgbook
-- решение
DELETE FROM aircrafts_tmp;
INSERT INTO aircrafts_tmp
SELECT *
FROM bookings.aircrafts
ORDER BY model
RETURNING *;
WITH aircraft_seats AS (
    SELECT aircraft_code,
        model,
        seats_num,
        rank() OVER (
            PARTITION BY left(model, strpos(model, ' ') - 1)
            ORDER BY seats_num
        )
    FROM (
            SELECT a.aircraft_code,
                a.model,
                count(*) AS seats_num
            FROM aircrafts_tmp AS a,
                bookings.seats AS s
            WHERE a.aircraft_code = s.aircraft_code
            GROUP BY 1,
                2
        ) AS seats_numbers
)
DELETE FROM aircrafts_tmp AS a USING aircraft_seats AS a_s
WHERE a.aircraft_code = a_s.aircraft_code
    AND left(a.model, strpos(a.model, ' ') - 1) IN ('Boeing', 'Airbus')
    AND a_s.rank = 1
RETURNING *;
SELECT *
FROM aircrafts_tmp;