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
       'Product Performance Insights' AS title;


-- 3. VISUAL 1: Top 10 Best Selling Products (Horizontal Bar Chart)
SELECT 'chart' AS component,
       'Top 10 Products by Revenue' AS title,
       'bar' AS type,
       TRUE AS horizontal,             -- Flips sideways so long product names stay readable
       'Product Name' AS xtitle,
       'Revenue ($)' AS ytitle;

WITH product_sales AS (
    SELECT product_name, SUM(sales) AS revenue FROM sales GROUP BY product_name
)
SELECT 
    product_name AS x,
    ROUND(revenue, 2) AS y
FROM product_sales
ORDER BY revenue DESC
LIMIT 10;


-- 4. VISUAL 2: Bottom 10 Least Profitable Products (Bar Chart)
SELECT 'chart' AS component,
       'Bottom 10 Products by Net Profit (Includes Losses)' AS title,
       'bar' AS type,
       'red' AS color,                 -- Keeps it color-coded to flag danger zones
       'Product Name' AS xtitle,
       'Net Profit ($)' AS ytitle;

SELECT
    product_name AS x,
    ROUND(profit, 2) AS y
FROM (
    SELECT
        product_name,
        SUM(profit) AS profit,
        DENSE_RANK() OVER(ORDER BY SUM(profit) ASC) AS ranking
    FROM sales
    GROUP BY product_name
) AS ranking_products
WHERE ranking <= 10
ORDER BY profit ASC;           -- Displays worst items first


-- 5. CRITICAL ACTION LIST: Products Running a Loss
-- Swapping a standard table for a high-priority financial alert center layout
SELECT 'card' AS component,
       '🚨 Financial Loss Alert: Products Bleeding Money' AS title,
       4 AS columns;

SELECT 
    product_name AS title,
    'Total Loss: $' || TO_CHAR(ROUND(SUM(profit), 2), '999,999.99') AS description,
    'red' AS color,
    'alert-triangle' AS icon
FROM sales
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY SUM(profit) ASC;     -- Puts the biggest financial drain at the absolute top
