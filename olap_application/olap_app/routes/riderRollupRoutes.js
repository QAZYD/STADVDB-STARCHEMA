import express from "express";

export default function riderRollupRoutes(db) {
  const router = express.Router();

  // --- Rider Aggregate Rollup ---
  router.get("/rider-rollup", (req, res) => {
    const query = `
      SELECT 
          r.rider_key,
          CONCAT_WS(' ', r.first_name, r.last_name) AS rider_name,
          SUM(d.quantity) AS total_quantity,
          COUNT(DISTINCT d.order_key) AS total_deliveries
      FROM denormFactOrders d
      JOIN dimRiders r ON d.rider_key = r.rider_key
      GROUP BY r.rider_key, r.first_name, r.last_name
      ORDER BY total_deliveries DESC
    `;

    db.query(query, (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ row_count: results.length, data: results });
    });
  });

  // --- Vehicle Type Rollup ---
  router.get("/vehicle-rollup", (req, res) => {
    const query = `
      SELECT 
          r.vehicle_type,
          SUM(d.quantity) AS total_quantity,
          COUNT(DISTINCT d.order_key) AS total_deliveries
      FROM denormFactOrders d
      JOIN dimRiders r ON d.rider_key = r.rider_key
      GROUP BY r.vehicle_type
      ORDER BY total_quantity DESC
    `;

    db.query(query, (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ row_count: results.length, data: results });
    });
  });

  return router;
}
