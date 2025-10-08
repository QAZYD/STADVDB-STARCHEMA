CREATE DATABASE IF NOT EXISTS staging;
USE staging;

CREATE TABLE stg_order_items (
    quantity INT,
    notes VARCHAR(255),
    created_at DATETIME, 
    updated_at DATETIME, 
    order_id INT, 
    product_id INT
);
