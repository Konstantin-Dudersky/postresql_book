-- @conn pgbook
DROP TABLE IF EXISTS public.aircrafts_tmp;
CREATE TABLE aircrafts_tmp (
    LIKE bookings.aircrafts INCLUDING CONSTRAINTS INCLUDING INDEXES
);
ALTER TABLE public.aircrafts_tmp
ADD UNIQUE (model);
DROP TABLE IF EXISTS public.aircrafts_log;
CREATE TABLE aircrafts_log AS
SELECT *
FROM bookings.aircrafts WITH NO DATA;
ALTER TABLE public.aircrafts_log
ADD COLUMN when_add timestamp;
ALTER TABLE public.aircrafts_log
ADD COLUMN operation text;
-- скопировать таблицу
WITH add_row AS (
    INSERT INTO aircrafts_tmp
    SELECT *
    FROM bookings.aircrafts
    RETURNING *
)
INSERT INTO aircrafts_log
SELECT add_row.aircraft_code,
    add_row.model,
    add_row.range,
    current_timestamp,
    'INSERT'
FROM add_row;
WITH update_row AS (
    UPDATE aircrafts_tmp
    SET range = range * 1.2
    WHERE model ~ '^Bom'
    RETURNING *
)
INSERT INTO aircrafts_log
SELECT ur.aircraft_code,
    ur.model,
    ur.range,
    current_timestamp,
    'UPDATE'
FROM update_row AS ur;
SELECT *
FROM public.aircrafts_log
WHERE model ~ '^Bom'
ORDER BY when_add;
-- tickets_directions
CREATE TABLE tickets_directions AS
SELECT DISTINCT departure_city,
    arrival_city
FROM bookings.routes;
ALTER TABLE tickets_directions
ADD COLUMN last_ticket_time timestamp;
ALTER TABLE tickets_directions
ADD COLUMN tickets_num integer DEFAULT 0;
-- ticket_flights
CREATE TABLE ticket_flights_tmp AS
SELECT *
FROM bookings.ticket_flights WITH NO DATA;
ALTER TABLE ticket_flights_tmp
ADD PRIMARY KEY (ticket_no, flight_id);
-- добавление записи вариант 1
WITH sell_ticket AS (
    INSERT INTO ticket_flights_tmp (ticket_no, flight_id, fare_conditions, amount)
    VALUES ('1234567890123', 30829, 'Economy', 12800)
    RETURNING *
)
UPDATE tickets_directions AS td
SET last_ticket_time = current_timestamp,
    tickets_num = tickets_num + 1
WHERE (td.departure_city, td.arrival_city) = (
        SELECT departure_city,
            arrival_city
        FROM bookings.flights_v
        WHERE flight_id = (
                SELECT flight_id
                FROM sell_ticket
            )
    );
-- добавление записи вариант 2
WITH sell_ticket AS (
    INSERT INTO ticket_flights_tmp (ticket_no, flight_id, fare_conditions, amount)
    VALUES ('1234567890123', 7757, 'Economy', 3400)
    RETURNING *
)
UPDATE tickets_directions AS td
SET last_ticket_time = current_timestamp,
    tickets_num = tickets_num + 1
FROM bookings.flights_v AS f
WHERE td.departure_city = f.departure_city
    AND td.arrival_city = f.arrival_city
    AND f.flight_id = (
        SELECT flight_id
        FROM sell_ticket
    );
SELECT *
FROM tickets_directions
WHERE tickets_num > 0;