SELECT ROUND(SUM(sales),2) AS total_revenue FROM sales;

SELECT ROUND(SUM(profit),2) AS total_profit FROM sales;

SELECT COUNT(DISTINCT order_id) AS total_orders FROM sales;

SELECT ROUND(SUM(sales) / COUNT(DISTINCT order_id) ,2) AS average_order_value FROM sales;

SELECT COUNT(DISTINCT customer_id) AS total_customers FROM sales;

SELECT COUNT(DISTINCT product_id) AS total_products FROM sales;

SELECT category, ROUND(SUM(sales),2) AS revenue FROM sales GROUP BY category ORDER BY revenue DESC; 

SELECT category, ROUND(SUM(profit),2) AS profit FROM sales GROUP BY category ORDER BY profit DESC;

SELECT segment, ROUND(SUM(sales),2) AS revenue FROM sales GROUP BY segment ORDER BY revenue DESC;

SELECT segment, ROUND(SUM(profit),2) AS profit FROM sales GROUP BY segment ORDER BY profit DESC;

SELECT region, ROUND(SUM(sales),2) AS revenue FROM sales GROUP BY region ORDER BY revenue DESC;

SELECT region, ROUND(SUM(profit),2) AS profit FROM sales GROUP BY region ORDER BY profit DESC;

SELECT DATE_TRUNC('month',order_date) AS month, ROUND(SUM(sales), 2) revenue FROM sales GROUP BY month ORDER BY month;

-- Percentage Based Analytics

WITH total AS(SELECT SUM(sales) total_sales FROM sales) SELECT category, ROUND(SUM(sales),2) revenue, ROUND(SUM(sales)*100.0/MAX(total_sales), 2) revenue_share_pct FROM sales CROSS JOIN total GROUP BY category ORDER BY revenue DESC;

WITH total AS(SELECT SUM(sales) total_sales FROM sales) SELECT segment, ROUND(SUM(sales),2) revenue, ROUND(SUM(sales)*100.0/MAX(total_sales), 2) revenue_share_pct FROM sales CROSS JOIN total GROUP BY segment ORDER BY revenue DESC;

WITH total AS(SELECT SUM(sales) total_sales FROM sales) SELECT region, ROUND(SUM(sales),2) revenue, ROUND(SUM(sales)*100.0/MAX(total_sales),2) revenue_share_pct FROM sales CROSS JOIN total GROUP BY region ORDER BY revenue DESC;

WITH total AS (SELECT SUM(profit) total_profit FROM sales) SELECT category, ROUND(SUM(profit),2) profit, ROUND(SUM(profit)*100.0/MAX(total_profit),2) profit_share_pct FROM sales CROSS JOIN total GROUP BY category ORDER BY profit DESC;

WITH total AS (SELECT SUM(profit) total_profit FROM sales) SELECT segment, ROUND(SUM(profit),2) profit, ROUND(SUM(profit)*100.0/MAX(total_profit),2) profit_share_pct FROM sales CROSS JOIN total GROUP BY segment ORDER BY profit DESC;

WITH total AS (SELECT SUM(profit) total_profit FROM sales) SELECT region, ROUND(SUM(profit),2) profit, ROUND(SUM(profit)*100.0/MAX(total_profit),2) profit_share_pct FROM sales CROSS JOIN total GROUP BY region ORDER BY profit DESC;

SELECT customer_name, ROUND(SUM(sales), 2) revenue, ROUND(SUM(sales)*100.0/SUM(SUM(sales)) OVER(),2) revenue_pct FROM sales GROUP BY customer_name ORDER BY revenue DESC;

WITH customer_sales AS (SELECT customer_name, SUM(sales) revenue  FROM sales GROUP BY customer_name), top20 AS (SELECT * FROM customer_sales ORDER BY revenue DESC LIMIT 20) SELECT ROUND(SUM(revenue)*100.0/(SELECT SUM(sales) FROM sales),2) contribution_pct FROM top20;

WITH product_sales AS (SELECT product_name, SUM(sales) revenue FROM sales GROUP BY product_name) SELECT product_name, revenue, ROUND(revenue*100.0/SUM(revenue) OVER(),2) revenue_pct FROM product_sales ORDER BY revenue DESC;

SELECT category, ROUND(SUM(sales)*100.0/ SUM(SUM(sales)) OVER(), 2) contribution_pct FROM sales GROUP BY category;

WITH monthly_sales AS (SELECT DATE_TRUNC('month',order_date) AS month, SUM (sales) revenue FROM sales GROUP BY month) SELECT month, revenue, ROUND((revenue - LAG(revenue) OVER(ORDER BY month))*100.0/ LAG(revenue) OVER(ORDER BY month),2) growth_pct FROM monthly_sales;

WITH monthly_profit AS (SELECT DATE_TRUNC('month',order_date) AS month, SUM (profit) profit FROM sales GROUP BY month) SELECT month, profit, ROUND((profit - LAG(profit) OVER(ORDER BY month))*100.0/ LAG(profit) OVER(ORDER BY month),2) growth_pct FROM monthly_profit;

SELECT ROUND(SUM(profit)*100.0/ SUM(sales), 2) profit_margin_pct FROM sales;

SELECT region, ROUND(SUM(profit)*100.0/ SUM(sales), 2) profit_margin_pct FROM sales GROUP BY region ORDER BY profit_margin_pct DESC;

SELECT category, ROUND(SUM(profit)*100.0/ SUM(sales), 2) profit_margin_pct FROM sales GROUP BY category ORDER BY profit_margin_pct DESC;

SELECT segment, ROUND(SUM(profit)*100.0/ SUM(sales), 2) profit_margin_pct FROM sales GROUP BY segment ORDER BY profit_margin_pct DESC;

