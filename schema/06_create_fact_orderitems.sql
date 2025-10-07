CREATE DATABASE IF NOT EXISTS data_warehouse;

USE data_warehouse;

CREATE TABLE factOrderItems (
    order_item_key INT AUTO_INCREMENT PRIMARY KEY,
    order_key INT,
    product_key INT,
    quantity INT,
    notes TEXT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (order_key) REFERENCES factOrders(order_key),
    FOREIGN KEY (product_key) REFERENCES dimProducts(product_key)
);
