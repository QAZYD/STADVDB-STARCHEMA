
CREATE DATABASE IF NOT EXISTS data_warehouse;
USE data_warehouse;



-- dim_user
CREATE TABLE dimUsers (
    user_key INT AUTO_INCREMENT PRIMARY KEY,
    source_user_id INT,
    username VARCHAR(100),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    address_1 VARCHAR(255),
    address_2 VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100),
    zip_code VARCHAR(20),
    phone_number VARCHAR(30),
    date_of_birth DATE,
    gender VARCHAR(10),
    created_at DATETIME,
    updated_at DATETIME
);

-- dim_product
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


-- dim_rider
CREATE TABLE dim_rider (
    rider_key INT AUTO_INCREMENT PRIMARY KEY,
    rider_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    vehicle_type VARCHAR(50),
    counter_id INT,
    age INT,
    gender VARCHAR(10),
    created_at DATETIME,
    updated_at DATETIME
);


-- dim_date
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,        
    full_date DATE,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT,
    day_of_week INT,
    day_name VARCHAR(20),
    is_weekend BOOLEAN
);


-- fact_orders
CREATE TABLE factOrders (
    order_key INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50),
    user_key INT,
    rider_key INT,
    date_key INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (user_key) REFERENCES dimUsers(user_key),
    FOREIGN KEY (rider_key) REFERENCES dimRiders(rider_key),
    FOREIGN KEY (date_key) REFERENCES dimDates(date_key)
);


-- fact_orderitems
CREATE TABLE factOrderItems (
    order_item_key INT AUTO_INCREMENT PRIMARY KEY,
    order_key INT,
    product_key INT,
    quantity INT,
    notes TEXT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (order_key) REFERENCES factOrders(order_key),
    FOREIGN KEY (product_key) REFERENCES dimProducts(product_key)
);
