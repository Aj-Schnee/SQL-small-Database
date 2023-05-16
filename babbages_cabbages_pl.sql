-- Author     : Arturo Pardo
-- Professor  : Krofchok
-- Description: Create a new version of the Babbage's Cabbage's program from Assignment #8 
--              using the modular structures offered by PL/SQL: procedures, functions, and packages.

-- Declare package bc_pardo 
CREATE OR REPLACE PACKAGE bc_pardo AS
  PROCEDURE split_hours(in_hours IN NUMBER, out_reg_hours OUT NUMBER, out_ovt_hours OUT NUMBER);
  FUNCTION compute_gross_pay(in_hours IN NUMBER, in_hourly_rate IN NUMBER) RETURN NUMBER;
  FUNCTION compute_taxes(in_gross_pay IN NUMBER) RETURN NUMBER;
  FUNCTION get_transport_amount(in_code IN CHAR) RETURN NUMBER;
  FUNCTION compute_net_pay(in_gross_pay IN NUMBER, in_taxes IN NUMBER, in_transport_code IN CHAR) RETURN NUMBER;
  PROCEDURE process_payroll;
END bc_pardo;
/

-- Declare package body bc_pardo
CREATE OR REPLACE PACKAGE BODY bc_pardo AS

-- Declare Split hours into regular and overtime hours
  PROCEDURE split_hours(in_hours IN NUMBER, out_reg_hours OUT NUMBER, out_ovt_hours OUT NUMBER) AS
  BEGIN
    IF in_hours <= 40 THEN
      out_reg_hours := in_hours;
      out_ovt_hours := 0;
    ELSE
      out_reg_hours := 40;
      out_ovt_hours := in_hours - 40;
    END IF;
  END split_hours;

-- Declare compute gross pay
  FUNCTION compute_gross_pay(in_hours IN NUMBER, in_hourly_rate IN NUMBER) RETURN NUMBER AS
    reg_hours NUMBER;
    ovt_hours NUMBER;
  BEGIN
    split_hours(in_hours, reg_hours, ovt_hours);
    RETURN (reg_hours * in_hourly_rate) + (ovt_hours * 1.5 * in_hourly_rate);
  END compute_gross_pay;

-- Declare compute taxes
  FUNCTION compute_taxes(in_gross_pay IN NUMBER) RETURN NUMBER AS
  BEGIN
    RETURN 0.28 * in_gross_pay;
  END compute_taxes;

-- Declare get transport amount
  FUNCTION get_transport_amount(in_code IN CHAR) RETURN NUMBER AS
    transport_fee NUMBER;
  BEGIN
    CASE in_code
      WHEN 'P' THEN
        transport_fee := 7.50;
      WHEN 'T' THEN
        transport_fee := 5.00;
      WHEN 'L' THEN
        transport_fee := 1.00;
      WHEN 'N' THEN
        transport_fee := 0.00;
      ELSE
        RAISE_APPLICATION_ERROR(-20007, 'Transportation code not found');
    END CASE;
    RETURN transport_fee;
  END get_transport_amount;

-- Declare compute net pay
  FUNCTION compute_net_pay(in_gross_pay IN NUMBER, in_taxes IN NUMBER, in_transport_code IN CHAR) RETURN NUMBER AS
    transport_fee NUMBER;
  BEGIN
    transport_fee := get_transport_amount(in_transport_code);
    RETURN in_gross_pay - in_taxes - transport_fee;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END compute_net_pay;

-- Declare process payroll
    PROCEDURE process_payroll IS
        CURSOR employees_cursor IS
            SELECT employee_id, last_name, first_name, hours, hourly_rate, transport_code
            FROM bc_employees;
        employee_record employees_cursor%ROWTYPE;
        reg_hours NUMBER;
        ovt_hours NUMBER;
        gross_pay NUMBER;
        taxes NUMBER;
        transport_fee NUMBER;
        net_pay NUMBER;
    BEGIN
        DELETE FROM bc_payroll;

        FOR employee IN employees_cursor LOOP
            reg_hours := employee.hours;
            ovt_hours := 0;

            IF reg_hours > 40 THEN
                reg_hours := 40;
                ovt_hours := reg_hours - 40;
            END IF;

            gross_pay := reg_hours * employee.hourly_rate + ovt_hours * 1.5 * employee.hourly_rate;
            taxes := 0.28 * gross_pay;
            transport_fee := get_transport_amount(employee.transport_code);
            net_pay := gross_pay - taxes - transport_fee;

            INSERT INTO bc_payroll (employee_id, reg_hours, ovt_hours, gross_pay, taxes, transport_fee, net_pay)
            VALUES (employee.employee_id, reg_hours, ovt_hours, gross_pay, taxes, transport_fee, net_pay);
        END LOOP;
    END process_payroll;
END bc_pardo;