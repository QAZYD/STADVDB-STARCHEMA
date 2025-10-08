CREATE DATABASE IF NOT EXISTS staging;
USE staging;

CREATE TABLE stg_orders (
    order_id INT,
    order_number VARCHAR(255),
    user_id INT,
    delivery_date VARCHAR(255),
    delivery_rider_id INT,
    created_at DATETIME,
    updated_at DATETIME
);
