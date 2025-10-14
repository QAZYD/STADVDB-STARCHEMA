const express = require("express");
const mysql = require("mysql2");
const path = require("path");

const app = express();
const port = 3000;

app.use(express.static(path.join(__dirname, "public")));

// Local database connection
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

// Top products by category (paginated)
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

  db.query(query, [limit, offset], (err, results) => {
    if (err) return res.status(500).send("Database error");

    res.json({
      row_count: results.length,
      offset,
      limit,
      data: results,
    });
  });
});

// Dim Products (paginated)
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

// Slice products by category (paginated)
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

// Dice products (modular filters)
app.get("/report/dice-products", (req, res) => {
  const { category, priceMin, priceMax, createdFrom, createdTo, nameSearch } = req.query;
  const limit = parseInt(req.query.limit) || 50;
  const offset = parseInt(req.query.offset) || 0;

  let filters = [];
  let values = [];

  if (category) { filters.push("category = ?"); values.push(category); }
  if (priceMin) { filters.push("price >= ?"); values.push(priceMin); }
  if (priceMax) { filters.push("price <= ?"); values.push(priceMax); }
  if (createdFrom) { filters.push("DATE(created_at) >= ?"); values.push(createdFrom); }
  if (createdTo) { filters.push("DATE(created_at) <= ?"); values.push(createdTo); }
  if (nameSearch) { filters.push("name LIKE ?"); values.push(`%${nameSearch}%`); }

  let whereClause = filters.length ? `WHERE ${filters.join(" AND ")}` : "";

  const query = `
    SELECT *
    FROM dimProducts
    ${whereClause}
    ORDER BY created_at DESC
    LIMIT ? OFFSET ?;
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
//dim_users

//dim_riders


//fact_denorm_orders

// Fact Orders report (paginated)
app.get("/report/fact-orders", (req, res) => {
  const limit = parseInt(req.query.limit) || 50;  // default 50 rows per page
  const offset = parseInt(req.query.offset) || 0;

  const query = `
    SELECT 
      fo.order_key,
      fo.source_order_id,
      fo.user_key,
      fo.rider_key,
      fo.product_key,
      fo.order_number,
      fo.quantity,
      fo.notes,
      fo.order_created_at,
      fo.order_updated_at,
      fo.item_created_at,
      fo.item_updated_at
    FROM denormFactOrders fo
    ORDER BY fo.order_created_at DESC
    LIMIT ? OFFSET ?;
  `;

  db.query(query, [limit, offset], (err, results) => {
    if (err) return res.status(500).send("Database error");

    res.json({
      row_count: results.length,
      offset,
      limit,
      data: results
    });
  });
});


// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
