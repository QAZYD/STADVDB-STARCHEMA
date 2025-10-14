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

-- Optimize aggregation queries by product (For olap_test 1 and 2)
ALTER TABLE denormFactOrders ADD INDEX idx_product_quantity (product_key, quantity);

-- Optimize GROUP BY for category and product name queries(For olap_test 2)
ALTER TABLE dimProducts ADD INDEX idx_category_name (category, name);

-- ===============================
-- Dimension Table Indexes
-- ===============================

-- dimProducts
ALTER TABLE dimProducts ADD INDEX idx_category (category);
ALTER TABLE dimProducts ADD INDEX idx_category_name (category, name);

-- dimUsers
ALTER TABLE dimUsers ADD INDEX idx_country (country);
ALTER TABLE dimUsers ADD INDEX idx_city (city);

-- dimRiders
ALTER TABLE dimRiders ADD INDEX idx_vehicle_type (vehicle_type);


-- ===============================
-- OLAP Test 3 (Slice by Category)
-- ===============================
-- Query filters by dp.category = 'Appliances' and groups by dp.name
-- These indexes support fast category filtering and grouping by product name

-- Composite index to optimize WHERE dp.category + GROUP BY dp.name
ALTER TABLE dimProducts ADD INDEX idx_category_name_slice (category, name);

-- Supporting index to accelerate joins and quantity aggregation
ALTER TABLE denormFactOrders ADD INDEX idx_product_quantity_slice (product_key, quantity);

-- ===============================
-- OLAP Test 4 (Dice by Category and Price)
-- ===============================
-- Query filters by dp.category IN (...) and dp.price > 1000
-- and groups by dp.category, dp.name
-- These composite indexes optimize both filtering and aggregation

-- Composite index for category and price filtering
ALTER TABLE dimProducts ADD INDEX idx_category_price (category, price);

-- Composite index to speed up category + name grouping under filters
ALTER TABLE dimProducts ADD INDEX idx_category_name_price (category, name, price);

-- Supporting covering index in fact table to optimize quantity aggregation by product
ALTER TABLE denormFactOrders ADD INDEX idx_product_quantity_dice (product_key, quantity);
