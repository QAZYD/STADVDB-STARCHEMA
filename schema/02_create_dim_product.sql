CREATE DATABASE IF NOT EXISTS data_warehouse;
USE data_warehouse;
CREATE TABLE dimProducts (
    product_key INT AUTO_INCREMENT PRIMARY KEY,  
    source_product_id INT,                       
    product_code VARCHAR(255),
    category VARCHAR(255),
    description VARCHAR(255),
    name VARCHAR(255),
    price FLOAT,
    created_at DATETIME,
    updated_at DATETIME
);
