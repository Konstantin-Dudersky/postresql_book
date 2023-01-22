-- @conn pgbook
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    record_book numeric(5) NOT NULL,
    name text NOT NULL,
    doc_ser numeric(4),
    doc_num numeric(6),
    PRIMARY KEY (record_book)
);
DROP TABLE IF EXISTS progress;
CREATE TABLE progress (
    record_book numeric(5) NOT NUll,
    subject text NOT NULL,
    acad_year text NOT NULL,
    term numeric(1) NOT NULL CHECK (
        term = 1
        OR term = 2
    ),
    mark numeric(1) NOT NULL CHECK (
        mark >= 3
        AND mark <= 5
    ) DEFAULT 5,
    FOREIGN KEY (record_book) REFERENCES students (record_book) ON DELETE CASCADE ON UPDATE CASCADE
);
-- # 1
ALTER TABLE students
ADD COLUMN who_adds_row text DEFAULT current_user;
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (12300, 'Иванов Иван Иванович', 0402, 543281);
SELECT *
FROM students;
ALTER TABLE students
ADD COLUMN ts_added timestamptz DEFAULT current_timestamp;
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (12301, 'Иванов Иван Иванович', 0403, 543282);
SELECT *
FROM students;
-- # 2
ALTER TABLE progress
ADD COLUMN test_form text CHECK (
        test_form = 'экзамен'
        OR test_form = 'зачет'
    ),
    ADD CHECK (
        (
            test_form = 'экзамен'
            AND mark IN (3, 4, 5)
        )
        OR (
            test_form = 'зачет'
            AND mark IN (0, 1)
        )
    );
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (1, 'Иванов Иван Иванович', 1, 1);
INSERT INTO progress (
        record_book,
        subject,
        acad_year,
        term,
        mark,
        test_form
    )
VALUES (1, 'Предмет', 2000, 1, 3, 'экзамен');
SELECT *
FROM progress;
INSERT INTO progress (
        record_book,
        subject,
        acad_year,
        term,
        mark,
        test_form
    )
VALUES (1, 'Предмет', 2000, 1, 0, 'зачет');
ALTER TABLE progress DROP CONSTRAINT progress_mark_check;
INSERT INTO progress (
        record_book,
        subject,
        acad_year,
        term,
        mark,
        test_form
    )
VALUES (1, 'Предмет', 2000, 1, 0, 'зачет');
SELECT *
FROM progress;
-- # 3
ALTER TABLE progress
ALTER COLUMN term DROP NOT NULL;
INSERT INTO progress (
        record_book,
        subject,
        acad_year,
        mark,
        test_form
    )
VALUES (1, 'Предмет', 2000, 0, 'зачет');
SELECT *
FROM progress;
-- # 4
ALTER TABLE progress
ALTER COLUMN mark
SET DEFAULT 6;
INSERT INTO progress (record_book, subject, acad_year, term)
VALUES (12300, 'Физика', '2016/2017', 1);
ALTER TABLE progress
ALTER COLUMN mark
SET DEFAULT 5;
-- # 5
SELECT (NULL = NULL);
ALTER TABLE students
ADD UNIQUE (doc_ser, doc_num);
INSERT INTO students (record_book, name, doc_ser)
VALUES (2, 'Иванов Иван Иванович', 1);
INSERT INTO students (record_book, name, doc_ser)
VALUES (3, 'Иванов Иван Иванович', 1);
SELECT *
FROM students;
INSERT INTO students (record_book, name)
VALUES (4, 'Иванов Иван Иванович');
INSERT INTO students (record_book, name)
VALUES (5, 'Иванов Иван Иванович');
SELECT *
FROM students;
-- # 6
DROP TABLE IF EXISTS students CASCADE;
CREATE TABLE students (
    record_book numeric(5) NOT NULL UNIQUE,
    name text NOT NULL,
    doc_ser numeric(4),
    doc_num numeric(6),
    PRIMARY KEY (doc_ser, doc_num)
);
DROP TABLE IF EXISTS progress;
CREATE TABLE progress (
    doc_ser numeric(4),
    doc_num numeric(6),
    subject text NOT NULL,
    acad_year text NOT NULL,
    term numeric(1) NOT NULL CHECK (
        term = 1
        OR term = 2
    ),
    mark numeric(1) NOT NULL CHECK (
        mark >= 3
        AND mark <= 5
    ) DEFAULT 5,
    FOREIGN KEY (doc_ser, doc_num) REFERENCES students (doc_ser, doc_num) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (4, 'Иванов Иван Иванович', 1, 1);
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (2, 'Иванов Иван Иванович', 2, 2);
SELECT *
FROM students;
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark)
VALUES (1, 1, 'Физика', '2016/2017', 1, 5);
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark)
VALUES (2, 2, 'Физика', '2016/2017', 1, 4);
SELECT *
FROM progress;
-- # 7
UPDATE students
SET doc_num = 10
WHERE doc_ser = 1
    AND doc_num = 1;
