-- Author     : Arturo Pardo
-- Professor  : Krofchok
-- Description: You have been hired to design and implement a database-driven solution 
--              written in Oracle PL/SQL that can compute an employee's weekly gross pay, 
--              taxes, and net pay.

-- Drop Sequence and tables for Babbage's Cabbage's
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE bc_employees_id_seq';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE bc_payroll';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE bc_employees';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
END;
/

-- Create Tables for Babbage's Cabbage's

-- Employee table Schema
CREATE TABLE bc_employees 
(
    employee_id             INTEGER             NOT NULL,
    last_name               VARCHAR2(50)        NOT NULL,
    first_name              VARCHAR2(50)        NOT NULL,
    hours                   NUMBER(4,2)         NOT NULL    CHECK (hours >= 0 AND hours <= 99.99),
    hourly_rate             NUMBER(4,2)         NOT NULL    CHECK (hourly_rate >= 0 AND hourly_rate <= 99.99),
    transport_code          VARCHAR2(1)         NOT NULL    CHECK (transport_code IN ('P','T','L','N')),
    CONSTRAINT employee_id_pk    PRIMARY KEY (employee_id)
);

-- Create Sequence for bc_employees table
CREATE SEQUENCE bc_employees_id_seq
    START WITH 1
    INCREMENT BY 1;

-- Payroll table Schema
CREATE TABLE bc_payroll
(
    employee_id             INTEGER             NOT NULL,
    reg_hours               NUMBER(4,2)         NOT NULL    CHECK (reg_hours >= 0 AND reg_hours <= 99.99),
    ovt_hours               NUMBER(4,2)         NOT NULL    CHECK (ovt_hours >= 0 AND ovt_hours <= 99.99),
    gross_pay               NUMBER(6,2)         NOT NULL    CHECK (gross_pay >= 0 AND gross_pay <= 9999.99),
    taxes                   NUMBER(5,2)         NOT NULL    CHECK (taxes >= 0 AND taxes <= 999.99),
    transport_fee           NUMBER(4,2)         NOT NULL    CHECK (transport_fee >= 0 AND transport_fee <= 99.99),
    net_pay                 NUMBER(6,2)         NOT NULL    CHECK (net_pay >= 0 AND net_pay <= 9999.99),
    CONSTRAINT bc_payroll_employee_id_pk    PRIMARY KEY (employee_id),
    CONSTRAINT bc_payroll_employee_id_fk    FOREIGN KEY (employee_id) REFERENCES bc_employees(employee_id)
);

-- Create INSERT INTO statements for bc_employees table
INSERT INTO bc_employees (employee_id, last_name, first_name, hours, hourly_rate, transport_code)
VALUES (bc_employees_id_seq.nextval, 'Horsecollar','Horace', 38.00, 12.50, 'P');
INSERT INTO bc_employees (employee_id, last_name, first_name, hours, hourly_rate, transport_code)
VALUES (bc_employees_id_seq.nextval, 'Reins','Rachel', 46.50, 14.40, 'T');
INSERT INTO bc_employees (employee_id, last_name, first_name, hours, hourly_rate, transport_code)
VALUES (bc_employees_id_seq.nextval, 'Saddle','Samuel', 51.00, 40.00, 'N');

-- Declare variables
DECLARE
    employee_id             INTEGER;              
    last_name               VARCHAR2(50);        
    first_name              VARCHAR2(50);       
    hours                   NUMBER(4,2);         
    hourly_rate             NUMBER(4,2);         
    transport_code          VARCHAR2(1);
    reg_hours               NUMBER(4,2);
    ovt_hours               NUMBER(4,2);
    gross_pay               NUMBER(7,2);
    taxes                   NUMBER(7,2);
    transport_fee           NUMBER(4,2);
    net_pay                 NUMBER(7,2);

-- Declare cursor
CURSOR employees_cursor IS
    SELECT employee_id, last_name, first_name, hours, hourly_rate, transport_code
    FROM bc_employees;

BEGIN
    -- Loop
    FOR employee_record IN employees_cursor LOOP
        employee_id := employee_record.employee_id;
        last_name := employee_record.last_name;
        first_name := employee_record.first_name;
        hours := employee_record.hours;
        hourly_rate := employee_record.hourly_rate;
        transport_code := employee_record.transport_code;

        IF (hours <= 40) THEN
            reg_hours := hours;
            ovt_hours := 0;
        ELSE
            reg_hours := 40;
            ovt_hours := hours - 40;
        END IF;
        
        -- gross_pay = (regular_hours × hourly_rate) + (overtime_hours × 1.5 × hourly_rate)
        gross_pay := (reg_hours * hourly_rate) + (ovt_hours * 1.5 * hourly_rate);

        -- taxes = 28% × gross_pay
        taxes := 0.28 * gross_pay;

        -- P: $7.50 / T: $5.00 / L: $1.00 / N: No deduction 
        CASE transport_code
            WHEN 'P' THEN
                transport_fee := 7.50;
            WHEN 'T' THEN
                transport_fee := 5.00;
            WHEN 'L' THEN
                transport_fee := 1.00;
            WHEN 'N' THEN
                transport_fee := 0.00;
        END CASE;

        -- net_pay = gross_pay − taxes − transport_fee
        net_pay := gross_pay - taxes - transport_fee;
        
        --For testing purposes
        -- dbms_output.put_line('Employee ID: ' || employee_id);
        -- dbms_output.put_line('Employee Full Name: ' || last_name || ', ' || first_name);
        -- dbms_output.put_line('Regular Hours: ' || reg_hours);
        -- dbms_output.put_line('Overtime Hours: ' || ovt_hours);
        -- dbms_output.put_line('Gross Pay: ' || gross_pay);
        -- dbms_output.put_line('Taxes: ' || taxes);
        -- dbms_output.put_line('Transport Fee: ' || transport_fee);
        -- dbms_output.put_line('Net Pay: ' || net_pay);
        -- dbms_output.put_line('----------------------------------------');

        -- Data Validation
        IF (reg_hours < 0 OR reg_hours > 99.99) THEN
            dbms_output.put_line('Something Went Wrong during the calculation of a employees Regular Hours');
        ELSIF (ovt_hours < 0 OR ovt_hours > 99.99) THEN
            dbms_output.put_line('Something Went Wrong during the calculation of a employees Overtime Hours');
        ELSIF (gross_pay < 0 OR gross_pay > 9999.99) THEN
            dbms_output.put_line('Something Went Wrong during the calculation of a employees Gross Pay');
        ELSIF (taxes < 0 OR taxes > 999.99) THEN
            dbms_output.put_line('Something Went Wrong during the calculation of a employees Taxes');
        ELSIF (transport_fee < 0 OR transport_fee > 99.99) THEN
            dbms_output.put_line('Something Went Wrong during the calculation of a employees Transport Fee');
        ELSIF (net_pay < 0 OR net_pay > 9999.99) THEN
            dbms_output.put_line('Something Went Wrong during the calculation of a employees Net Pay');
        ELSE   
            --Insert into bc_payroll table
            INSERT INTO bc_payroll (employee_id, reg_hours, ovt_hours, gross_pay, taxes, transport_fee, net_pay)
            VALUES (employee_id, reg_hours, ovt_hours, gross_pay, taxes, transport_fee, net_pay);   
        END IF;
    END LOOP;
END;