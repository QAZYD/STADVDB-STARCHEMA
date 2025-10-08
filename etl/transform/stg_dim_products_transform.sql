USE data_warehouse;

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
    s.product_id AS source_product_id,
    TRIM(s.product_code) AS product_code,
    TRIM(s.category) AS category,
    TRIM(s.description) AS description,
    TRIM(s.name) AS name,

    -- Handle invalid or negative prices
    CASE
        WHEN s.price IS NULL OR s.price < 0 THEN 0
        ELSE s.price
    END AS price,

    s.created_at,
    s.updated_at
FROM staging.stg_products s
WHERE s.product_id IS NOT NULL;
