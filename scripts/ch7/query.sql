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