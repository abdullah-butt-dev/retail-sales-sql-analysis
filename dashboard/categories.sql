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
       'Category Performance Insights' AS title;


-- 3. VISUAL 1: Category Financial Comparison (Grouped Bar Chart)
SELECT 'chart' AS component,
       'Revenue vs. Net Profit by Product Category' AS title,
       'bar' AS type,                  -- Grouped bars highlight performance gaps
       'Category' AS xtitle,
       'Amount ($)' AS ytitle;

-- Series A: Revenue
SELECT 
    'Total Revenue' AS series,
    category AS x,
    ROUND(SUM(sales), 2) AS y
FROM sales
GROUP BY category;

-- Series B: Profit
SELECT 
    'Net Profit' AS series,
    category AS x,
    ROUND(SUM(profit), 2) AS y
FROM sales
GROUP BY category;


-- 4. VISUAL 2: Category Market Share (Donut Chart)
SELECT 'chart' AS component,
       'Inventory Share % (Revenue Contribution)' AS title,
       'donut' AS type;                -- Clean, modern ring layout for contribution share

WITH total AS (
    SELECT SUM(sales) AS total_sales FROM sales
)
SELECT
    category AS x,
    ROUND(SUM(sales) * 100.0 / MAX(total_sales), 2) AS y
FROM sales
CROSS JOIN total
GROUP BY category;


-- 5. DEEP DIVE SUMMARY: Complete Inventory Financial Ledger
SELECT 'table' AS component,
       'Category Financial Performance Ledger' AS title,
       TRUE AS search,                 -- Interactive search bar
       TRUE AS sort;                   -- Clickable sort headers

SELECT
    category AS "Product Category",
    '$' || TO_CHAR(ROUND(SUM(sales), 2), '999,999,999.99') AS "Total Revenue",
    '$' || TO_CHAR(ROUND(SUM(profit), 2), '999,999,999.99') AS "Net Profit",
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) || '%' AS "Profit Margin %"
FROM sales
GROUP BY category
ORDER BY SUM(sales) DESC;
