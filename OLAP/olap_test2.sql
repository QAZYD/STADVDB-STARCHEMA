
SELECT dp.category, dp.name, SUM(dfo.quantity) AS total_quantity
FROM data_warehouse.denormfactorders dfo
JOIN data_warehouse.dimProducts dp
    ON dfo.product_key = dp.product_key
GROUP BY dp.category, dp.name
ORDER BY dp.category, total_quantity DESC
LIMIT 10000000;