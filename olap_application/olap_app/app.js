const express = require("express");
const mysql = require("mysql2");
const path = require("path"); 
const app = express();
const port = 3000; 


app.use(express.static(path.join(__dirname, "public")));


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

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});


app.get("/report/top-categories", (req, res) => {
  const query = `
    SELECT dp.category, SUM(fo.quantity) AS total_quantity
    FROM denormfactorders fo
    JOIN dimproducts dp ON fo.product_key = dp.product_key
    GROUP BY dp.category
    ORDER BY total_quantity DESC
    LIMIT 5;
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
