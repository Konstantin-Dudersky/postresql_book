-- @conn pgbook
-- # 1
DROP TABLE IF EXISTS public.aircrafts_log;
CREATE TABLE aircrafts_log AS
SELECT *
FROM bookings.aircrafts WITH NO DATA;
ALTER TABLE public.aircrafts_log
ADD COLUMN when_add timestamp DEFAULT current_timestamp;
ALTER TABLE public.aircrafts_log
ADD COLUMN operation text;
WITH add_row AS (
    INSERT INTO aircrafts_tmp
    VALUES ('SU8', 'Sukhoi SuperJet-101', 3000) ON CONFLICT DO NOTHING
    RETURNING *
)
INSERT INTO aircrafts_log (aircraft_code, model, range, operation)
SELECT add_row.aircraft_code,
    add_row.model,
    add_row.range,
    'INSERT'
FROM add_row;
SELECT *
FROM aircrafts_log;
-- # 2
DELETE FROM aircrafts_tmp;
WITH add_row AS (
    INSERT INTO aircrafts_tmp
    SELECT *
    FROM bookings.aircrafts
    RETURNING aircraft_code,
        model,
        range,
        current_timestamp,
        'INSERT'
)
INSERT INTO aircrafts_log
SELECT *
FROM add_row;
-- # 3
DELETE FROM aircrafts_tmp;
INSERT INTO aircrafts_tmp
SELECT *
FROM bookings.aircrafts
RETURNING *;
-- # 4
DROP TABLE IF EXISTS seats_tmp;
CREATE TABLE seats_tmp (
    LIKE bookings.seats INCLUDING CONSTRAINTS INCLUDING INDEXES
);
-- 1 вариант
INSERT INTO seats_tmp
VALUES ('SU1', '1A', 'Economy') ON CONFLICT (aircraft_code, seat_no) DO
UPDATE
SET fare_conditions = excluded.fare_conditions;
INSERT INTO seats_tmp
VALUES ('SU1', '1A', 'Business') ON CONFLICT (aircraft_code, seat_no) DO
UPDATE
SET fare_conditions = excluded.fare_conditions;
SELECT *
FROM seats_tmp;
-- 2 вариант
INSERT INTO seats_tmp
VALUES ('SU1', '1A', 'Economy') ON CONFLICT ON CONSTRAINT seats_tmp_pkey DO
UPDATE
SET fare_conditions = excluded.fare_conditions;
SELECT *
FROM seats_tmp;
-- # 5
DELETE FROM aircrafts_tmp;
INSERT INTO aircrafts_tmp AS a
SELECT *
FROM bookings.aircrafts ON CONFLICT (aircraft_code) DO
UPDATE
SET range = 123
WHERE a.model ~ '^Boe';
SELECT *
FROM aircrafts_tmp;
-- # 6
-- # 7
DELETE FROM aircrafts_tmp;
INSERT INTO aircrafts_tmp
SELECT *
FROM bookings.aircrafts;
\ copy aircrafts_tmp
FROM '/home/konstantin/projects/postresql_book/scripts/ch7/aircrafts_tmp.csv' WITH (FORMAT csv);
SELECT *
FROM aircrafts_tmp;
-- # 8
SELECT flight_no,
    flight_id,
    departure_city,
    arrival_city,
    scheduled_departure
FROM bookings.flights_v
WHERE scheduled_departure BETWEEN bookings.now() AND bookings.now() + INTERVAL '15 days'
    AND (departure_city, arrival_city) IN (
        ('Красноярск', 'Москва'),
        ('Москва', 'Сочи'),
        ('Сочи', 'Москва'),
        ('Сочи', 'Красноярск')
    )
ORDER BY departure_city,
    arrival_city,
    scheduled_departure;
