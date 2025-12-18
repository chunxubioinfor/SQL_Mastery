SELECT
	CONCAT(c.first_name,' ',c.last_name) AS name,
	CASE 
		WHEN c.points > 3000 THEN "GOLD"
		WHEN c.points BETWEEN 2000 AND 3000 THEN "SILVER"
		ELSE "BRONZE"
	END AS category
FROM sql_store.customers c;


CREATE VIEW sql_invoicing.client_balances AS
SELECT 
	c.client_id,
	c.name,
	(sum(i.payment_total) - SUM(i.invoice_total )) AS balance
FROM sql_invoicing.clients c
JOIN sql_invoicing.invoices i USING (client_id)
GROUP BY client_id;

SELECT *
FROM sql_invoicing.client_balances;


CREATE PROCEDURE sql_invoicing.get_invoices_with_balance()
BEGIN
	SELECT
		i.invoice_id,
		(i.invoice_total - i.payment_total) AS balance
	FROM sql_invoicing.invoices i
	WHERE (i.invoice_total - i.payment_total) > 0;
END;


call sql_invoicing.get_invoices_with_balance();
