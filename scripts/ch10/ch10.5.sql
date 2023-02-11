-- @conn pgbook
ANALYZE bookings.aircrafts;
EXPLAIN SELECT num_tickets, count(*) AS num_bookings
FROM (
    SELECT b.book_ref, (
        SELECT count(*) FROM bookings.tickets AS t
        WHERE t.book_ref = b.book_ref
        )
        FROM bookings.bookings AS b
        WHERE date_trunc('mon', book_date) = '2016-09-01'
) AS count_tickets(book_ref, num_tickets)
GROUP BY num_tickets
ORDER BY num_tickets DESC;
CREATE INDEX tickets_book_ref_key
ON bookings.tickets (book_ref);
EXPLAIN ANALYZE SELECT num_tickets, count(*) AS num_bookings
FROM (
    SELECT b.book_ref, (
        SELECT count(*) FROM bookings.tickets AS t
        WHERE t.book_ref = b.book_ref
        )
        FROM bookings.bookings AS b
        WHERE date_trunc('mon', book_date) = '2016-09-01'
) AS count_tickets(book_ref, num_tickets)
GROUP BY num_tickets
ORDER BY num_tickets DESC;
EXPLAIN ANALYZE SELECT num_tickets, count(*) AS num_bookings
FROM (
    SELECT b.book_ref, count(*)
    FROM bookings.bookings AS b, bookings.tickets AS t
    WHERE date_trunc('mon', b.book_date) = '2016-09-01'
        AND t.book_ref = b.book_ref
    GROUP BY b.book_ref
) AS count_tickets(book_ref, num_tickets)
GROUP BY num_tickets
ORDER BY num_tickets DESC;