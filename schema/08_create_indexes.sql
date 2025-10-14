USE data_warehouse;

-- Fact table indexes (for FK)
ALTER TABLE denormFactOrders ADD INDEX idx_user_key (user_key);
ALTER TABLE denormFactOrders ADD INDEX idx_product_key (product_key);
ALTER TABLE denormFactOrders ADD INDEX idx_rider_key (rider_key);

-- Date-based indexes for time analysis
ALTER TABLE denormFactOrders ADD INDEX idx_order_date (order_created_at);

-- Source ID index (useful for data lineage and troubleshooting)
ALTER TABLE denormFactOrders ADD INDEX idx_source_order (source_order_id);


-- Dimension table indexes for commonly filtered attributes
/*ALTER TABLE dimProducts ADD INDEX idx_category (category);
ALTER TABLE dimProducts ADD INDEX idx_price (price);
ALTER TABLE dimUsers ADD INDEX idx_country (country);
ALTER TABLE dimUsers ADD INDEX idx_city (city);
ALTER TABLE dimRiders ADD INDEX idx_vehicle_type (vehicle_type);

-- Compound indexes for common query patterns
ALTER TABLE denormFactOrders ADD INDEX idx_product_date (product_key, order_created_at);
ALTER TABLE denormFactOrders ADD INDEX idx_user_date (user_key, order_created_at);*/