DELETE FROM ticket_flights_tmp;
-- оригинальный запрос
WITH sell_tickets AS (
    INSERT INTO ticket_flights_tmp (ticket_no, flight_id, fare_conditions, amount)
    VALUES ('1234567890123', 13829, 'Economy', 10500),
        ('1234567890123', 4728, 'Economy', 3400),
        ('1234567890123', 30523, 'Economy', 3400),
        ('1234567890123', 7757, 'Economy', 3400),
        ('1234567890123', 30829, 'Economy', 12800)
    RETURNING *
)
UPDATE tickets_directions AS td
SET last_ticket_time = current_timestamp,
    tickets_num = tickets_num + (
        SELECT count(*)
        FROM sell_tickets AS st,
            bookings.flights_v AS f
        WHERE st.flight_id = f.flight_id
            AND f.departure_city = td.departure_city
            AND f.arrival_city = td.arrival_city
    )
WHERE (td.departure_city, td.arrival_city) IN (
        SELECT departure_city,
            arrival_city
        FROM bookings.flights_v
        WHERE flight_id IN (
                SELECT flight_id
                FROM sell_tickets
            )
    );
SELECT departure_city AS dep_city,
    arrival_city AS arr_city,
    last_ticket_time,
    tickets_num AS num
FROM tickets_directions
WHERE tickets_num > 0
ORDER BY departure_city,
    arrival_city;
SELECT *
FROM ticket_flights_tmp;
-- решение
DROP TABLE IF EXISTS tickets_directions;
CREATE TABLE tickets_directions (
    departure_city text,
    arrival_city text,
    last_ticket_time timestamp,
    tickets_num integer DEFAULT 0,
    fare_conditions character varying(10)
);
WITH cities AS (
    SELECT DISTINCT departure_city,
        arrival_city
    FROM bookings.routes
)
INSERT INTO tickets_directions (departure_city, arrival_city, fare_conditions)
SELECT c.departure_city,
    c.arrival_city,
    unnest(ARRAY ['Economy', 'Business', 'Comfort'])
FROM cities AS c;
DELETE FROM ticket_flights_tmp;
WITH sell_tickets AS (
    INSERT INTO ticket_flights_tmp (ticket_no, flight_id, fare_conditions, amount)
    VALUES ('1234567890123', 13829, 'Economy', 10500),
        ('1234567890123', 4728, 'Economy', 3400),
        ('1234567890123', 30523, 'Economy', 3400),
        ('1234567890123', 7757, 'Business', 3400),
        ('1234567890123', 30829, 'Economy', 12800)
    RETURNING *
)
UPDATE tickets_directions AS td
SET last_ticket_time = current_timestamp,
    tickets_num = tickets_num + (
        SELECT count(*)
        FROM sell_tickets AS st,
            bookings.flights_v AS f
        WHERE st.flight_id = f.flight_id
            AND f.departure_city = td.departure_city
            AND f.arrival_city = td.arrival_city
            AND st.fare_conditions = td.fare_conditions
    )
WHERE (td.departure_city, td.arrival_city) IN (
        SELECT departure_city,
            arrival_city
        FROM bookings.flights_v
        WHERE flight_id IN (
                SELECT flight_id
                FROM sell_tickets
            )
    );
SELECT departure_city AS dep_city,
    arrival_city AS arr_city,
    last_ticket_time,
    tickets_num AS num,
    fare_conditions
FROM tickets_directions
WHERE tickets_num > 0
ORDER BY departure_city,
    arrival_city;
-- # 9
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
-- решение
WITH aircraft_seats AS (
    SELECT DISTINCT ON (company) a.aircraft_code,
        left(model, strpos(model, ' ') - 1) as company,
        count(*) AS seats_num
    FROM aircrafts_tmp AS a,
        bookings.seats AS s
    WHERE a.aircraft_code = s.aircraft_code
    GROUP BY 1,
        2
    ORDER BY company,
        seats_num
)
DELETE FROM aircrafts_tmp AS a USING aircraft_seats AS a_s
WHERE a.aircraft_code = a_s.aircraft_code
    AND left(a.model, strpos(a.model, ' ') - 1) IN ('Boeing', 'Airbus')
RETURNING *;
-- # 10
-- подготовка
DROP TABLE IF EXISTS seats_tmp;
CREATE TABLE seats_tmp AS
SELECT *
FROM bookings.seats;
DELETE FROM seats_tmp;
-- запрос из книги
INSERT INTO seats_tmp (aircraft_code, seat_no, fare_conditions)
SELECT aircraft_code,
    seat_row || letter,
    fare_condition
