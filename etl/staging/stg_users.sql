CREATE TABLE stg_users (
    user_id INT,
    username VARCHAR(100),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    address_1 VARCHAR(255),
    address_2 VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100),
    zip_code VARCHAR(20),
    phone_number VARCHAR(30),
    date_of_birth DATE,
    gender VARCHAR(10),
    created_at DATETIME,
    updated_at DATETIME
);
