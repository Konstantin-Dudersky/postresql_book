-- @conn pgbook
ALTER TABLE bookings.aircrafts
ADD COLUMN speed integer NOT NULL CHECK (speed >= 300);
ALTER TABLE bookings.aircrafts
ADD COLUMN speed integer;
UPDATE bookings.aircrafts
SET speed = 500;
SELECT *
FROM bookings.aircrafts;
ALTER TABLE bookings.aircrafts
ALTER COLUMN speed
SET NOT NULL;
ALTER TABLE bookings.aircrafts
ADD CHECK (speed >= 300);
-- delete constrains
ALTER TABLE bookings.aircrafts
ALTER COLUMN speed DROP NOT NULL;
ALTER TABLE bookings.aircrafts DROP CONSTRAINT aircrafts_speed_check;
ALTER TABLE bookings.aircrafts DROP COLUMN speed;
-- изменение типа данных
SELECT *
FROM bookings.airports;
ALTER TABLE bookings.airports
ALTER COLUMN longitude
SET DATA TYPE numeric(5, 2),
    ALTER COLUMN latitude
SET DATA TYPE numeric(5, 2);
SELECT *
FROM bookings.airports;
-- добавление таблицы для классов обслуживания
CREATE TABLE bookings.fare_conditions (
    fare_conditions_code integer PRIMARY KEY,
    fare_condition_name varchar(10) NOT NULL
);
INSERT INTO bookings.fare_conditions
VALUES (1, 'Economy'),
    (2, 'Business'),
    (3, 'Comfort');
SELECT *
FROM bookings.fare_conditions;
ALTER TABLE bookings.seats
ALTER COLUMN fare_conditions
SET DATA TYPE integer USING (
        CASE
            WHEN fare_conditions = 'Economy' THEN 1
            WHEN fare_conditions = 'Business' THEN 2
            ELSE 3
        END
    );
ALTER TABLE bookings.seats DROP CONSTRAINT seats_fare_conditions_check,
    ALTER COLUMN fare_conditions
SET DATA TYPE integer USING (
        CASE
            WHEN fare_conditions = 'Economy' THEN 1
            WHEN fare_conditions = 'Business' THEN 2
            ELSE 3
        END
    );
SELECT *
FROM bookings.seats
LIMIT 5;
ALTER TABLE bookings.seats
ADD FOREIGN KEY (fare_conditions) REFERENCES bookings.fare_conditions (fare_conditions_code);
ALTER TABLE bookings.seats
    RENAME COLUMN fare_conditions TO fare_conditions_code;
ALTER TABLE bookings.seats
    RENAME CONSTRAINT seats_fare_conditions_fkey TO seats_fare_conditions_code_fkey;
ALTER TABLE bookings.fare_conditions
ADD UNIQUE (fare_condition_name);