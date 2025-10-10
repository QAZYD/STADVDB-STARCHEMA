CREATE DATABASE IF NOT EXISTS staging;
USE staging;

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
