CREATE DATABASE IF NOT EXISTS staging;
USE staging;

CREATE TABLE stg_users (
    user_id INT,
    username VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    address_1 VARCHAR(255),
    address_2 VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    zip_code VARCHAR(255),
    phone_number VARCHAR(255),
    date_of_birth VARCHAR(255),
    gender VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);
