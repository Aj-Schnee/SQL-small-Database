-- Author     : Arturo Pardo
-- Professor  : Krofchok
-- Description: Exercise 2. Write a script that uses variables to get (1) the count of all 
--              of the invoices in the Invoices table that have a balance due 
--              and (2) the sum of the balance due for all of those invoices. 
--              If that total balance due is greater than or equal to $50,000, 
--              the script should display a message like this:
--              Number of unpaid invoices is 40.
--              Total balance due is $66,796.24.
--              Otherwise, the script should display this message:
--              Total balance due is less than $50,000.

DECLARE
    total_invoices_unpaid NUMBER;
    total_balance_due NUMBER;
BEGIN
    SELECT COUNT(*), SUM(invoice_total - credit_total)
    INTO total_invoices_unpaid, total_balance_due
    FROM invoices
    WHERE payment_total = 0;


    IF (total_balance_due >= 50000) THEN
        dbms_output.put_line('Number of unpaid invoices is ' || total_invoices_unpaid );
        dbms_output.put_line('Total balance due is $' || TO_CHAR(total_balance_due, '999,999.99') );
    ELSE
        dbms_output.put_line('Total balance due is less than $50,000.');
    END IF;
END; 
/ 