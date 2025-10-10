INSERT INTO data_warehouse.denormFactOrders (
    user_key,
    rider_key,
    product_key,
    source_order_id,
    order_number,
    quantity,
    notes,
    order_created_at,
    order_updated_at,
    item_created_at,
    item_updated_at
)
SELECT
    du.user_key,
    dr.rider_key,
    dp.product_key,
    sdo.order_id AS source_order_id,
    TRIM(sdo.order_number) AS order_number,
    COALESCE(sdo.quantity, 0) AS quantity,
    NULLIF(TRIM(sdo.notes), '') AS notes,
    sdo.order_created_at,
    sdo.order_updated_at,
    sdo.item_created_at,
    sdo.item_updated_at
FROM staging.stg_denorm_orders sdo
LEFT JOIN data_warehouse.dimUsers du
    ON sdo.user_id = du.source_user_id
LEFT JOIN data_warehouse.dimRiders dr
    ON sdo.delivery_rider_id = dr.rider_id
LEFT JOIN data_warehouse.dimProducts dp
    ON sdo.product_id = dp.source_product_id
WHERE sdo.order_id IS NOT NULL;
