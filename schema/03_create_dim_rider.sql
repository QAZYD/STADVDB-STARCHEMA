USE data_warehouse;

CREATE TABLE dim_rider (
    rider_key INT AUTO_INCREMENT PRIMARY KEY,
    rider_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    vehicle_type VARCHAR(50),
    counter_id INT,
    age INT,
    gender VARCHAR(10),
    created_at DATETIME,
    updated_at DATETIME
);
