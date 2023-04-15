-- Author     : Arturo Pardo
-- Professor  : Krofchok
-- Description: This script drops and creates the tables for the school database

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
/

-- Create Tables for School Database
CREATE TABLE department 
(
    department_id           NUMBER              NOT NULL,
    department_name         VARCHAR2(50)        NOT NULL,
    course_id               NUMBER              NOT NULL,
    CONSTRAINT department_id_pk    PRIMARY KEY (department_id),
    CONSTRAINT department_name_uq  UNIQUE (department_name)
);

CREATE TABLE program
(
    program_id          NUMBER              NOT NULL,
    program_name        VARCHAR2(50)        NOT NULL,
    program_degree      VARCHAR2(50)        NOT NULL,
    CONSTRAINT program_id_pk        PRIMARY KEY (program_id),
    CONSTRAINT program_name_uq      UNIQUE (program_name)
);

CREATE TABLE affiliation
(
    affiliation_id              NUMBER              NOT NULL,
    affiliation_title           VARCHAR2(50)        NOT NULL,
    affiliation_description     VARCHAR2(255)       NOT NULL,
    CONSTRAINT affiliation_id_pk     PRIMARY KEY (affiliation_id)
);

CREATE TABLE college
(
    college_id          NUMBER              NOT NULL,
    college_name        VARCHAR2(50)        NOT NULL,
    college_address     VARCHAR2(50)        NOT NULL,
    program_id          NUMBER              NOT NULL,
    department_id       NUMBER              NOT NULL,
    CONSTRAINT college_id_pk        PRIMARY KEY (college_id),
    CONSTRAINT college_program_id_fk         FOREIGN KEY (program_id)    REFERENCES program (program_id),
    CONSTRAINT college_department_id_pk     FOREIGN KEY (department_id) REFERENCES department (department_id)
);

CREATE TABLE users
(
    user_id                 NUMBER              NOT NULL,
    user_password           VARCHAR2(50)        NOT NULL,
    user_name               VARCHAR2(50)        NOT NULL,
    user_last_name          VARCHAR2(50)        NOT NULL,
    user_birthday           DATE                NOT NULL,
    affiliation_id          NUMBER              NOT NULL,
    user_phone              VARCHAR2(50),
    user_email              VARCHAR2(255)       NOT NULL,
    user_emergency_contact  VARCHAR2(50),
    user_gender             VARCHAR2(50)        NOT NULL,
    user_highest_education  VARCHAR2(50),
    college_id              NUMBER              NOT NULL,
    user_goals              VARCHAR2(50),
    user_balance            NUMBER(9,2)                     DEFAULT 0 CHECK (user_balance >= 0),
    CONSTRAINT user_id_pk           PRIMARY KEY (user_id),
    CONSTRAINT affiliation_id_fk    FOREIGN KEY (affiliation_id) REFERENCES affiliation (affiliation_id),
    CONSTRAINT college_id_fk        FOREIGN KEY (college_id)     REFERENCES college (college_id),
    CONSTRAINT user_email_uq        UNIQUE (user_email)
);

CREATE TABLE forms
(
    form_id             NUMBER              NOT NULL,
    user_id             NUMBER              NOT NULL,
    form_status         VARCHAR2(50)        NOT NULL,
    form_date_issued    DATE                NOT NULL,
    form_resolved       DATE,           
    form_type           VARCHAR2(50)        NOT NULL,
    form_payment        NUMBER(9,2)                     DEFAULT 0 CHECK (form_payment >= 0),
    form_description    VARCHAR2(255),    
    CONSTRAINT forms_pk         PRIMARY KEY (form_id),
    CONSTRAINT user_id_fk       FOREIGN KEY (user_id)    REFERENCES users (user_id)
);

CREATE TABLE course
(
    course_id           NUMBER              NOT NULL,
    acronym             VARCHAR2(50)        NOT NULL,
    course_name         VARCHAR2(50)        NOT NULL,
    course_units        NUMBER                          DEFAULT 0,
    user_id             NUMBER              NOT NULL,
    course_pre_req      VARCHAR2(50)        NOT NULL,
    CONSTRAINT course_id_pk         PRIMARY KEY (course_id),
    CONSTRAINT course_user_id_fk           FOREIGN KEY (user_id)  REFERENCES users (user_id),
    CONSTRAINT acronym_uq           UNIQUE (acronym)
);

