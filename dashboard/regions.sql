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
       'Regional Market Performance' AS title;

-- 3. VISUAL 1: Regional Revenue vs. Profit Comparison (Horizontal Bar Chart)
SELECT 'chart' AS component,
       'Revenue vs. Profit by Region' AS title,
       'bar' AS type,                  -- Clear bar chart presentation
       TRUE AS horizontal,             -- Flips horizontally so long region names read cleanly
       'Region' AS xtitle,
       'Amount ($)' AS ytitle;

-- Series A: Revenue per Region
SELECT 
    'Revenue' AS series,
    region AS x,
    ROUND(SUM(sales), 2) AS y
FROM sales
GROUP BY region;

-- Series B: Profit per Region
SELECT 
    'Profit' AS series,
    region AS x,
    ROUND(SUM(profit), 2) AS y
FROM sales
GROUP BY region;


-- 4. VISUAL 2: Regional Sales Market Contribution (Pie Chart)
SELECT 'chart' AS component,
       'Market Share % (Revenue Contribution)' AS title,
       'pie' AS type;                  -- Best layout for showing percentage slices of a whole 100%

WITH total AS (
    SELECT SUM(sales) AS total_sales FROM sales
)
SELECT
    region AS x,
    ROUND(SUM(sales) * 100.0 / MAX(total_sales), 2) AS y
FROM sales
CROSS JOIN total
GROUP BY region;


-- 5. DEEP DIVE SUMMARY: Complete Regional Performance Ledger
SELECT 'table' AS component,
       'Regional Financial Metrics Overview' AS title,
       TRUE AS search,                 -- Interactive keyword filters
       TRUE AS sort;                   -- Clickable column sorting headers

SELECT
    region AS "Region Name",
    '$' || TO_CHAR(ROUND(SUM(sales), 2), '999,999,999.99') AS "Total Revenue",
    '$' || TO_CHAR(ROUND(SUM(profit), 2), '999,999,999.99') AS "Net Profit",
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) || '%' AS "Profit Margin %"
FROM sales
GROUP BY region
ORDER BY SUM(sales) DESC;
