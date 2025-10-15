SELECT 
    dp.product_key,
    dp.product_code,
    SUM(d.quantity) AS total_quantity,
    COUNT(DISTINCT d.order_key) AS total_orders
FROM denormFactOrders d
JOIN dimProducts dp ON d.product_key = dp.product_key
GROUP BY dp.product_key, dp.product_code;

SELECT 
    dp.category AS product_category,
    SUM(d.quantity) AS total_quantity,
    COUNT(DISTINCT d.order_key) AS total_orders
FROM denormFactOrders d
JOIN dimProducts dp ON d.product_key = dp.product_key
GROUP BY dp.category;

SELECT 
    SUM(d.quantity) AS total_quantity,
    COUNT(DISTINCT d.order_key) AS total_orders
FROM denormFactOrders d;

SELECT 
    u.user_key,
    u.username AS user_name,
    SUM(d.quantity) AS total_quantity,
    COUNT(DISTINCT d.order_key) AS total_orders
FROM denormFactOrders d
JOIN dimUsers u ON d.user_key = u.user_key
GROUP BY u.user_key, u.username;

SELECT 
    u.city AS user_city,
    u.country AS user_country,
    SUM(d.quantity) AS total_quantity,
    COUNT(DISTINCT d.order_key) AS total_orders
FROM denormFactOrders d
JOIN dimUsers u ON d.user_key = u.user_key
GROUP BY u.city, u.country;

SELECT 
    country,
    SUM(total_quantity) AS total_quantity,
    SUM(total_orders) AS total_orders
FROM (
    SELECT 
        u.country,
        SUM(d.quantity) AS total_quantity,
        COUNT(d.order_key) AS total_orders
    FROM denormFactOrders d
    JOIN dimUsers u ON d.user_key = u.user_key
    GROUP BY u.user_key, u.country
) AS user_agg
GROUP BY country;

DROP TEMPORARY TABLE IF EXISTS rider_agg;

CREATE TEMPORARY TABLE rider_agg AS
SELECT 
    rider_key,
    SUM(quantity) AS total_quantity,
    COUNT(order_key) AS total_deliveries
FROM denormFactOrders
GROUP BY rider_key;

SELECT 
    r.rider_key,
    CONCAT_WS(' ', r.first_name, r.last_name) AS rider_name,
    a.total_quantity,
    a.total_deliveries
FROM rider_agg a
JOIN dimRiders r ON a.rider_key = r.rider_key;

SELECT 
    r.vehicle_type,
    SUM(d.quantity) AS total_quantity,
    COUNT(DISTINCT d.order_key) AS total_deliveries
FROM denormFactOrders d
JOIN dimRiders r ON d.rider_key = r.rider_key
GROUP BY r.vehicle_type;
