-- @conn pgbook
CREATE INDEX tickets_book_ref_test_key
ON bookings.tickets (book_ref);
SELECT * FROM bookings.tickets
ORDER BY book_ref
LIMIT 5;
DROP INDEX bookings.tickets_book_ref_test_key;
SELECT * FROM bookings.tickets
ORDER BY book_ref
LIMIT 5;