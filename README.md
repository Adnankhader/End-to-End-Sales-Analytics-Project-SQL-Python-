# End-to-End Sales Analytics Project (SQL + Python)

##  Project Overview

This project demonstrates a complete **end-to-end analytics workflow**, starting from raw transactional data and ending with business-ready visualizations. The focus is on **clean data modeling, SQL-based analytics, and Python-based visualization**, following real-world analytics engineering best practices.

The project is designed to show how **Python and SQL complement each other**:

* **Python** is used for data ingestion, cleaning, and visualization
* **SQL Server** is used for data modeling and analytical computations

---

##  Architecture Overview

```
Raw Data (CSV / API)
        ↓
Python (Pandas)
- Data cleaning
- Feature engineering
        ↓
SQL Server (Bronze Layer)
- Raw transactional storage
        ↓
SQL Server (Gold Layer)
- Dimension views (with surrogate keys)
- Fact view (star schema)
        ↓
SQL Analytics (Views / Queries)
        ↓
Python (Jupyter)
- Data retrieval
- Visualization
```

---

##  Data Modeling (Gold Layer)

The project follows a **Star Schema** design.

###  Fact Table

**`gold.fact_sales`**

* Central fact view representing sales transactions
* Stores only:

  * Surrogate keys to dimensions
  * Numeric measures (revenue, profit, quantity, etc.)

**Key Measures:**

* quantity
* selling_price
* discount_amount
* total_revenue
* total_profit

---

###  Dimension Tables

Each dimension is created as a **SQL view** with surrogate keys generated using `row_number()`.

* **`gold.dim_date`** – Time analysis (year, month, day)
* **`gold.dim_products`** – Product attributes (category, sub-category, pricing)
* **`gold.dim_location`** – Geographic attributes (country, region, state, city)
* **`gold.dim_ship_mode`** – Shipping method
* **`gold.dim_segment`** – Customer segment

Surrogate keys ensure:

* Clean joins
* No duplicated descriptive attributes in the fact table
* Analytics-ready structure

---

##  Analytics Performed in SQL

All core analytics are performed in SQL using the gold-layer fact and dimensions.

Examples include:

* Total revenue and profit
* Monthly revenue trends
* Revenue and profit by category
* Regional performance analysis
* Shipping mode performance
* Customer segment contribution
* Average Order Value (AOV)
* Running (cumulative) revenue using window functions

Reusable analytics are stored as **SQL views**, while exploratory queries are run ad hoc.

---

##  Visualizations (Python)

Visualization is done in **Jupyter Notebook** using:

* pandas
* matplotlib
* seaborn

### Visualization Principles Used

* SQL handles aggregation and business logic
* Python only consumes final result sets
* Time-series plots use proper datetime axes
* KPI metrics are formatted for readability (no scientific notation)

### Example Visuals

* Monthly revenue trend (line chart)
* Revenue by product category (bar chart)
* Profit by region (bar chart)
* KPI summary cards (total revenue, profit, AOV, etc.)

---



---


