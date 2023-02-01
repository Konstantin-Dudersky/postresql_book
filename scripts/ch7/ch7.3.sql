-- @conn pgbook
WITH delete_row AS (
    DELETE FROM aircrafts_tmp
    WHERE model ~ '^Bom'
    RETURNING *
)
INSERT INTO aircrafts_log
SELECT dr.aircraft_code,
    dr.model,
    dr.range,
    current_timestamp,
    'DELETE'
FROM delete_row AS dr;
SELECT *
FROM aircrafts_log
WHERE model ~ '^Bom'
ORDER BY when_add;
WITH min_ranges AS (
    SELECT aircraft_code,
        rank() OVER (
            PARTITION BY left(model, 6)
            ORDER BY range
        ) AS rank
    FROM aircrafts_tmp
    WHERE model ~ '^Airbus'
        OR model ~ '^Boeing'
)
DELETE FROM aircrafts_tmp AS a USING min_ranges AS mr
WHERE a.aircraft_code = mr.aircraft_code
    AND mr.rank = 1
RETURNING *;