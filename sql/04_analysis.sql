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
