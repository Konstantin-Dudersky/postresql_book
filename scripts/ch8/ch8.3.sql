-- @conn pgbook
CREATE UNIQUE INDEX aircrafts_unique_model_key
ON bookings.aircrafts (model);