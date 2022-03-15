SELECT ch.chassi_id
FROM chassi ch, (
    SELECT FormFactorLevel(m.form_factor) AS MoboFFLevel, FormFactorLevel(p.form_factor) AS PsuFFLevel, clr.height AS CoolerHeight, clr.radiator_size AS RadiatorSize, g.length AS GpuLength
    FROM computer c
        LEFT JOIN motherboard m ON c.motherboard_id = m.motherboard_id
        LEFT JOIN power_supply p ON c.power_supply_id = p.power_supply_id
        LEFT JOIN cooler clr ON c.cooler_id = clr.cooler_id 
        LEFT JOIN gpu g ON c.gpu_id = g.gpu_id
    WHERE c.name = ?
) AS x
WHERE
    (x.MoboFFLevel IS NULL OR FormFactorLevel(ch.form_factor) >= x.MoboFFLevel)
    AND
    (x.psuFFLevel IS NULL OR FormFactorLevel(ch.form_factor) >= x.PsuFFLevel)
    AND
    (x.CoolerHeight IS NULL OR ch.cooler_height >= x.CoolerHeight)
    AND
    (x.RadiatorSize IS NULL OR ch.radiator_max >= x.RadiatorSize)
    AND
    (x.GpuLength IS NULL OR ch.gpu_max >= x.GpuLength)
