-- @conn pgbook
CREATE TABLE databases (is_open_source BOOLEAN, dbms_name text);
INSERT INTO databases
VALUES (TRUE, 'PostgreSQL'),
    (FALSE, 'Oracle'),
    (TRUE, 'PostgreSQL'),
    (FALSE, 'MS SQL Server');
SELECT *
FROM databases;
SELECT *
from databases
WHERE is_open_source;