FROM -- компоновки салонов
    (
        VALUES ('SU9', 3, 20, 'F'),
            ('773', 5, 30, 'I'),
            ('763', 4, 25, 'H'),
            ('733', 3, 20, 'F'),
            ('320', 5, 25, 'F'),
            ('321', 4, 20, 'F'),
            ('319', 3, 20, 'F'),
            ('CN1', 0, 10, 'B'),
            ('CR2', 2, 15, 'D')
    ) AS aircraft_info (
        aircraft_code,
        max_seat_row_business,
        max_seat_row_economy,
        max_letter
    )
    CROSS JOIN -- классы обслуживания
    (
        VALUES ('Business'),
            ('Economy')
    ) AS fare_conditions (fare_condition)
    CROSS JOIN -- список номеров рядов кресел
    (
        VALUES ('1'),
            ('2'),
            ('3'),
            ('4'),
            ('5'),
            ('6'),
            ('7'),
            ('8'),
            ('9'),
            ('10'),
            ('11'),
            ('12'),
            ('13'),
            ('14'),
            ('15'),
            ('16'),
            ('17'),
            ('18'),
            ('19'),
            ('20'),
            ('21'),
            ('22'),
            ('23'),
            ('24'),
            ('25'),
            ('26'),
            ('27'),
            ('28'),
            ('29'),
            ('30')
    ) AS seat_rows (seat_row)
    CROSS JOIN -- список номеров (позиций) кресел в ряду
    (
        VALUES ('A'),
            ('B'),
            ('C'),
            ('D'),
            ('E'),
            ('F'),
            ('G'),
            ('H'),
            ('I')
    ) AS letters (letter)
WHERE CASE
        WHEN fare_condition = 'Business' THEN seat_row::integer <= max_seat_row_business
        WHEN fare_condition = 'Economy' THEN seat_row::integer > max_seat_row_business
        AND seat_row::integer <= max_seat_row_economy
    END
    AND letter <= max_letter;
-- переделанный запрос
DELETE FROM seats_tmp;
INSERT INTO seats_tmp (aircraft_code, seat_no, fare_conditions)
SELECT aircraft_code,
    seat_row || letter,
    fare_condition
FROM -- компоновки салонов
    (
        VALUES ('SU9', 3, 20, 'D', 'F'),
            ('773', 5, 30, 'F', 'I') -- ,
            -- ('763', 4, 25, 'H'),
            -- ('733', 3, 20, 'F'),
            -- ('320', 5, 25, 'F'),
            -- ('321', 4, 20, 'F'),
            -- ('319', 3, 20, 'F'),
            -- ('CN1', 0, 10, 'B'),
            -- ('CR2', 2, 15, 'D')
    ) AS aircraft_info (
        aircraft_code,
        max_seat_row_business,
        max_seat_row_economy,
        max_letter_business,
        max_letter_ecomomy
    )
    CROSS JOIN -- классы обслуживания
    (
        VALUES ('Business'),
            ('Economy')
    ) AS fare_conditions (fare_condition)
    CROSS JOIN -- список номеров рядов кресел
    (
        SELECT generate_series(1, 30)
    ) AS seat_rows (seat_row)
    CROSS JOIN -- список номеров (позиций) кресел в ряду
    (
        VALUES ('A'),
            ('B'),
            ('C'),
            ('D'),
            ('E'),
            ('F'),
            ('G'),
            ('H'),
            ('I')
    ) AS letters (letter)
WHERE CASE
        WHEN fare_condition = 'Business' THEN seat_row::integer <= max_seat_row_business
        AND letter <= max_letter_business
        WHEN fare_condition = 'Economy' THEN seat_row::integer > max_seat_row_business
        AND seat_row::integer <= max_seat_row_economy
        AND letter <= max_letter_ecomomy
    END;
-- проверка
SELECT *
FROM seats_tmp
ORDER BY aircraft_code,
    seat_no;