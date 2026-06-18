SELECT COUNT(*) total_rows, COUNT(customer_id), COUNT(product_id), COUNT(sales) FROM sales;

SELECT order_id, COUNT(*) FROM sales GROUP BY order_id HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM sales WHERE profit < 0;

SELECT * FROM sales WHERE customer_name IS NULL;

SELECT * FROM sales WHERE ship_date < order_date;

SELECT * FROM sales WHERE sales <= 0;

SELECT COUNT(DISTINCT customer_id) FROM sales;

SELECT COUNT(DISTINCT product_id) FROM sales;

SELECT COUNT(DISTINCT region) FROM sales;