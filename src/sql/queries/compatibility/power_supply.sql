SELECT p.power_supply_id
FROM power_supply p, (
    SELECT (1.5 * (COALESCE(cpu.power_usage, 0) + COALESCE(g.power_usage, 0))) AS SysPower, FormFactorLevel(ch.form_factor) AS ChassiFFLevel
    FROM computer c
        LEFT JOIN cpu ON c.cpu_id = cpu.cpu_id
        LEFT JOIN gpu g ON c.gpu_id = g.gpu_id
        LEFT JOIN chassi ch ON c.chassi_id = ch.chassi_id
    WHERE c.name = ?
) AS x
WHERE
    (x.SysPower <= p.power)
    AND
    (x.ChassiFFLevel IS NULL OR FormFactorLevel(p.form_factor) <= x.ChassiFFLevel)