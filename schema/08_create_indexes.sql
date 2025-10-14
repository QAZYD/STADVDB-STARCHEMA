USE data_warehouse;

-- Fact table indexes (for FK)
ALTER TABLE denormFactOrders ADD INDEX idx_user_key (user_key) IGNORE;
ALTER TABLE denormFactOrders ADD INDEX idx_product_key (product_key) IGNORE;
ALTER TABLE denormFactOrders ADD INDEX idx_rider_key (rider_key) IGNORE;

-- Date-based indexes for time analysis
ALTER TABLE denormFactOrders ADD INDEX idx_order_date (order_created_at) IGNORE;

-- Source ID index (useful for data lineage and troubleshooting)
ALTER TABLE denormFactOrders ADD INDEX idx_source_order (source_order_id) IGNORE;

-- Dimension table indexes for commonly filtered attributes
ALTER TABLE dimProducts ADD INDEX idx_category (category) IGNORE;
ALTER TABLE dimProducts ADD INDEX idx_price (price) IGNORE;
ALTER TABLE dimUsers ADD INDEX idx_country (country) IGNORE;
ALTER TABLE dimUsers ADD INDEX idx_city (city) IGNORE;
ALTER TABLE dimRiders ADD INDEX idx_vehicle_type (vehicle_type) IGNORE;

-- Compound indexes for common query patterns
ALTER TABLE denormFactOrders ADD INDEX idx_product_date (product_key, order_created_at) IGNORE;
ALTER TABLE denormFactOrders ADD INDEX idx_user_date (user_key, order_created_at) IGNORE;
