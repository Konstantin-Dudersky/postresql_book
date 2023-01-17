-- @conn pgbook
-- создать таблицу
CREATE TABLE aircrafts (
    aircraft_code CHAR(3) not null,
    model text not null,
    range integer not null,
    check (range > 0),
    primary key (aircraft_code)
);
-- удалить таблицу
DROP TABLE aircrafts;
-- вставить строку
INSERT INTO aircrafts (aircraft_code, model, range)
VALUES ('SU9', 'Sukhoi SuperJet-100', 3000);
-- выбрать всю информацию
SELECT *
FROM aircrafts;
-- вставить несколько строк
INSERT INTO aircrafts (aircraft_code, model, range)
VALUES ('773', 'Boeing 777-300', 11100),
    ('763', 'Boeing 767-300', 7900),
    ('733', 'Boeing 737-300', 4200),
    ('320', 'Airbus A320-200', 5700),
    ('321', 'Airbus A321-200', 5600),
    ('319', 'Airbus A319-100', 6700),
    ('CN1', 'Cessna 208 Caravan', 1200),
    ('CR2', 'Bombardier CRJ-200', 2700);
-- выбрать всю информацию
SELECT *
FROM aircrafts;
SELECT model,
    aircraft_code,
    range
FROM aircrafts
ORDER BY model;
SELECT model,
    aircraft_code,
    range
FROM aircrafts
WHERE range >= 4000
    AND range <= 6000;
-- обновление
UPDATE aircrafts
SET range = 3500
WHERE aircraft_code = 'SU9';
-- удаление
DELETE FROM aircrafts
WHERE aircraft_code = 'CN1';
DELETE FROM aircrafts
WHERE range > 10000
    or range < 3000;
-- удалить все
DELETE FROM aircrafts;
-- создание таблицы "Места"
CREATE TABLE seats (
    aircraft_code char(3) NOT NULL,
    seat_no varchar(4) NOT NULL,
    fare_conditions varchar(10) NOT NULL,
    CHECK (
        fare_conditions IN ('Economy', 'Comfort', 'Business')
    ),
    PRIMARY KEY (aircraft_code, seat_no),
    FOREIGN KEY (aircraft_code) REFERENCES aircrafts (aircraft_code) ON DELETE CASCADE
);
-- добавление несуществующего внешнего ключа
INSERT INTO seats
VALUES ('123', '1A', 'Business');
-- добавление нескольких записей
INSERT INTO seats
VALUES ('SU9', '1A', 'Business'),
    ('SU9', '1B', 'Business'),
    ('SU9', '10A', 'Economy'),
    ('SU9', '10B', 'Economy'),
    ('SU9', '10F', 'Economy'),
    ('SU9', '20F', 'Economy');
INSERT INTO seats
VALUES ('773', '1A', 'Business'),
    ('773', '1B', 'Business'),
    ('773', '10A', 'Economy'),
    ('773', '10B', 'Economy'),
    ('773', '10F', 'Economy'),
    ('773', '20F', 'Economy');
-- число мест по самолету
SELECT aircraft_code,
    fare_conditions,
    count(*)
FROM seats
GROUP BY aircraft_code,
    fare_conditions
ORDER BY count;
-- task 1
INSert INTO aircrafts
VALUES ('SU9', 'Sukhoi SuperJet-100', 3000);
-- task 2
SELECT *
FROM aircrafts
ORDER BY range DESC;
-- task 3
UPDATE aircrafts
SET range = range * 2
WHERE aircraft_code = 'SU9';
-- task 4
DELETE FROM aircrafts
WHERE range > 20000;