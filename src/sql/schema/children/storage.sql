CREATE TABLE IF NOT EXISTS storage (
storage_id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer VARCHAR(50) NOT NULL,
price INT NULL,
capacity INT NOT NULL,
capacity_unit VARCHAR(50) NOT NULL,
read_speed INT NOT NULL,
write_speed INT NOT NULL,
type VARCHAR(50) NOT NULL,
interface VARCHAR(50) NOT NULL,
PRIMARY KEY (storage_id)
);