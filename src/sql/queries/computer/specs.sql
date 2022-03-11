CREATE VIEW SpecSheet AS
SELECT
    c.name AS ComputerName,
    CONCAT_WS(" ", cpu.manufacturer, cpu.series, cpu.name, cpu.base_clock, cpu.clock_unit) AS CPU,
    CONCAT_WS(" ", g.manufacturer, g.series, g.name, g.vram, g.vram_unit, g.vram_type) AS GPU,
    CONCAT_WS(" ", r.manufacturer, r.name, r.capacity, r.capacity_unit, r.latency, r.speed, r.speed_unit) AS RAM,
    CONCAT_WS(" ", s.manufacturer, s.name, s.capacity, s.capacity_unit, s.interface, s.type) AS Storage,
    CONCAT_WS(" ", ch.manufacturer, ch.name, ch.form_factor) AS Chassi,
    CONCAT_WS(" ", p.manufacturer, p.name, p.power, p.power_unit) AS PSU,
    (cpu.price + g.price + r.price + s.price + ch.price + p.price + m.price + clr.price) AS Price
FROM
    computer c
LEFT JOIN cpu ON c.cpu_id = cpu.cpu_id
LEFT JOIN gpu g ON c.gpu_id = g.gpu_id
LEFT JOIN ram r ON c.ram_id = r.ram_id
LEFT JOIN storage s ON c.storage_id = s.storage_id
LEFT JOIN chassi ch ON c.chassi_id = ch.chassi_id
LEFT JOIN power_supply p ON c.power_supply_id = p.power_supply_id
LEFT JOIN motherboard m ON c.motherboard_id = m.motherboard_id
LEFT JOIN cooler clr ON c.cooler_id = clr.cooler_id