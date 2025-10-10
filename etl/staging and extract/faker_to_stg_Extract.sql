
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
