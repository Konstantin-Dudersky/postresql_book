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
DELETE FROM aircrafts