-- Use an anonymous PL/SQL script to drop any existing BC tables and sequences
-- in the current schema and suppress any error messages that may displayed if
-- these objects don't exist

BEGIN
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

    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE bc_employee_id_seq';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE bc_transport_codes';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
END;
/

CREATE TABLE bc_transport_codes (
    code         CHAR(1)       PRIMARY KEY,
    description  VARCHAR2(30)  NOT NULL UNIQUE,
    amount       NUMBER(5,2)   NOT NULL CHECK (amount >= 0)
);

CREATE SEQUENCE bc_employee_id_seq
    START WITH 1;

CREATE TABLE bc_employees (
    employee_id     NUMBER        DEFAULT bc_employee_id_seq.NEXTVAL PRIMARY KEY,
    last_name       VARCHAR2(30)  NOT NULL,
    first_name      VARCHAR2(30)  NOT NULL,
    hours           NUMBER(4,2)   NOT NULL CHECK (hours >= 0),
    hourly_rate     NUMBER(4,2)   NOT NULL CHECK (hourly_rate >= 0),
    transport_code  VARCHAR(1)
);

CREATE TABLE bc_payroll (
    employee_id   NUMBER        NOT NULL REFERENCES bc_employees(employee_id),
    reg_hours     NUMBER(4,2)   NOT NULL CHECK (reg_hours >= 0),
    ovt_hours     NUMBER(4,2)   NOT NULL CHECK (ovt_hours >= 0),
    gross_pay     NUMBER(6,2)   NOT NULL CHECK (gross_pay >= 0),
    taxes         NUMBER(5,2)   NOT NULL CHECK (taxes >= 0),
    transport_fee NUMBER(4,2)   CHECK (transport_fee >= 0),
    net_pay       NUMBER(6,2)
);

INSERT INTO bc_transport_codes VALUES ('P', 'Parking Garage', 7.50);
INSERT INTO bc_transport_codes VALUES ('T', 'Transit Pass'  , 5.00);
INSERT INTO bc_transport_codes VALUES ('L', 'Bike Locker'   , 1.00);

INSERT INTO bc_employees (
    last_name, first_name, hours, hourly_rate, transport_code
) VALUES (
    'Horsecollar', 'Horace', 38.00, 12.50, 'P'
);

INSERT INTO bc_employees (
    last_name, first_name, hours, hourly_rate, transport_code
) VALUES (
    'Reins', 'Rachel', 46.50, 14.40, 'T'
);

INSERT INTO bc_employees (
    last_name, first_name, hours, hourly_rate, transport_code
) VALUES (
    'Saddle', 'Samuel', 51.00, 40.00, NULL
);
