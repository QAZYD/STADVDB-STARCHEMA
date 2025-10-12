SELECT 
    dp.category,
    dp.name,
    SUM(dfo.quantity) as total_quantity
FROM data_warehouse.denormfactorders dfo
JOIN data_warehouse.dimProducts dp
    ON dfo.product_key = dp.product_key
WHERE dp.category IN ('Electronics', 'Gadgets')  
    AND dp.price > 1000                         
GROUP BY 
    dp.category,
    dp.name
ORDER BY 
    dp.category,
    total_quantity DESC;