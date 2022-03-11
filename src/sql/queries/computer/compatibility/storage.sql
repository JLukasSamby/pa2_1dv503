SELECT s.storage_id
FROM storage s, (
    SELECT m.motherboard_id AS MoboID, m.SATA_slots AS SataSlots, m.M2_slots AS M2Slots
    FROM computer c
        LEFT JOIN motherboard m ON c.motherboard_id = m.motherboard_id
    WHERE c.name = ?
) AS x
WHERE
    x.MoboID is NULL
    OR
    (CASE
        WHEN s.interface = "M2" THEN x.M2Slots
        WHEN s.interface = "SATA" THEN x.SataSlots
    END) > 0