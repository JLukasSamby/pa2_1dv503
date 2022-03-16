SELECT COUNT(power_rating), power_rating
FROM
    (SELECT
        CASE
            WHEN x.PowerUsage >= 1000 THEN "High power (>1000W)"
            WHEN x.PowerUsage < 1000 AND x.PowerUsage >= 600 THEN "Mid power (999-600W)"
            WHEN x.PowerUsage < 600 AND x.PowerUsage >= 200 THEN "Low power (599-200W)"
            WHEN x.PowerUsage < 200 THEN "Very low power (<200W)"
        END AS power_rating
    FROM (
        SELECT (cpu.power_usage + g.power_usage) * 1.5 AS PowerUsage
        FROM computer c
            LEFT JOIN cpu ON c.cpu_id = cpu.cpu_id
            LEFT JOIN gpu g ON c.gpu_id = g.gpu_id 
        ) AS x) AS y
GROUP BY power_rating