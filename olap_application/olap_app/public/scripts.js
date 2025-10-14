
fetch("/report/top-categories")
  .then(response => response.json())
  .then(data => {
    const tbody = document.querySelector("#top-categories-table tbody");
    tbody.innerHTML = ""; 

    data.forEach(row => {
      const tr = document.createElement("tr");
      const categoryTd = document.createElement("td");
      const quantityTd = document.createElement("td");

      categoryTd.textContent = row.category;
      quantityTd.textContent = row.total_quantity;

      tr.appendChild(categoryTd);
      tr.appendChild(quantityTd);
      tbody.appendChild(tr);
    });
  })
  .catch(err => {
    console.error("Error fetching data:", err);
  });
