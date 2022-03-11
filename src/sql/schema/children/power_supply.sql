CREATE TABLE IF NOT EXISTS power_supply (
power_supply_id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer VARCHAR(50) NOT NULL,
price INT NULL,
power INT NOT NULL,
power_unit VARCHAR(50) NOT NULL,
form_factor VARCHAR(50) NOT NULL,
rating VARCHAR(50) NOT NULL,
PRIMARY KEY (power_supply_id)
);