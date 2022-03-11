SELECT clr.cooler_id
FROM cooler clr, (
    SELECT cpu.power_usage AS CpuPower, ch.cooler_height AS MaxHeight, ch.radiator_max AS MaxRadiator
    FROM computer c
        LEFT JOIN cpu ON c.cpu_id = cpu.cpu_id
        LEFT JOIN chassi ch ON c.chassi_id = ch.chassi_id
    WHERE c.name = ?
) AS x
WHERE
    (x.CpuPower IS NULL OR clr.tdp >= x.CpuPower)
    AND
    (x.MaxHeight IS NULL OR clr.height <= x.MaxHeight)
    AND
    (x.MaxRadiator IS NULL OR clr.radiator_size <= x.MaxRadiator)