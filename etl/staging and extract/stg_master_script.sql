
CREATE DATABASE IF NOT EXISTS staging;
USE staging;


CREATE TABLE IF NOT EXISTS stg_users (
    user_id INT,
    username VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    address_1 VARCHAR(255),
    address_2 VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    zip_code VARCHAR(255),
    phone_number VARCHAR(255),
    date_of_birth VARCHAR(255),
    gender VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE IF NOT EXISTS stg_riders (
    rider_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    vehicle_type VARCHAR(255),
    counter_id INT,
    age INT,
    gender VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);


CREATE TABLE IF NOT EXISTS stg_products (
    product_id INT,                       
    product_code VARCHAR(255),
    category VARCHAR(255),
    description VARCHAR(255),
    name VARCHAR(255),
    price FLOAT,
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE IF NOT EXISTS stg_orders (
    order_id INT,
    order_number VARCHAR(255),
    user_id INT,
    delivery_date VARCHAR(255),
    delivery_rider_id INT,
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE IF NOT EXISTS stg_order_items (
    order_id INT, 
    product_id INT,
    quantity INT,
    notes VARCHAR(255),
    created_at DATETIME, 
    updated_at DATETIME
);

CREATE TABLE stg_denorm_orders AS
SELECT 
    o.order_id,
    o.order_number,
    o.user_id,
    o.delivery_date,
    o.delivery_rider_id,
    oi.product_id,
    oi.quantity,
    oi.notes,
    o.created_at AS order_created_at,
    o.updated_at AS order_updated_at,
    oi.created_at AS item_created_at,
    oi.updated_at AS item_updated_at
FROM stg_orders o
LEFT JOIN stg_order_items oi 
    ON o.order_id = oi.order_id;


