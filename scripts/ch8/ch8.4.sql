-- @conn pgbook
DROP INDEX bookings.aircrafts_unique_model_key;
CREATE UNIQUE INDEX aircrafts_unique_model_key
ON bookings.aircrafts (lower(model));