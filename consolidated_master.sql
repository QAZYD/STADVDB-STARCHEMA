
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




INSERT INTO staging.stg_users
SELECT 
    id AS user_id,
    username,
    firstName AS first_name,
    lastName AS last_name,
    address1 AS address_1,
    address2 AS address_2,
    city,
    country,
    zipCode AS zip_code,
    phoneNumber AS phone_number,
    dateOfBirth AS date_of_birth,
    gender,
    createdAt AS created_at,
    updatedAt AS updated_at
FROM faker.users;

INSERT INTO staging.stg_riders 
SELECT 
    id AS rider_id,
    firstName AS first_name, 
    lastName AS last_name,
    vehicleType AS vehicle_type,
    courierId AS courier_id,
    age,
    gender,
    createdAt AS created_at,
    updatedAt AS updated_at
FROM faker.riders;


INSERT INTO staging.stg_products
SELECT 
    id AS product_id,
    productCode AS product_code,
    category,
    description,
    name,
    price,
    createdAt AS created_at,
    updatedAt AS updated_at
FROM faker.products;

INSERT INTO staging.stg_orders
SELECT
    id AS order_id,
    orderNumber AS order_number,
    userId AS user_id,
    deliveryDate AS delivery_date,
    deliveryRiderId AS delivery_rider_id,
    createdAt AS created_at,
    updatedAt AS updated_at
FROM faker.orders;

INSERT INTO staging.stg_order_items (
    quantity,
    notes,
    created_at,
    updated_at,
    order_id,
    product_id
)
SELECT 
    quantity,
    notes,
    createdAt,
    updatedAt,
    OrderId,
    ProductId
FROM faker.orderitems;

INSERT INTO staging.stg_denorm_orders (
    order_id,
    order_number,
    user_id,
    delivery_date,
    delivery_rider_id,
    product_id,
    quantity,
    notes,
    order_created_at,
    order_updated_at,
    item_created_at,
    item_updated_at
)
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
FROM staging.stg_orders o
LEFT JOIN staging.stg_order_items oi 
    ON o.order_id = oi.order_id;




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

INSERT INTO data_warehouse.dimProducts (
    source_product_id,
    product_code,
    category,
    description,
    name,
    price,
    created_at,
    updated_at
)
SELECT
    product_id AS source_product_id,
    TRIM(product_code) AS product_code,
    CONCAT(UPPER(LEFT(TRIM(category), 1)), LOWER(SUBSTRING(TRIM(category), 2))) AS category,
    TRIM(description) AS description,
    CONCAT(UPPER(LEFT(TRIM(name), 1)), LOWER(SUBSTRING(TRIM(name), 2))) AS name,

    CASE
        WHEN price IS NULL OR price < 0 THEN 0
        ELSE price
    END AS price,

    created_at,
    updated_at
FROM staging.stg_products
WHERE product_id IS NOT NULL;

INSERT INTO data_warehouse.dimRiders (
    rider_id,
    first_name,
    last_name,
    vehicle_type,
    counter_id,
    age,
    gender,
    created_at,
    updated_at
)
SELECT
    rider_id,
    CONCAT(UPPER(LEFT(TRIM(first_name), 1)), LOWER(SUBSTRING(TRIM(first_name), 2))) AS first_name,
    CONCAT(UPPER(LEFT(TRIM(last_name), 1)), LOWER(SUBSTRING(TRIM(last_name), 2))) AS last_name,
    CONCAT(UPPER(LEFT(TRIM(vehicle_type), 1)), LOWER(SUBSTRING(TRIM(vehicle_type), 2))) AS vehicle_type,
    counter_id,
    CASE
        WHEN age < 0 OR age IS NULL THEN NULL
        ELSE age
    END AS age,
    LOWER(TRIM(gender)) AS gender,
    created_at,
    updated_at
FROM staging.stg_riders
WHERE rider_id IS NOT NULL;

INSERT INTO data_warehouse.dimUsers (
    source_user_id,
    username,
    first_name,
    last_name,
    address_1,
    address_2,
    city,
    country,
    zip_code,
    phone_number,
    date_of_birth,
    gender,
    created_at,
    updated_at
)
SELECT
    user_id AS source_user_id,
    TRIM(username) AS username,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    NULLIF(TRIM(address_1), '') AS address_1,
    NULLIF(TRIM(address_2), '') AS address_2,
    TRIM(city) AS city,
    TRIM(country) AS country,
    NULLIF(TRIM(zip_code), '') AS zip_code,
    TRIM(phone_number) AS phone_number,
    CASE
        WHEN date_of_birth LIKE '%/%/%'
            THEN STR_TO_DATE(date_of_birth, '%m/%d/%Y')
        WHEN date_of_birth LIKE '%-%-%'
            THEN STR_TO_DATE(date_of_birth, '%Y-%m-%d')
        ELSE NULL
    END AS date_of_birth,
    LOWER(TRIM(gender)) AS gender,
    created_at,
    updated_at
FROM staging.stg_users
WHERE user_id IS NOT NULL;

INSERT INTO data_warehouse.denormFactOrders (
    user_key,
    rider_key,
    product_key,
    source_order_id,
    order_number,
    quantity,
    notes,
    order_created_at,
    order_updated_at,
    item_created_at,
    item_updated_at
)
SELECT
    du.user_key,
    dr.rider_key,
    dp.product_key,
    sdo.order_id AS source_order_id,
    TRIM(sdo.order_number) AS order_number,
    COALESCE(sdo.quantity, 0) AS quantity,
    NULLIF(TRIM(sdo.notes), '') AS notes,
    sdo.order_created_at,
    sdo.order_updated_at,
    sdo.item_created_at,
    sdo.item_updated_at
FROM staging.stg_denorm_orders sdo
LEFT JOIN data_warehouse.dimUsers du
    ON sdo.user_id = du.source_user_id
LEFT JOIN data_warehouse.dimRiders dr
    ON sdo.delivery_rider_id = dr.rider_id
LEFT JOIN data_warehouse.dimProducts dp
    ON sdo.product_id = dp.source_product_id
WHERE sdo.order_id IS NOT NULL;
