SELECT COUNT(price_tier), price_tier
FROM
    (SELECT
        CASE
            WHEN x.Price >= 25000 THEN "Extreme (infinity, 25000]"
            WHEN x.Price < 9000 THEN "Low End (0, 9000]"
            WHEN x.Price < 13000 AND x.Price >= 9000 THEN "Average (9000, 13000]"
            WHEN x.Price < 25000 AND x.Price >= 13000 THEN "High End (25000, 13000]"
        END AS price_tier
    FROM SpecSheet x) AS y
GROUP BY price_tier