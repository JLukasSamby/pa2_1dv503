SELECT COUNT(r.capacity), r.capacity, r.capacity_unit
FROM computer c
    JOIN ram r ON c.ram_id = r.ram_id
GROUP BY r.capacity, r.capacity_unit
ORDER BY r.capacity