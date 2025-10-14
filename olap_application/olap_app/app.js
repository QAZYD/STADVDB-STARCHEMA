require('dotenv').config();
const express = require("express");
const mysql = require("mysql2");
const path = require("path");

const app = express();
const port = 3000;

// Serve static files (like index.html)
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


app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});


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
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).send("Database error");
      return;
    }
    res.json(results);
  });
});






app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
