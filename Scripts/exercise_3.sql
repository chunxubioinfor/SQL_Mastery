DROP PROCEDURE IF EXISTS sql_invoicing.get_invoices_by_client;

CREATE PROCEDURE sql_invoicing.get_invoices_by_client(client VARCHAR(50))
BEGIN
	SELECT *
	FROM sql_invoicing.invoices i
	JOIN sql_invoicing.clients c USING (client_id)
	WHERE c.name = client;
END;

CALL sql_invoicing.get_invoices_by_client("Vinte");


DROP PROCEDURE IF EXISTS sql_invoicing.get_paymemts;

CREATE PROCEDURE sql_invoicing.get_paymemts(
	p_client_id INT, 
	p_payment_method_id TINYINT)
BEGIN
	SELECT *
	FROM sql_invoicing.payments p
	WHERE p.client_id = IFNULL(p_client_id,p.client_id) AND p.payment_method = IFNULL(p_payment_method_id,p.payment_method);
END;

CALL sql_invoicing.get_paymemts(1,1);
CALL sql_invoicing.get_paymemts(NULL,NULL);

CREATE PROCEDURE sql_invoicing.get_risk_factor ()
BEGIN
    DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9,2);
    DECLARE invoices_count INT;

    SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM sql_invoicing.invoices;

    IF invoices_count > 0 THEN
        SET risk_factor = invoices_total / invoices_count * 5;
    ELSE
        SET risk_factor = 0;
    END IF;

    SELECT risk_factor;
END;

CALL sql_invoicing.get_risk_factor();

CREATE FUNCTION sql_invoicing.get_risk_factor()
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9,2);
    DECLARE invoices_count INT;

    SELECT 
        COUNT(*), 
        SUM(invoice_total)
    INTO 
        invoices_count, 
        invoices_total
    FROM sql_invoicing.invoices;

    IF invoices_count > 0 THEN
        SET risk_factor = invoices_total / invoices_count * 5;
    ELSE
        SET risk_factor = 0;
    END IF;

    RETURN risk_factor;
END;

SELECT DISTINCT 
    client_id,
    sql_invoicing.get_risk_factor() AS risk_factor
FROM sql_invoicing.invoices;





