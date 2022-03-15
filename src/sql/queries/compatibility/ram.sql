SELECT r.ram_id
FROM ram r, (
    SELECT m.ram_slots AS AvailableSlots, m.ram_type AS RamType
    FROM computer c
        LEFT JOIN motherboard m ON c.motherboard_id = m.motherboard_id
    WHERE c.name = ?
) AS x
WHERE
    (x.AvailableSlots IS NULL OR x.AvailableSlots >= r.stick_count)
    AND
    (x.RamType IS NULL OR x.RamType = r.type)