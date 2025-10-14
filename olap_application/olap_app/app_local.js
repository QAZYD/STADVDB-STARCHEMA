const express = require("express");
const mysql = require("mysql2");
const path = require("path");

const app = express();
const port = 3000;

// Serve static files
app.use(express.static(path.join(__dirname, "public")));

// Database connection
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "waxdQSCrfv135$!",
  database: "data_warehouse",
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

// Top categories report
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

// Top products by category report
app.get("/report/top-products", (req, res) => {
  const query = `
    SELECT dp.category, dp.name, SUM(dfo.quantity) AS total_quantity
    FROM data_warehouse.denormfactorders dfo
    JOIN data_warehouse.dimProducts dp
        ON dfo.product_key = dp.product_key
    GROUP BY dp.category, dp.name
    ORDER BY dp.category, total_quantity DESC
    LIMIT 10000000;
  `;

  db.query(query, (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.json(results);
  });
});

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
