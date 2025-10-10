CREATE DATABASE IF NOT EXISTS staging;
USE staging;

CREATE TABLE stg_riders(
    rider_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    vehicle_type VARCHAR(255),
    counter_id INT,
    age INT,
    gender VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);