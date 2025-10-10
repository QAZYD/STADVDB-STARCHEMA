
CREATE DATABASE IF NOT EXISTS data_warehouse;
USE data_warehouse;



-- dim_user
CREATE TABLE dimUsers (
    user_key INT AUTO_INCREMENT PRIMARY KEY,
    source_user_id INT,
    username VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    address_1 VARCHAR(255),
    address_2 VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    zip_code VARCHAR(255),
    phone_number VARCHAR(255),
    date_of_birth DATE,
    gender VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);

-- dim_product
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


-- dim_rider
CREATE TABLE dimRiders (
    rider_key INT AUTO_INCREMENT PRIMARY KEY,
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


CREATE TABLE denormFactOrders (
    order_key INT AUTO_INCREMENT PRIMARY KEY,

    -- Foreign keys (link to dimensions)
    user_key INT,
    rider_key INT,
    product_key INT,

    -- Keep the source order ID for traceability
    source_order_id INT,

    -- Business facts / metrics
    order_number VARCHAR(255),
    quantity INT,
    notes VARCHAR(255),

    -- Timestamps (no separate date dimension for now)
    order_created_at DATETIME,
    order_updated_at DATETIME,
    item_created_at DATETIME,
    item_updated_at DATETIME,

    -- Optional foreign key references
    FOREIGN KEY (user_key) REFERENCES dimUsers(user_key),
    FOREIGN KEY (rider_key) REFERENCES dimRiders(rider_key),
    FOREIGN KEY (product_key) REFERENCES dimProducts(product_key)
);

