SELECT cpu.cpu_id
FROM cpu, (
    SELECT m.socket AS socket, p.power AS MaxPower, COALESCE(g.power_usage, 0) AS GpuPower
    FROM computer c
        LEFT JOIN motherboard m ON c.motherboard_id = m.motherboard_id
        LEFT JOIN power_supply p ON c.power_supply_id = p.power_supply_id
        LEFT JOIN gpu g ON c.gpu_id = g.gpu_id 
    WHERE c.name = ?
) AS x
WHERE
    (x.socket IS NULL OR cpu.socket = x.socket)
    AND
    (x.MaxPower IS NULL OR (cpu.power_usage + x.GpuPower) * 1.5 <= x.MaxPower)