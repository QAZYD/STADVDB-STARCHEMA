USE data_warehouse;

-- ===============================
-- Fact Table Indexes (denormFactOrders)
-- ===============================

-- Join index for all OLAP queries
ALTER TABLE denormFactOrders ADD INDEX idx_product_key (product_key);

-- Covering index for quantity aggregations
ALTER TABLE denormFactOrders ADD INDEX idx_product_quantity (product_key, quantity);

-- ===============================
-- Dimension Table Indexes
-- ===============================

-- Single composite index covering all OLAP filter/group operations
ALTER TABLE dimProducts ADD INDEX idx_category_name_price (category, name, price);