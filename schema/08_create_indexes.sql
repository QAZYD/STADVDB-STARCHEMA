USE data_warehouse;

-- ===============================
-- Fact Table Indexes (denormFactOrders)
-- ===============================

-- Join index for all OLAP queries
ALTER TABLE denormFactOrders ADD INDEX idx_product_key (product_key);

-- Covering index for quantity aggregations by product
ALTER TABLE denormFactOrders ADD INDEX idx_product_quantity (product_key, quantity);

-- Covering index for rider delivery queries (order-level aggregation)
ALTER TABLE denormFactOrders ADD INDEX idx_order_rider_quantity (order_key, rider_key, quantity);

-- Covering index for rider-based aggregations (simplified queries)
ALTER TABLE denormFactOrders ADD INDEX idx_rider_quantity (rider_key, quantity);

-- ===============================
-- Dimension Table Indexes
-- ===============================

-- Covering index for product category and name queries
ALTER TABLE dimProducts ADD INDEX idx_category_name_price (category, name, price);

-- Covering index for rider queries with vehicle type grouping
ALTER TABLE dimRiders ADD INDEX idx_vehicle_rider (vehicle_type, rider_key, first_name, last_name);