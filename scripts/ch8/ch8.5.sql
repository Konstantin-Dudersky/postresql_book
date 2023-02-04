-- @conn pgbook
SELECT *
FROM bookings.bookings 
WHERE total_amount > 1000000
ORDER BY book_date DESC;
CREATE INDEX bookings_book_date_part_key
ON bookings.bookings (book_date)
WHERE total_amount > 1000000;
SELECT *
FROM bookings.bookings 
WHERE total_amount > 1000000
ORDER BY book_date DESC;