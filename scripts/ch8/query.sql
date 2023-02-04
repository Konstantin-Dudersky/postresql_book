-- @conn pgbook
DROP INDEX bookings.tickets_passenger_name_idx;
CREATE INDEX ON bookings.tickets (passenger_name DESC NULLS FIRST);
CREATE INDEX ON bookings.tickets (contact_data ASC NULLS LAST);