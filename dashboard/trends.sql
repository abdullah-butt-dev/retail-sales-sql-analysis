-- 1. Sidebar/Top Navigation Shell Component
SELECT 'shell' AS component,
       'Retail Manager' AS title,
       'building-store' AS icon,
       'blue' AS color,
       JSON('[
           {"title": "Dashboard",  "link": "index.sql",      "icon": "layout-dashboard"},
           {"title": "Trends",     "link": "trends.sql",     "icon": "trending-up"},
           {"title": "Categories", "link": "categories.sql", "icon": "category"},
           {"title": "Customers",  "link": "customers.sql",  "icon": "users"},
           {"title": "Products",   "link": "products.sql",   "icon": "package"},
           {"title": "Regions",    "link": "regions.sql",    "icon": "map-pin"}
       ]') AS menu_item;

-- 2. Page Header Title
SELECT 'title' AS component,
       'Sales & Profit Trend Analysis' AS title;

-- 3. VISUAL 1: Monthly Revenue Timeline (Line Chart)
SELECT 'chart' AS component,
       'Monthly Revenue Performance' AS title,
       'line' AS type,                  -- Smooth continuous line chart
       'blue' AS color,
       'Month' AS xtitle,
       'Revenue ($)' AS ytitle;

SELECT
    TO_CHAR(DATE_TRUNC('month', order_date), 'YYYY-MM') AS x, -- Formats x-axis nicely (e.g. 2026-03)
    ROUND(SUM(sales), 2) AS y
FROM sales
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);


-- 4. VISUAL 2: Comparison Chart for Sales vs. Profit Growth Percentages
SELECT 'chart' AS component,
       'Month-over-Month Growth Comparison (%)' AS title,
       'bar' AS type,                   -- Bar layout highlights volatile growth jumps clearly
       'Month' AS xtitle,
       'Growth Percentage (%)' AS ytitle;

-- Series A: Revenue Growth
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS revenue FROM sales GROUP BY month
)
SELECT 
    'Revenue Growth %' AS series,
    TO_CHAR(month, 'YYYY-MM') AS x,
    ROUND((revenue - LAG(revenue) OVER(ORDER BY month)) * 100.0 / LAG(revenue) OVER(ORDER BY month), 2) AS y
FROM monthly_sales;

-- Series B: Profit Growth
WITH monthly_profit AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(profit) AS profit FROM sales GROUP BY month
)
SELECT 
    'Profit Growth %' AS series,
    TO_CHAR(month, 'YYYY-MM') AS x,
    ROUND((profit - LAG(profit) OVER(ORDER BY month)) * 100.0 / LAG(profit) OVER(ORDER BY month), 2) AS y
FROM monthly_profit;


-- 5. DEEP DIVE SUMMARY: Below-Average Underperforming Months
SELECT 'table' AS component,
       'Underperforming Months (Revenue Below Global Average)' AS title,
       TRUE AS search,                  -- Adds a search bar over the table grid
       TRUE AS sort;                    -- Adds column click sorting features

WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS revenue FROM sales GROUP BY month
),
avg_sales AS (
    SELECT AVG(revenue) AS avg_revenue FROM monthly_sales
)
SELECT
    TO_CHAR(month, 'YYYY-MM-DD') AS "Month Bucket",
    '$' || TO_CHAR(revenue, '999,999.99') AS "Actual Revenue"
FROM monthly_sales
CROSS JOIN avg_sales
WHERE revenue < avg_revenue
ORDER BY revenue;
