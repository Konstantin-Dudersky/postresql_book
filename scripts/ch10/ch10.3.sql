-- @conn pgbook
EXPLAIN SELECT a.aircraft_code,
    a.model,
    s.seat_no,
    s.fare_conditions
FROM bookings.seats AS s
JOIN bookings.aircrafts AS a USING(aircraft_code)
WHERE a.model ~ '^Air'
ORDER BY s.seat_no;
EXPLAIN SELECT r.flight_no,
r.departure_airport_name,
r.arrival_airport_name,
a.model
FROM bookings.routes AS r
    JOIN bookings.aircrafts AS a USING(aircraft_code)
ORDER BY flight_no;
EXPLAIN SELECT t.ticket_no,
t.passenger_name,
tf.flight_id,
tf.amount
FROM bookings.tickets AS t
JOIN bookings.ticket_flights AS tf USING(ticket_no)
ORDER BY t.ticket_no;