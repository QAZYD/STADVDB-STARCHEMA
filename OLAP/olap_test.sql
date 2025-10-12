SELECT
    dp.category AS product_category,
    SUM(dfo.quantity) AS total_quantity_ordered
FROM data_warehouse.denormfactorders dfo
JOIN data_warehouse.dimProducts dp
    ON dfo.product_key = dp.product_key
GROUP BY dp.category
ORDER BY total_quantity_ordered DESC;
