import express from "express";

export default function rollupRoutes(db) {
  const router = express.Router();

  // === Product Rollup (exact SQL you gave) ===
  router.get("/product-rollup", (req, res) => {
  const offset = parseInt(req.query.offset) || 0;
  const limit = parseInt(req.query.limit) || 100;

  const query = `
    SELECT 
        dp.product_key,
        dp.product_code,
        SUM(d.quantity) AS total_quantity,
        COUNT(DISTINCT d.order_key) AS total_orders
    FROM denormFactOrders d
    JOIN dimProducts dp ON d.product_key = dp.product_key
    GROUP BY dp.product_key, dp.product_code
    LIMIT ? OFFSET ?;
  `;

  db.query(query, [limit, offset], (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.json({ data: results, row_count: results.length });
  });
});


router.get("/product-category-rollup", (req, res) => {
  const offset = parseInt(req.query.offset) || 0;
  const limit = parseInt(req.query.limit) || 100;

  const query = `
    SELECT 
        dp.category AS product_category,
        SUM(d.quantity) AS total_quantity,
        COUNT(DISTINCT d.order_key) AS total_orders
    FROM denormFactOrders d
    JOIN dimProducts dp ON d.product_key = dp.product_key
    GROUP BY dp.category
    LIMIT ? OFFSET ?;
  `;

  db.query(query, [limit, offset], (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.json({ data: results, row_count: results.length });
  });
});

// === Total Rollup ===
router.get("/total-rollup", (req, res) => {
  const query = `
    SELECT 
        SUM(d.quantity) AS total_quantity,
        COUNT(DISTINCT d.order_key) AS total_orders
    FROM denormFactOrders d;
  `;

  db.query(query, (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.json({ data: results[0] }); // single row expected
  });
});


  return router;
}
