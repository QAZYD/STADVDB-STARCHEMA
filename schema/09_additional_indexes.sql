ALTER TABLE denormFactOrders ADD INDEX idx_rider_quantity (rider_key, quantity, order_key);

ALTER TABLE denormFactOrders ADD INDEX (rider_key);
ALTER TABLE denormFactOrders ADD INDEX (order_key);
ALTER TABLE dimRiders ADD INDEX (rider_key);

ALTER TABLE denormFactOrders ADD INDEX (user_key);
ALTER TABLE denormFactOrders ADD INDEX (order_key);
ALTER TABLE dimUsers ADD INDEX (user_key);
ALTER TABLE dimUsers ADD INDEX (country);
