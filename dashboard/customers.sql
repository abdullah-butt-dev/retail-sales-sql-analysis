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
       'Customer Demographics & Value Insights' AS title;


-- 3. VISUAL 1: Customer Value Tiers Summary (SQLPage big_number / Card Component)
-- Converts your tier summary query into actionable, direct executive cards
SELECT 'big_number' AS component,
       'Customer Segmentation Profiles' AS title;

WITH tier_data AS (
    SELECT
        customer_name,
        SUM(sales) AS revenue,
        CASE
            WHEN SUM(sales) > 10000 THEN 'VIP'
            WHEN SUM(sales) > 5000 THEN 'Premium'
            ELSE 'Standard'
        END AS customer_tier
    FROM sales
    GROUP BY customer_name
)
SELECT 
    customer_tier AS title,
    COUNT(*)::TEXT || ' Buyers' AS value,
    '$' || TO_CHAR(SUM(revenue), '999,999,999.99') AS description,
    CASE 
        WHEN customer_tier = 'VIP' THEN 'purple'
        WHEN customer_tier = 'Premium' THEN 'blue'
        ELSE 'orange'
    END AS color
FROM tier_data
GROUP BY customer_tier
ORDER BY SUM(revenue) DESC;


-- 4. VISUAL 2: Corporate vs. Home Office Market Share (Pie Chart)
SELECT 'chart' AS component,
       'Market Segment Contribution (% Revenue Share)' AS title,
       'pie' AS type;

WITH total AS (
    SELECT SUM(sales) AS total_sales FROM sales
)
SELECT
    segment AS x,
    ROUND(SUM(sales) * 100.0 / MAX(total_sales), 2) AS y
FROM sales
CROSS JOIN total
GROUP BY segment;


-- 5. VISUAL 3: Top 10 Spending Customers (Horizontal Bar Chart)
SELECT 'chart' AS component,
       'Top 10 Highest-Value Customers' AS title,
       'bar' AS type,
       TRUE AS horizontal,             -- Flips names horizontally so they do not overlap
       'teal' AS color,
       'Customer Name' AS xtitle,
       'Lifetime Revenue ($)' AS ytitle;

SELECT
    customer_name AS x,
    ROUND(SUM(sales), 2) AS y
FROM sales
GROUP BY customer_name
ORDER BY SUM(sales) DESC
LIMIT 10;


-- 6. DEEP DIVE SUMMARY: Complete Market Segment Ledger
SELECT 'table' AS component,
       'Customer Segment Financial Metrics Overview' AS title,
       TRUE AS search,
       TRUE AS sort;

SELECT
    segment AS "Customer Segment",
    '$' || TO_CHAR(ROUND(SUM(sales), 2), '999,999,999.99') AS "Total Revenue",
    '$' || TO_CHAR(ROUND(SUM(profit), 2), '999,999,999.99') AS "Net Profit",
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) || '%' AS "Profit Margin %"
FROM sales
GROUP BY segment
ORDER BY SUM(sales) DESC;
