CREATE TABLE denormFactOrders (
    order_key INT AUTO_INCREMENT PRIMARY KEY,

    -- Foreign keys (link to dimensions)
    user_key INT,
    rider_key INT,
    product_key INT,

    -- Keep the source order ID for traceability
    source_order_id INT,

    -- Business facts / metrics
    order_number VARCHAR(255),
    quantity INT,
    notes VARCHAR(255),

    -- Timestamps (no separate date dimension for now)
    order_created_at DATETIME,
    order_updated_at DATETIME,
    item_created_at DATETIME,
    item_updated_at DATETIME,

    -- Optional foreign key references
    FOREIGN KEY (user_key) REFERENCES dimUsers(user_key),
    FOREIGN KEY (rider_key) REFERENCES dimRiders(rider_key),
    FOREIGN KEY (product_key) REFERENCES dimProducts(product_key)
);
