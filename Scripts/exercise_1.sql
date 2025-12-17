USE sql_store;

SELECT name, unit_price, unit_price * 1.1 AS new_price
FROM products;

SELECT *
FROM orders
WHERE order_date > "2019-01-01";

SELECT *
FROM order_items
WHERE order_id = 6 
	AND (quantity * unit_price > 30);
    
SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

SELECT *
FROM customers
WHERE address LIKE '%TRAIL%' OR address LIKE '%AVENUE%';

SELECT *
FROM customers
WHERE phone LIKE '%9';

SELECT *
FROM order_items
WHERE order_id = 2
ORDER BY quantity * unit_price DESC;

SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;


SELECT o.product_id, name, quantity, o.unit_price
FROM order_items o
JOIN products p ON o.product_id = p.product_id;

USE sql_invoicing;

SELECT c.name AS client_name, p.amount, pm.name AS payment_method
FROM payments p
JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
JOIN clients c ON p.client_id = c.client_id;

USE sql_store;
SELECT customer_id, first_name, points, "BRONZE" AS type
FROM customers
WHERE points < 2000
UNION
SELECT customer_id, first_name, points, "SILVER" AS type
FROM customers
WHERE points >= 2000 AND points < 3000
UNION
SELECT customer_id, first_name, points, "GOLD" AS type
FROM customers
WHERE points >= 3000
ORDER BY first_name;

INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('apple',3,3.22), 
('banana',4,4.22), 
('orange',5,5.22);


USE sql_invoicing;
CREATE TABLE invoices_archive AS
SELECT i.invoice_id, c.name AS client, i.invoice_total
FROM invoices i
JOIN clients c USING (client_id)
WHERE payment_date IS NOT NULL;

SELECT SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payments, SUM(invoice_total) - SUM(payment_total) AS what_to_expect, 'First-half' AS data_range
FROM invoices
WHERE invoice_date <= "2019-06-30"
UNION
SELECT SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payments, SUM(invoice_total) - SUM(payment_total) AS what_to_expect, 'Second-half' AS data_range
FROM invoices
WHERE invoice_date > "2019-06-30"
UNION
SELECT SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payments, SUM(invoice_total) - SUM(payment_total) AS what_to_expect, 'Whole-year' AS data_range
FROM invoices;

SELECT date, name AS payment_method, SUM(amount) AS amount
FROM payments p
JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY date, pm.name
ORDER BY date;

USE sql_store;

SELECT o.customer_id, SUM(quantity * unit_price) AS total
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE state = "VA"
GROUP BY customer_id
HAVING total > 100;






