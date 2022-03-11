CREATE TABLE IF NOT EXISTS gpu (
gpu_id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer VARCHAR(50) NOT NULL,
series VARCHAR(50) NOT NULL,
generation VARCHAR(50) NOT NULL,
price INT NULL,
vram INT NOT NULL,
vram_unit VARCHAR(50) NOT NULL,
vram_type VARCHAR(50) NOT NULL,
interface VARCHAR(50) NOT NULL,
clock INT NOT NULL,
power_usage INT NOT NULL,
length INT NOT NULL,
score INT NULL,
score_type VARCHAR(50) NULL,
PRIMARY KEY (gpu_id)
);