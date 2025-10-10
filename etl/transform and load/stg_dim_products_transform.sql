INSERT INTO data_warehouse.dimProducts (
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
    product_id AS source_product_id,
    TRIM(product_code) AS product_code,
    CONCAT(UPPER(LEFT(TRIM(category), 1)), LOWER(SUBSTRING(TRIM(category), 2))) AS category,
    TRIM(description) AS description,
    CONCAT(UPPER(LEFT(TRIM(name), 1)), LOWER(SUBSTRING(TRIM(name), 2))) AS name,

    CASE
        WHEN price IS NULL OR price < 0 THEN 0
        ELSE price
    END AS price,

    created_at,
    updated_at
FROM staging.stg_products
WHERE product_id IS NOT NULL;
