CREATE DATABASE IF NOT EXISTS data_warehouse;
USE data_warehouse;
CREATE TABLE factOrders (
    order_key INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50),
    user_key INT,
    rider_key INT,
    date_key INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (user_key) REFERENCES dimUsers(user_key),
    FOREIGN KEY (rider_key) REFERENCES dimRiders(rider_key),
    FOREIGN KEY (date_key) REFERENCES dimDates(date_key)
);
