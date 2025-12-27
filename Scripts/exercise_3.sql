DROP PROCEDURE IF EXISTS sql_invoicing.get_invoices_by_client;

CREATE PROCEDURE sql_invoicing.get_invoices_by_client(client VARCHAR(50))
BEGIN
	SELECT *
	FROM sql_invoicing.invoices i
	JOIN sql_invoicing.clients c USING (client_id)
	WHERE c.name = client;
END;

CALL sql_invoicing.get_invoices_by_client("Vinte");
