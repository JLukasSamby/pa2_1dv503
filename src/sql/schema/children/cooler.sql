CREATE TABLE IF NOT EXISTS cooler (
cooler_id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer VARCHAR(50) NOT NULL,
price INT NULL,
tdp INT NOT NULL,
height INT NULL,
RAM_clearance INT NULL,
radiator_size INT NULL,
PRIMARY KEY (cooler_id)
);