CREATE TABLE lecture
(
    lecture_id                   NUMBER             NOT NULL,
    course_id                    NUMBER             NOT NULL,
    lecture_starting_date        DATE               NOT NULL,
    lecture_ending_date          DATE               NOT NULL,
    lecture_room                 VARCHAR2(50)       NOT NULL,
    lecture_mode                 VARCHAR2(50)       NOT NULL,
    CONSTRAINT lecture_id_pk        PRIMARY KEY (lecture_id),
    CONSTRAINT lecture_course_id_fk         FOREIGN KEY (course_id)   REFERENCES course (course_id)
);

CREATE TABLE degree
(
    degree_id               NUMBER              NOT NULL,
    degree_title            VARCHAR2(50)        NOT NULL,
    program_id              NUMBER              NOT NULL,
    degree_requirements     VARCHAR2(255)       NOT NULL,
    course_id               NUMBER              NOT NULL,
    CONSTRAINT degree_id_pk         PRIMARY KEY (degree_id),
    CONSTRAINT program_id_fk        FOREIGN KEY (program_id)   REFERENCES program (program_id),
    CONSTRAINT course_id_fk         FOREIGN KEY (course_id)    REFERENCES course (course_id),
    CONSTRAINT degree_title_uq      UNIQUE (degree_title)
);

-- Create the sequences
CREATE SEQUENCE users_id_seq
  START WITH 1006;
CREATE SEQUENCE college_id_seq
  START WITH 10044;

-- Create INSERT INTO statements for department table
INSERT INTO department (department_id,department_name,course_id)
VALUES (1,'Computer Science',11111);
INSERT INTO department (department_id,department_name,course_id)
VALUES (2,'Mathematics',22222);
INSERT INTO department (department_id,department_name,course_id)
VALUES (3,'Biology',33333);

-- Create INSERT INTO statements for program table
INSERT INTO program (program_id,program_name,program_degree)
VALUES (12111,'Computer Science','Bachelor');
INSERT INTO program (program_id,program_name,program_degree)
VALUES (12122,'Mathematics','Bachelor');
INSERT INTO program (program_id,program_name,program_degree)
VALUES (12133,'Biology','Bachelor');

-- Create INSERT INTO statements for affiliation table
INSERT INTO affiliation (affiliation_id,affiliation_title,affiliation_description)
VALUES (1111111,'Student','student');
INSERT INTO affiliation (affiliation_id,affiliation_title,affiliation_description)
VALUES (2222222,'Professor','Professor of Biology');
INSERT INTO affiliation (affiliation_id,affiliation_title,affiliation_description)
VALUES (3333333,'Counselor','Course Counselor');

-- Create INSERT INTO statements for college table
INSERT INTO college (college_id,college_name,college_address,program_id,department_id)
VALUES (10011,'Sacramento City College','3835 Freeport Blvd, Sacramento, CA 95822',12111,1);
INSERT INTO college (college_id,college_name,college_address,program_id,department_id)
VALUES (10022,'University of California, Davis','1 Shields Ave, Davis, CA 95616',12122,2);
INSERT INTO college (college_id,college_name,college_address,program_id,department_id)
VALUES (10033,'University of California, Berkeley','Berkeley, CA 94720',12133,3);

-- Create INSERT INTO statements for users table
INSERT INTO users (user_id,user_password,user_name,user_last_name,user_birthday,affiliation_id,user_phone,user_email,user_emergency_contact,user_gender,user_highest_education,college_id,user_goals,user_balance)
VALUES (1001,'pass1001','Arturo','Pardo',TO_DATE('1989-10-30','YYYY-MM-DD'),1111111,'(916) 807-5169','PardoJArturo@gmail.com',NULL,'male','High School',10011,'Graduate',DEFAULT);
INSERT INTO users (user_id,user_password,user_name,user_last_name,user_birthday,affiliation_id,user_phone,user_email,user_emergency_contact,user_gender,user_highest_education,college_id,user_goals,user_balance)
VALUES (1002,'pass1002','Jose','Rivas',TO_DATE('1993-01-15','YYYY-MM-DD'),1111111,'(916) 555-5555','JoseRivas@gmail.com',NULL,'male','High School',10011,'Transfer',1000.76);
INSERT INTO users (user_id,user_password,user_name,user_last_name,user_birthday,affiliation_id,user_phone,user_email,user_emergency_contact,user_gender,user_highest_education,college_id,user_goals,user_balance)
VALUES (1003,'pass1003','Kevin','Allen',TO_DATE('1995-10-10','YYYY-MM-DD'),1111111,'(916) 636-5333','KevinAllen123@gmail.com','(916) 807-5169','male','High School',10011,'Transfer',124.15);
INSERT INTO users (user_id,user_password,user_name,user_last_name,user_birthday,affiliation_id,user_phone,user_email,user_emergency_contact,user_gender,user_highest_education,college_id,user_goals,user_balance)
VALUES (1004,'pass1004','Carlos','Martinez',TO_DATE('2000-12-24','YYYY-MM-DD'),3333333,'(916) 807-3131','CarlosM1331@gmail.com','(916) 871-3333','male','Bachelor',10011,'None',DEFAULT);
INSERT INTO users (user_id,user_password,user_name,user_last_name,user_birthday,affiliation_id,user_phone,user_email,user_emergency_contact,user_gender,user_highest_education,college_id,user_goals,user_balance)
VALUES (1005,'pass1005','Karla','Chavez',TO_DATE('1999-05-15','YYYY-MM-DD'),2222222,'(916) 252-3956','HappyKarla@gmail.com',NULL,'female','Bachelor',10022,'None',DEFAULT);
INSERT INTO users (user_id,user_password,user_name,user_last_name,user_birthday,affiliation_id,user_phone,user_email,user_emergency_contact,user_gender,user_highest_education,college_id,user_goals,user_balance)
VALUES (1006,'pass1005','Ashley','Berkley',TO_DATE('2001-08-10','YYYY-MM-DD'),1111111,'(916) 111-1244','AshleyB@gmail.com',NULL,'female','Bachelor',10022,'None',DEFAULT);

