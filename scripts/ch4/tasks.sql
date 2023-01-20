-- @conn pgbook
-- # 1
CREATE TABLE test_numeric (measurement numeric(5, 2), description text);
SELECT *
FROM test_numeric;
INSERT INTO test_numeric
VALUES (999.9999, 'Какое-то измерение');
INSERT INTO test_numeric
VALUES (999.9009, 'Еще одно измерение');
INSERT INTO test_numeric
VALUES (999.1111, 'И еще одно измерение');
INSERT INTO test_numeric
VALUES (998.9999, 'И еще одно');
INSERT INTO test_numeric
VALUES (1000, '');
-- # 2
DROP TABLE test_numeric;
CREATE TABLE test_numeric (measurement numeric, description text);
INSERT INTO test_numeric
VALUES (1234567890.09876543210, ''),
    (1.5, ''),
    (0.1234567901234567890, ''),
    (1234567890, '');
SELECT *
FROM test_numeric;
-- # 3
SELECT 'NaN'::numeric > 10000;
SELECT 'NaN'::numeric = 'NaN'::numeric;
-- # 4
SELECT '5e-324'::double precision > '4e-324'::double precision;
SELECT '5e307'::double precision > '4e307'::double precision;
-- # 5
SELECT 'Inf'::double precision > '1e+308'::double precision;
SELECT '-Inf'::double precision < '-1e+308'::double precision;
-- # 6
SELECT 0.0 * 'Inf'::real;
SELECT 'NaN'::real = 'NaN'::real;
SELECT 'NaN'::real > '1e308'::double precision;
SELECT 'NaN'::real > 'Inf'::double precision;
-- # 7
CREATE TABLE test_serial (id serial, name text);
INSERT INTO test_serial (name)
VALUES ('Вишневая');
INSERT INTO test_serial (name)
VALUES ('Грушевая');
INSERT INTO test_serial (name)
VALUES ('Зеленая');
SELECT *
FROM test_serial;
INSERT INTO test_serial (id, name)
VALUES (10, 'Прохладная');
SELECT *
FROM test_serial;
INSERT INTO test_serial (name)
VALUES ('Луговая');
SELECT *
FROM test_serial;
-- # 8
DROP TABLE test_serial;
CREATE TABLE test_serial (id serial PRIMARY KEY, name text);
INSERT INTO test_serial (name)
VALUES ('Вишневая');
SELECT *
FROM test_serial;
INSERT INTO test_serial (id, name)
VALUES (2, 'Прохладная');
SELECT *
FROM test_serial;
INSERT INTO test_serial (name)
VALUES ('Грушевая');
INSERT INTO test_serial (name)
VALUES ('Грушевая');
SELECT *
FROM test_serial;
INSERT INTO test_serial (name)
VALUES ('Зеленая');
SELECT *
FROM test_serial;
DELETE FROM test_serial
WHERE id = 4;
SELECT *
FROM test_serial;
INSERT INTO test_serial (name)
VALUES ('Луговая');
SELECT *
FROM test_serial;
-- # 9
-- # 10
-- # 11
SELECT current_time;
SELECT CURRENT_TIME::time(0);
SELECT CURRENT_TIME::time(3);
SELECT current_date;
-- # 12
SHOW datestyle;
SELECT '05-18-2016'::date;
SELECT '18-05-2016'::date;
SELECT '2016-05-18'::date;
SET datestyle TO 'DMY';
SELECT '05-18-2016'::date;
SELECT '18-05-2016'::date;
SET datestyle TO DEFAULT;
SELECT '05-18-2016'::date;
SELECT '18-05-2016'::date;
SELECT '05-18-2016'::timestamp;
SELECT '18-05-2016'::timestamp;
SET datestyle TO 'Postgres, DMY';
SHOW datestyle;
SELECT CURRENT_TIMESTAMP;
-- # 13
-- # 14
-- # 15
SELECT to_char(current_timestamp, 'mi:ss');
SELECT to_char(current_timestamp, 'dd');
SELECT to_char(current_timestamp, 'yyyy-mm-dd');
-- # 16
SELECT 'Feb 29, 2015'::date;
-- # 17
SELECT '21:15:16:22'::time;
-- # 18
SELECT ('2016-09-16'::date - '2016-09-01'::date);
-- # 19
SELECT ('20:34:35'::time - '19:44:45'::time);
SELECT ('20:34:35'::time + '19:44:45'::time);
-- # 20
SELECT (current_timestamp - '2016-01-01'::timestamp) AS new_date;
SELECT (current_timestamp + '1 mon'::interval) AS new_date;
-- # 21
SELECT ('2016-01-31'::date + '1 mon'::interval) AS new_date;
SELECT ('2016-02-29'::date + '1 mon'::interval) AS new_date;
-- # 22
SHOW intervalstyle;
SELECT '1  mon'::interval;
SET intervalstyle TO 'iso_8601';
SELECT '1 year 1 mon'::interval;
SET intervalstyle TO DEFAULT;
-- # 23
SELECT ('2016-09-16'::date - '2015-09-01'::date);
SELECT (
        '2016-09-16'::timestamp - '2015-09-01'::timestamp
    );
-- # 24
SELECT ('20:34:35'::time - 1);
SELECT ('2016-09-16'::date - 1);
SELECT ('20:34:35'::time - '1 sec'::interval);
-- # 25
SELECT (
        date_trunc('sec', timestamp '1999-11-27 12:34:56.987654')
    );
