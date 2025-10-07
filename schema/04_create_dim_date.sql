CREATE DATABASE IF NOT EXISTS data_warehouse;
USE data_warehouse;
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,        
    full_date DATE,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT,
    day_of_week INT,
    day_name VARCHAR(20),
    is_weekend BOOLEAN
);
