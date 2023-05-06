-- Author     : Arturo Pardo
-- Professor  : Krofchok
-- Description: Module 15 Exercise 1 & 2

CREATE OR REPLACE PROCEDURE insert_glaccount (
    account_number_param        IN      NUMBER,
    account_description_param   IN      VARCHAR2
)
AS
BEGIN
    INSERT INTO General_Ledger_Accounts (account_number, account_description)
    VALUES (account_number_param, account_description_param);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('A DUP_VAL_ON_INDEX error occurred.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unknown exception occurred.');
END;
/

BEGIN
    insert_glaccount(705,'Professional Learning Community');
END;
/