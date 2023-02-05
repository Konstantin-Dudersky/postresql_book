-- @conn pgbook
SET enable_mergejoin = off;
EXPLAIN SELECT t.ticket_no,
t.passenger_name,
tf.flight_id,
tf.amount
FROM bookings.tickets AS t
JOIN bookings.ticket_flights AS tf USING(ticket_no)
ORDER BY t.ticket_no;
SET enable_mergejoin = on;
EXPLAIN ANALYZE SELECT t.ticket_no,
t.passenger_name,
tf.flight_id,
tf.amount
FROM bookings.tickets AS t
JOIN bookings.ticket_flights AS tf USING(ticket_no)
ORDER BY t.ticket_no;
EXPLAIN ANALYZE SELECT t.ticket_no,
t.passenger_name,
tf.flight_id,
tf.amount
FROM bookings.tickets AS t
JOIN bookings.ticket_flights AS tf ON t.ticket_no = tf.ticket_no
WHERE amount > 50000
ORDER BY t.ticket_no;
-- update
BEGIN;
EXPLAIN (ANALYZE, COSTS OFF)
UPDATE bookings.aircrafts
SET range = range + 100
WHERE model ~ '^Air';
ROLLBACK;