-- 1. Ensure the schema exists
CREATE DATABASE IF NOT EXISTS data_warehouse;
USE data_warehouse;

SOURCE 01_create_dim_user.sql;
SOURCE 02_create_dim_product.sql;
SOURCE 03_create_dim_rider.sql;
SOURCE 04_create_dim_date.sql;

-- 3. Create fact tables after dimensions
SOURCE 06_create_fact_orderitems.sql;
SOURCE 07_create_fact_orders.sql;
