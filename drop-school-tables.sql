-- Author     : Arturo Pardo
-- Professor  : Krofchok
-- Description: This script drops the sequences and tables for the school database

BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE users_id_seq';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE college_id_seq';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE degree';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE lecture';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE course';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE forms';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE users';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE college';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE affiliation';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE program';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE department';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
END;