USE data_warehouse;

-- ===============================
-- Fact Table Indexes (denormFactOrders)
-- ===============================

-- Foreign key / join columns
ALTER TABLE denormFactOrders ADD INDEX idx_user_key (user_key);
ALTER TABLE denormFactOrders ADD INDEX idx_product_key (product_key);
ALTER TABLE denormFactOrders ADD INDEX idx_rider_key (rider_key);

-- Date-based index for time analysis
ALTER TABLE denormFactOrders ADD INDEX idx_order_date (order_created_at);

-- Source order ID index (for troubleshooting / lineage)
ALTER TABLE denormFactOrders ADD INDEX idx_source_order (source_order_id);

-- Compound indexes for common query patterns
ALTER TABLE denormFactOrders ADD INDEX idx_product_date (product_key, order_created_at);
ALTER TABLE denormFactOrders ADD INDEX idx_user_date (user_key, order_created_at);

-- ===============================
-- Dimension Table Indexes
-- ===============================

-- dimProducts
ALTER TABLE dimProducts ADD INDEX idx_category (category);
ALTER TABLE dimProducts ADD INDEX idx_price (price);
ALTER TABLE dimProducts ADD INDEX idx_product_key_category_name (product_key, category, name);

-- dimUsers
ALTER TABLE dimUsers ADD INDEX idx_country (country);
ALTER TABLE dimUsers ADD INDEX idx_city (city);

-- dimRiders
ALTER TABLE dimRiders ADD INDEX idx_vehicle_type (vehicle_type);

-- Optimize aggregation queries by product (For olap_test 1 and 2)
ALTER TABLE denormFactOrders ADD INDEX idx_product_quantity (product_key, quantity);