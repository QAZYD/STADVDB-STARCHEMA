SELECT dp.name, SUM(dfo.quantity) AS total_quantity
FROM data_warehouse.denormfactorders dfo
JOIN data_warehouse.dimProducts dp
    ON dfo.product_key = dp.product_key
WHERE dp.category = 'Appliances'
GROUP BY dp.name
ORDER BY total_quantity DESC;