-- Create INSERT INTO statements for forms table
INSERT INTO forms (form_id,user_id,form_status,form_date_issued,form_resolved,form_type,form_payment,form_description)
VALUES (0001,1002,'Pending',TO_DATE('2019-10-30','YYYY-MM-DD'),NULL,'Financial Aid',178.05,'I need financial aid');
INSERT INTO forms (form_id,user_id,form_status,form_date_issued,form_resolved,form_type,form_payment,form_description)
VALUES (0002,1006,'Pending',TO_DATE('2019-10-30','YYYY-MM-DD'),NULL,'Financial Aid',46.70,'I need financial aid');
INSERT INTO forms (form_id,user_id,form_status,form_date_issued,form_resolved,form_type,form_payment,form_description)
VALUES (0003,1001,'Resolved',TO_DATE('2019-10-30','YYYY-MM-DD'),TO_DATE('2019-10-30','YYYY-MM-DD'),'Tuitions',DEFAULT,'N/A');
INSERT INTO forms (form_id,user_id,form_status,form_date_issued,form_resolved,form_type,form_payment,form_description)
VALUES (0004,1002,'Cancel',TO_DATE('2019-10-30','YYYY-MM-DD'),NULL,'Exceed Unit',DEFAULT,'None');

-- Create INSERT INTO statements for course table
INSERT INTO course (course_id,acronym,course_name,course_units,user_id,course_pre_req)
VALUES (11111,'CSC','Computer Science',4,1001,'None');
INSERT INTO course (course_id,acronym,course_name,course_units,user_id,course_pre_req)
VALUES (22222,'MATH','Mathematics',3,1002,'None');
INSERT INTO course (course_id,acronym,course_name,course_units,user_id,course_pre_req)
VALUES (33333,'BIO','Biology',4,1005,'None');

-- Create INSERT INTO statements for lecture table
INSERT INTO lecture (lecture_id,course_id,lecture_starting_date,lecture_ending_date,lecture_room,lecture_mode)
VALUES (1111,11111,TO_DATE('2019-10-30','YYYY-MM-DD'),TO_DATE('2019-12-30','YYYY-MM-DD'),'Room 1','Online');
INSERT INTO lecture (lecture_id,course_id,lecture_starting_date,lecture_ending_date,lecture_room,lecture_mode)
VALUES (2222,22222,TO_DATE('2019-10-30','YYYY-MM-DD'),TO_DATE('2019-12-30','YYYY-MM-DD'),'Room 2','Online');
INSERT INTO lecture (lecture_id,course_id,lecture_starting_date,lecture_ending_date,lecture_room,lecture_mode)
VALUES (3333,33333,TO_DATE('2019-10-30','YYYY-MM-DD'),TO_DATE('2019-12-30','YYYY-MM-DD'),'Room 3','Online');

-- Create INSERT INTO statements for degree table
INSERT INTO degree (degree_id,degree_title,program_id,degree_requirements,course_id)
VALUES (111111,'Computer Science',12111,'Bachelor',11111);
INSERT INTO degree (degree_id,degree_title,program_id,degree_requirements,course_id)
VALUES (222222,'Mathematics',12122,'Bachelor',22222);
INSERT INTO degree (degree_id,degree_title,program_id,degree_requirements,course_id)
VALUES (333333,'Biology',12133,'Bachelor',33333);