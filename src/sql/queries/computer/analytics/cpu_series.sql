SELECT COUNT(cpu.series), cpu.manufacturer, cpu.series
FROM computer c
    LEFT JOIN cpu ON c.cpu_id = cpu.cpu_id
GROUP BY cpu.series, cpu.manufacturer
ORDER BY cpu.manufacturer