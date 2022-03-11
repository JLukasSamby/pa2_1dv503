CREATE TABLE IF NOT EXISTS cpu (
cpu_id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer VARCHAR(50) NOT NULL,
generation VARCHAR(50) NOT NULL,
series VARCHAR(50) NOT NULL,
socket VARCHAR(50) NOT NULL,
price INT NULL,
cores INT NOT NULL,
threads INT NOT NULL,
base_clock FLOAT NOT NULL,
boost_clock FLOAT NULL,
clock_unit VARCHAR(50) NOT NULL,
cache INT NOT NULL,
power_usage INT NOT NULL,
overclockable BOOLEAN NOT NULL,
score INT NULL,
score_type VARCHAR(50) NULL,
PRIMARY KEY (cpu_id)
);