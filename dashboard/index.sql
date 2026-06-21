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
       'Executive Command Center' AS title;

-- 3. LIVE BUSINESS METRICS OVERVIEW (Dynamic KPI Grid)
SELECT 'card' AS component,
       'Key Performance Indicators' AS title,
       3 AS columns;

-- Card 1: Total Revenue (Live Query)
SELECT 
    'Total Revenue' AS title,
    '$' || TO_CHAR(SUM(sales), '999,999,999.00') AS description,
    'blue' AS color,
    'currency-dollar' AS icon,
    'trends.sql' AS link
FROM sales;

-- Card 2: Total Profit (Live Query)
SELECT 
    'Total Profit' AS title,
    '$' || TO_CHAR(SUM(profit), '999,999,999.00') AS description,
    'green' AS color,
    'trending-up' AS icon
FROM sales;

-- Card 3: Orders (Live Query)
SELECT 
    'Orders' AS title,
    TO_CHAR(COUNT(DISTINCT order_id), '9,999') AS description,
    'purple' AS color,
    'shopping-cart' AS icon
FROM sales;

-- Card 4: Customers (Live Query)
SELECT 
    'Customers' AS title,
    TO_CHAR(COUNT(DISTINCT customer_id), '9,999') AS description,
    'orange' AS color,
    'users' AS icon,
    'customers.sql' AS link
FROM sales;

-- Card 5: Average Order Value (Live Query)
SELECT 
    'Average Order Value' AS title,
    '$' || TO_CHAR(ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2), '999,999.00') AS description,
    'teal' AS color,
    'receipt' AS icon
FROM sales;

-- Card 6: Profit Margin (Live Query)
SELECT 
    'Profit Margin' AS title,
    TO_CHAR(ROUND(SUM(profit) * 100.0 / SUM(sales), 2), '99.99') || '%' AS description,
    'indigo' AS color,
    'percentage' AS icon
FROM sales;


-- 4. NEW SECTION: Executive App Quick Links
SELECT 'list' AS component,
       'Quick Navigation Shortcuts' AS title;

SELECT 'Timeline & Volatility' AS title, 'View sales tracking and performance spikes over time.' AS description, 'trending-up' AS icon, 'trends.sql' AS link;
SELECT 'Inventory & Categories' AS title, 'Analyze product groupings and sector profit contributions.' AS description, 'category' AS icon, 'categories.sql' AS link;
SELECT 'Customer Demographics' AS title, 'Identify value tiers, VIP counts, and audience segments.' AS description, 'users' AS icon, 'customers.sql' AS link;


-- 5. NEW SECTION: Recent High-Value Orders Table
SELECT 'table' AS component,
       'Recent High-Value Orders (Flagged for Review)' AS title,
       TRUE AS search;

SELECT
    TO_CHAR(order_date, 'YYYY-MM-DD') AS "Order Date",
    order_id AS "Order ID",
    customer_name AS "Customer Name",
    product_name AS "Product Purchased",
    '$' || TO_CHAR(sales, '999,999.99') AS "Sales Amount",
    '$' || TO_CHAR(profit, '999,999.99') AS "Net Profit"
FROM sales
ORDER BY order_date DESC, sales DESC
LIMIT 5; -- Keeps the landing page fast and clean by showing just the top 5
