import express from "express";

export default function userRollupRoutes(db) {
  const router = express.Router();

  // === 1. User Rollup (per individual user) ===
  router.get("/user-rollup", (req, res) => {
    const offset = parseInt(req.query.offset) || 0;
    const limit = parseInt(req.query.limit) || 100;

    const query = `
      SELECT 
          u.user_key,
          u.username AS user_name,
          SUM(d.quantity) AS total_quantity,
          COUNT(DISTINCT d.order_key) AS total_orders
      FROM denormFactOrders d
      JOIN dimUsers u ON d.user_key = u.user_key
      GROUP BY u.user_key, u.username
      LIMIT ? OFFSET ?;
    `;

    db.query(query, [limit, offset], (err, results) => {
      if (err) return res.status(500).send("Database error (user-rollup)");
      res.json({ data: results, row_count: results.length });
    });
  });

  // === 2. User City-Country Rollup ===
  router.get("/user-location-rollup", (req, res) => {
    const offset = parseInt(req.query.offset) || 0;
    const limit = parseInt(req.query.limit) || 100;

    const query = `
      SELECT 
          u.city AS user_city,
          u.country AS user_country,
          SUM(d.quantity) AS total_quantity,
          COUNT(DISTINCT d.order_key) AS total_orders
      FROM denormFactOrders d
      JOIN dimUsers u ON d.user_key = u.user_key
      GROUP BY u.city, u.country
      LIMIT ? OFFSET ?;
    `;

    db.query(query, [limit, offset], (err, results) => {
      if (err) return res.status(500).send("Database error (user-location-rollup)");
      res.json({ data: results, row_count: results.length });
    });
  });

  // === 3. User Country Aggregate Rollup ===
  router.get("/user-country-rollup", (req, res) => {
    const query = `
      SELECT 
          country,
          SUM(total_quantity) AS total_quantity,
          SUM(total_orders) AS total_orders
      FROM (
          SELECT 
              u.country,
              SUM(d.quantity) AS total_quantity,
              COUNT(d.order_key) AS total_orders
          FROM denormFactOrders d
          JOIN dimUsers u ON d.user_key = u.user_key
          GROUP BY u.user_key, u.country
      ) AS user_agg
      GROUP BY country;
    `;

    db.query(query, (err, results) => {
      if (err) return res.status(500).send("Database error (user-country-rollup)");
      res.json({ data: results, row_count: results.length });
    });
  });

  

  return router;
}
