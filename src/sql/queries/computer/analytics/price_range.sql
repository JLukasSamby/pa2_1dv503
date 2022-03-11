SELECT COUNT(price_tier), price_tier
FROM
    (SELECT
        CASE
            WHEN x.Price >= 47000 THEN "Deity (infinity, 47000]"
            WHEN x.Price < 47000 AND x.Price >= 33500 THEN "Monstrous (47000, 33500]"
            WHEN x.Price < 33500 AND x.Price >= 27000 THEN "Extremist (33500, 27000]"
            WHEN x.Price < 27000 AND x.Price >= 23000 THEN "Enthusiast (27000, 23000]"
            WHEN x.Price < 23000 AND x.Price >= 21000 THEN "Exceptional (23000, 21000]"
            WHEN x.Price < 21000 AND x.Price >= 18000 THEN "Outstanding (21000, 18000]"
            WHEN x.Price < 18000 AND x.Price >= 16800 THEN "Excellent (18000, 16800]"
            WHEN x.Price < 16800 AND x.Price >= 14500 THEN "Superb (14500, 16800]"
            WHEN x.Price < 14500 AND x.Price >= 12000 THEN "Great (12000, 14500]"
            WHEN x.Price < 12000 AND x.Price >= 11000 THEN "Very Good (11000, 12000]"
            WHEN x.Price < 11000 AND x.Price >= 8400 THEN "Good (8400, 11000]"
            WHEN x.Price < 8400 AND x.Price >= 6300 THEN "Modest (6300, 8400]"
            WHEN x.Price < 6300 AND x.Price >= 5500 THEN "Entry (5500, 6300]"
            WHEN x.Price < 5500 AND x.Price >= 4000 THEN "Minimum (4000, 5500]"
            WHEN x.Price < 4000 AND x.Price >= 3000 THEN "Poor (3000, 4000]"
            WHEN x.Price < 3000 THEN "Destitute [0, 3000)"
        END AS price_tier
    FROM (
        SELECT (cpu.price + g.price + r.price + s.price + ch.price + p.price + m.price + clr.price) AS Price
        FROM computer c
            LEFT JOIN cpu ON c.cpu_id = cpu.cpu_id
            LEFT JOIN gpu g ON c.gpu_id = g.gpu_id
            LEFT JOIN ram r ON c.ram_id = r.ram_id
            LEFT JOIN storage s ON c.storage_id = s.storage_id
            LEFT JOIN chassi ch ON c.chassi_id = ch.chassi_id
            LEFT JOIN power_supply p ON c.power_supply_id = p.power_supply_id
            LEFT JOIN motherboard m ON c.motherboard_id = m.motherboard_id
            LEFT JOIN cooler clr ON c.cooler_id = clr.cooler_id
        ) AS x ) AS y
GROUP BY price_tier