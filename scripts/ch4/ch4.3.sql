-- @conn pgbook
SELECT '2016-09-12'::date;
SELECT 'Sep 12, 2016'::date;
SELECT current_date;
SELECT to_char(current_date, 'dd-mm-yyyy');
SELECT '21:15'::time;
SELECT '25:15'::time;
SELECT '21:15:26'::time;
SELECT '21:15:69'::time;
SELECT '10:15:16 am'::time;
SELECT '10:15:16 pm'::time;
SELECT current_time;
SELECT timestamp with time zone '2016-09-21 22:25:35';
SELECT timestamp '2016-09-21 22:25:35';
SELECT current_timestamp;
SELECT '1 year 2 months ago'::interval;
SELECT 'P0001-02-03T04:05:06'::interval;
SELECT (
        '2016-09-16'::timestamp - '2016-09-01'::timestamp
    )::interval;
SELECT date_trunc('hour', current_timestamp);
SELECT extract(
        'mon'
        FROM timestamp '1999-11-27 12:34:56.123459'
    );