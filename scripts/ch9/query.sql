-- @conn pgbook
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT *
FROM bookings.ticket_flights
WHERE flight_id = 13881;