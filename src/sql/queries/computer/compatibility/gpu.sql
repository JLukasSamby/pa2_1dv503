SELECT g.gpu_id
FROM gpu g, (
    SELECT ch.gpu_max AS MaxGpuLength, p.power AS MaxPower, COALESCE(cpu.power_usage, 0) AS CpuPower
    FROM computer c
        LEFT JOIN chassi ch ON c.chassi_id = ch.chassi_id
        LEFT JOIN power_supply p ON c.power_supply_id = p.power_supply_id
        LEFT JOIN cpu ON c.cpu_id = cpu.cpu_id
    WHERE c.name = ?
) AS x
WHERE
    (x.MaxGpuLength IS NULL OR g.length <= x.MaxGpuLength)
    AND
    (x.MaxPower IS NULL OR (g.power_usage + x.CpuPower) * 1.5 <= x.MaxPower)