-- # 8
DROP TABLE IF EXISTS subjects;
CREATE TABLE subjects(
    subject_id integer PRIMARY KEY,
    subject text UNIQUE
);
INSERT INTO subjects
VALUES (1, 'Физика');
SELECT *
FROM subjects;
ALTER TABLE progress
ALTER COLUMN subject
SET DATA TYPE integer USING (
        CASE
            WHEN subject = 'Физика' THEN 1
        END
    );
ALTER TABLE progress
ADD FOREIGN KEY (subject) REFERENCES subjects (subject_id);
-- # 9
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (12300, '', 0402, 543281);
DELETE FROM students
WHERE name = '';
ALTER TABLE students
ADD CHECK (name <> '');
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (12300, '', 0402, 543281);
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (12346, ' ', 0406, 543281);
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (12347, '  ', 0407, 543281);
SELECT *,
    length(name)
FROM students;
DELETE FROM students
WHERE name = ' '
    OR name = '  ';
ALTER TABLE students
ADD CHECK (
        trim(
            both ' '
            from name
        ) <> ''
    );
-- # 10
ALTER TABLE progress DROP CONSTRAINT progress_doc_ser_doc_num_fkey,
    ALTER COLUMN doc_ser
SET DATA TYPE text;
ALTER TABLE students
ALTER COLUMN doc_ser
SET DATA TYPE text;
ALTER TABLE progress
ADD FOREIGN KEY (doc_ser, doc_num) REFERENCES students (doc_ser, doc_num) ON DELETE CASCADE ON UPDATE CASCADE;
-- # 11
SET search_path = bookings;
ALTER TABLE flights DROP CONSTRAINT flights_check1;
ALTER TABLE bookings.flights
ADD CHECK (
        actual_arrival IS NULL
        OR (
            actual_departure IS NOT NULL
            AND actual_arrival > actual_departure
        )
    );
UPDATE bookings.flights
SET actual_arrival = NULL
WHERE flight_id = 1;
-- # 12
ALTER TABLE bookings.aircrafts
    RENAME TO aircrafts1;
ALTER TABLE bookings.aircrafts1
    RENAME TO aircrafts;
-- # 13
DROP table bookings.airports;
-- # 14
CREATE OR REPLACE VIEW bookings.task_14 AS
SELECT model
FROM bookings.aircrafts WITH CHECK OPTION;
SELECT *
FROM bookings.task_14;
UPDATE bookings.task_14
SET model = 'Peace of shit'
WHERE model = 'Boeing 777-300';
-- # 15
-- # 16
SELECT *
FROM bookings.routes
WHERE flight_no = 'PG0001';
UPDATE bookings.airports
SET airport_name = 'Усть-Илимск 2'
WHERE airport_name = 'Усть-Илимск';
SELECT *
FROM bookings.routes
WHERE flight_no = 'PG0001';
REFRESH MATERIALIZED VIEW bookings.routes;
SELECT *
FROM bookings.routes
WHERE flight_no = 'PG0001';
-- # 17
CREATE OR REPLACE VIEW bookings.airport_names AS
SELECT airport_name
FROM bookings.airports;
SELECT *
FROM bookings.airport_names;
CREATE OR REPLACE VIEW bookings.not_departured AS
SELECT *
FROM bookings.flights
WHERE actual_arrival IS NULL;
SELECT count(*)
FROM bookings.not_departured;
-- # 18
ALTER TABLE bookings.aircrafts
ADD COLUMN specifications jsonb;
SELECT *
FROM bookings.aircrafts;
UPDATE bookings.aircrafts
SET specifications = '{ "crew": 2, "engines": {"type": "IAE V2500", "num": 2}}'::jsonb
WHERE aircraft_code = '320';
SELECT *
FROM bookings.aircrafts;
SELECT model,
    specifications->'engines' AS engines
FROM bookings.aircrafts;
SELECT model,
    specifications#>'{engines, type}'
FROM bookings.aircrafts;
UPDATE bookings.tickets
SET contact_data = '{"phone": "1234567"}'
WHERE ticket_no = '0005432000987'