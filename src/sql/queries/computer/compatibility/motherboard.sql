SELECT m.motherboard_id
FROM motherboard m, (
    SELECT cpu.socket AS CpuSocket, FormFactorLevel(ch.form_factor) AS ChassiFFLevel, s.interface AS StorageInterface, r.stick_count AS RamCount, r.type AS RamType
    FROM computer c
        LEFT JOIN cpu ON c.cpu_id = cpu.cpu_id
        LEFT JOIN chassi ch ON c.chassi_id = ch.chassi_id
        LEFT JOIN storage s ON c.storage_id = s.storage_id
        LEFT JOIN ram r ON c.ram_id = r.ram_id
    WHERE c.name = ?
) AS x
WHERE
    (x.CpuSocket IS NULL OR m.socket = x.CpuSocket)
    AND
    (x.ChassiFFLevel IS NULL OR FormFactorLevel(m.form_factor) <= x.ChassiFFLevel)
    AND
        (x.StorageInterface IS NULL 
        OR
            (
            CASE
                WHEN x.StorageInterface = "M2" THEN m.M2_slots
                WHEN x.StorageInterface = "SATA" THEN m.SATA_slots
            END
            ) > 0
        )
    AND
    (x.RamCount IS NULL OR m.RAM_slots >= x.RamCount)
    AND
    (x.RamType IS NULL OR m.RAM_type = x.RamType)