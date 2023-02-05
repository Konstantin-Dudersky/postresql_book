-- @conn pgbook
EXPLAIN SELECT * FROM bookings.aircrafts;
EXPLAIN (COSTS OFF) SELECT * FROM bookings.aircrafts;
EXPLAIN SELECT * FROM bookings.aircrafts WHERE model ~ 'Air';
EXPLAIN SELECT * FROM bookings.aircrafts ORDER BY aircraft_code;
EXPLAIN SELECT * FROM bookings.bookings ORDER BY book_ref;
EXPLAIN SELECT *
FROM bookings.bookings
WHERE book_ref > '0000FF' AND book_ref < '000FFF'
ORDER BY book_ref;
EXPLAIN SELECT *
FROM bookings.seats
WHERE aircraft_code = 'SU9';
EXPLAIN SELECT book_ref
FROM bookings.bookings
WHERE book_ref < '000FFF'
ORDER BY book_ref;
EXPLAIN SELECT count(*)
FROM bookings.seats
WHERE aircraft_code = 'SU9';
EXPLAIN SELECT avg(total_amount)
FROM bookings.bookings;