SELECT (
        date_trunc(
            'microsecond',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'millisecond',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'second',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'minute',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'hour',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'day',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'week',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'month',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'year',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'decade',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'century',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
SELECT (
        date_trunc(
            'millennium',
            timestamp '1999-11-27 12:34:56.987654'
        )
    );
-- # 26
-- # 27
SELECT extract(
        'microsecond'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'millisecond'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'second'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'minute'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'hour'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'day'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'week'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'month'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'year'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'decade'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'century'
        from timestamp '1999-11-27 12:34:56.123459'
    );
SELECT extract(
        'millennium'
        from timestamp '1999-11-27 12:34:56.123459'
    );
-- # 28
-- # 29
DROP TABLE databases;
CREATE TABLE databases (is_open_source BOOLEAN, dbms_name text);
INSERT INTO databases
VALUES (TRUE, 'PostgreSQL'),
    (FALSE, 'Oracle'),
    (TRUE, 'PostgreSQL'),
    (FALSE, 'MS SQL Server');
SELECT *
FROM databases
WHERE NOT is_open_source;
SELECT *
FROM databases
WHERE is_open_source <> 'yes';
SELECT *
FROM databases
WHERE is_open_source <> 't';
SELECT *
FROM databases
WHERE is_open_source <> '1';
SELECT *
FROM databases
WHERE is_open_source <> 1;
-- # 30
DROP TABLE test_bool;
CREATE TABLE test_bool (a boolean, b text);
INSERT INTO test_bool
VALUES (TRUE, 'yes');
INSERT INTO test_bool
VALUES (yes, 'yes');
INSERT INTO test_bool
VALUES ('yes', true);
INSERT INTO test_bool
VALUES ('yes', TRUE);
INSERT INTO test_bool
VALUES ('1', 'true');
INSERT INTO test_bool
VALUES (1, 'true');
INSERT INTO test_bool
VALUES ('t', 'true');
INSERT INTO test_bool
VALUES ('t', truth);
INSERT INTO test_bool
VALUES (true, 'true');
INSERT INTO test_bool
VALUES (1::boolean, 'true');
INSERT INTO test_bool
VALUES (111::boolean, 'true');
-- # 31
DROP TABLE birthdays;
CREATE TABLE birthdays (person text NOT NULL, birthday date NOT NULL);
INSERT INTO birthdays
VALUES ('Ken Thompson', '1955-03-23'),
    ('Ben Johnson', '1971-03-19'),
    ('Andy Gibson', '1987-08-12');
SELECT *
FROM birthdays
WHERE extract(
        'month'
        FROM birthday
    ) = 3;
SELECT *,
    birthday + '40 years'::interval
FROM birthdays
WHERE birthday + '40 years'::interval < current_timestamp;
SELECT *,
    birthday + '40 years'::interval
FROM birthdays
WHERE birthday + '40 years'::interval < current_date;
SELECT *,
    (current_timestamp - birthday::timestamp)::interval
FROM birthdays;
SELECT *,
    age(current_timestamp, birthday)
FROM birthdays;
-- # 32
SELECT array_cat(ARRAY [1, 2, 3], ARRAY [3, 5]);
SELECT array_remove(ARRAY [1, 2, 3], 3);
-- # 33
DROP TABLE pilots;
CREATE TABLE pilots (
    pilot_name text,
    schedule integer [],
    meal text []
);
INSERT INTO pilots
VALUES (
        'Ivan',
        '{1, 3, 5, 6, 7}'::integer [],
        '{"сосиска", "макароны", "кофе"}'::text []
    ),
    (
        'Petr',
        '{1, 2, 5, 7}'::integer [],
        '{"котлета", "каша", "кофе"}'::text []
    ),
    (
        'Pavel',
        '{2, 5}'::integer [],
        '{"сосиска", "каша", "кофе"}'::text []
    ),
    (
        'Boris',
        '{3, 5, 6}'::integer [],
        '{"котлета", "каша", "чай"}'::text []
    );
SELECT *
FROM pilots;
SELECT *
FROM pilots
WHERE meal [1] = 'сосиска';
CREATE TABLE pilots (
    pilot_name text,
    schedule integer [],
    meal text [] []
);
INSERT INTO pilots
VALUES (
        'Ivan',
        '{1, 3, 5, 6, 7}'::integer [],
        '{{"сосиска", "макароны", "кофе"}, 
        {"сосиска", "каша", "кофе"}}'::text []
    );
SELECT *
FROM pilots
WHERE meal [1] [1] = 'сосиска';
-- # 34
SELECT *
FROM pilot_hobbies;
UPDATE pilot_hobbies
SET hobbies = jsonb_set(hobbies, '{home_lib}', 'true')
WHERE pilot_name = 'Ivan';
-- # 35
SELECT '{"sports": "хоккей"}'::jsonb || '{"trips": 5}'::jsonb;
-- # 36
UPDATE pilot_hobbies
SET hobbies = hobbies || '{ "new_key": "new_value" }'::jsonb
WHERE pilot_name = 'Ivan';
-- # 37
UPDATE pilot_hobbies
SET hobbies = hobbies - 'new_key'
WHERE pilot_name = 'Ivan';