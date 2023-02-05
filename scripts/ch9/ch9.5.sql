-- @conn pgbook
CREATE TABLE modes (
    num integer,
    mode text
);
INSERT INTO modes VALUES (1, 'LOW'), (2, 'HIGH');
SELECT * FROM modes;
-- первый
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE modes
SET mode = 'HIGH'
WHERE mode = 'LOW'
RETURNING *;
-- второй
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE modes
SET mode = 'LOW'
WHERE mode = 'HIGH'
RETURNING *;
-- первый
SELECT * FROM modes;
-- второй
SELECT * FROM modes;
-- первый
COMMIT;
-- второй
COMMIT;
