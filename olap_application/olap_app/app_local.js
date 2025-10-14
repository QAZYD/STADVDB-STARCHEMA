require('dotenv').config();
const express = require("express");
const mysql = require("mysql2");
const path = require("path");

const app = express();
const port = 3000;

// Serve static files
app.use(express.static(path.join(__dirname, "public")));

// Database connection
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
});

db.connect((err) => {
  if (err) {
    console.error("Database connection failed:", err);
    return;
  }
  console.log("Connected to MySQL Data Warehouse!");
});

// Homepage
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

// Top categories report, Roll up operation
app.get("/report/top-categories", (req, res) => { 
  const query = `
    SELECT
        dp.category AS product_category,
        SUM(dfo.quantity) AS total_quantity_ordered
    FROM data_warehouse.denormfactorders dfo
    JOIN data_warehouse.dimProducts dp
        ON dfo.product_key = dp.product_key
    GROUP BY dp.category
    ORDER BY total_quantity_ordered DESC;
  `;

  db.query(query, (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.json(results);
  });
});

// Top products by category report (paginated/staggered), Drill Down
app.get("/report/top-products", (req, res) => {
  const limit = parseInt(req.query.limit) || 50;  // load 50 rows at a time
  const offset = parseInt(req.query.offset) || 0;

  const query = `
    SELECT dp.category, dp.name, SUM(dfo.quantity) AS total_quantity
    FROM data_warehouse.denormfactorders dfo
    JOIN data_warehouse.dimProducts dp
      ON dfo.product_key = dp.product_key
    GROUP BY dp.category, dp.name
    ORDER BY dp.category, total_quantity DESC
    LIMIT ? OFFSET ?;
  `;

  const start = Date.now();
  db.query(query, [limit, offset], (err, results) => {
    const end = Date.now();
    if (err) return res.status(500).send("Database error");

    res.json({
      duration_ms: end - start,
      row_count: results.length,
      offset,
      limit,
      data: results,
    });
  });
});

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
