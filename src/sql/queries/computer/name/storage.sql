SELECT
manufacturer, capacity, capacity_unit, interface, type
FROM
storage
WHERE
storage_id = ?
;