CREATE TABLE IF NOT EXISTS chassi (
chassi_id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer VARCHAR(50) NOT NULL,
price INT NULL,
form_factor VARCHAR(50) NOT NULL,
volume INT NOT NULL,
height INT NOT NULL,
width INT NOT NULL,
depth INT NOT NULL,
cooler_height INT NOT NULL,
radiator_max INT NOT NULL,
GPU_max INT NOT NULL,
PRIMARY KEY (chassi_id)
);