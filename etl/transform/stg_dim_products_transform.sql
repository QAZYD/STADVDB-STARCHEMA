SET SQL_SAFE_UPDATES = 0;

UPDATE staging.stg_products
SET price = NULL
WHERE price = '' OR price NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';

SET SQL_SAFE_UPDATES = 1;

INSERT INTO dimProducts (
    source_product_id,
    product_code,
    category,
    description,
    name,
    price,
    created_at,
    updated_at
)
SELECT
    product_id,
    product_code,
    category,
    description,
    name,
    price,
    created_at,
    updated_at
FROM staging.stg_products;
