require('dotenv').config();
const express = require("express");
const mysql = require("mysql2");
const path = require("path");

const app = express();
const port = 3000;

app.use(express.static(path.join(__dirname, "public")));

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
    if (err) return res.status(500).send("Database error");
    res.json(results);
  });
});


app.get("/report/top-products", (req, res) => {
  const limit = parseInt(req.query.limit) || 50;  
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


app.get("/report/dim-products", (req, res) => {
  const limit = parseInt(req.query.limit) || 100;  
  const offset = parseInt(req.query.offset) || 0;

  const query = `SELECT * FROM dimProducts LIMIT ? OFFSET ?`;

  db.query(query, [limit, offset], (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.json({
      offset,
      limit,
      row_count: results.length,
      data: results,
    });
  });
});



app.get("/report/slice-products", (req, res) => {
  const category = req.query.category;
  const limit = parseInt(req.query.limit) || 50;
  const offset = parseInt(req.query.offset) || 0;

  if (!category) return res.status(400).send("Category is required");

  const query = `
    SELECT dp.category, dp.name, SUM(dfo.quantity) AS total_quantity
    FROM denormfactorders dfo
    JOIN dimProducts dp ON dfo.product_key = dp.product_key
    WHERE dp.category = ?
    GROUP BY dp.category, dp.name
    ORDER BY total_quantity DESC
    LIMIT ? OFFSET ?;
  `;

  db.query(query, [category, limit, offset], (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.json({
      row_count: results.length,
      offset,
      limit,
      data: results,
    });
  });
});



app.get("/report/dice-products", (req, res) => {
  const { category, priceMin, priceMax, createdFrom, createdTo, nameSearch } = req.query;
  const limit = parseInt(req.query.limit) || 50;
  const offset = parseInt(req.query.offset) || 0;

  let filters = [];
  let values = [];

  if (category) {
    filters.push("category = ?");
    values.push(category);
  }
  if (priceMin) {
    filters.push("price >= ?");
    values.push(priceMin);
  }
  if (priceMax) {
    filters.push("price <= ?");
    values.push(priceMax);
  }
  if (createdFrom) {
    filters.push("DATE(created_at) >= ?");
    values.push(createdFrom);
  }
  if (createdTo) {
    filters.push("DATE(created_at) <= ?");
    values.push(createdTo);
  }
  if (nameSearch) {
    filters.push("name LIKE ?");
    values.push(`%${nameSearch}%`);
  }

  let whereClause = filters.length ? `WHERE ${filters.join(" AND ")}` : "";

  const query = `
    SELECT * 
    FROM dimProducts
    ${whereClause}
    ORDER BY created_at DESC
    LIMIT ? OFFSET ?
  `;
  values.push(limit, offset);

  db.query(query, values, (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.json({
      row_count: results.length,
      offset,
      limit,
      data: results
    });
  });
});




app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
