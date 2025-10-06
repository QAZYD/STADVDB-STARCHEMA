USE data_warehouse;
CREATE TABLE dimProducts (
    product_key INT AUTO_INCREMENT PRIMARY KEY,  
    source_product_id INT,                       
    product_code VARCHAR(100),
    category VARCHAR(100),
    description VARCHAR(255),
    name VARCHAR(150),
    price DECIMAL(10,2),
    created_at DATETIME,
    updated_at DATETIME
);
