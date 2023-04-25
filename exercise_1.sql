-- Author     : Arturo Pardo
-- Professor  : Krofchok
-- Description: Exercise 1. Write a script that declares and sets a variable that’s equal to the count of all rows 
--              in the Invoices table that have a balance due that’s greater than or equal to $5,000. 
--              Then the script should display a message that looks like this:
--              3 invoices Exceed $5,000.

DECLARE
    total_invoices_over_5000 NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO total_invoices_over_5000
    FROM invoices
    WHERE payment_total = 0 AND invoice_total >= 5000;

   dbms_output.put_line( total_invoices_over_5000 || ' invoices Exceed $5,000.' ); 
END; 
/ 