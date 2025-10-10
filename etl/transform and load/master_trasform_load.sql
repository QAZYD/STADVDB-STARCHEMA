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
