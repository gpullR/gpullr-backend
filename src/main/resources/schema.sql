CREATE USER IF NOT EXISTS "" PASSWORD '' ADMIN;
CREATE CACHED TABLE IF NOT EXISTS PUBLIC.PULLREQUEST(
    ID INTEGER NOT NULL CHECK (ID >= 1),
    CREATEDAT VARCHAR(255),
    FILESCHANGED INTEGER,
    LINESADDED INTEGER,
    LINESREMOVED INTEGER,
    NUMBER INTEGER,
    STATE VARCHAR(255) NOT NULL,
    TITLE VARCHAR(255),
    URL VARCHAR(255),
    ASSIGNEE_ID INTEGER,
    AUTHOR_ID INTEGER NOT NULL,
    REPO_ID INTEGER NOT NULL
);           
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_E PRIMARY KEY(ID);             
-- 69 +/- SELECT COUNT(*) FROM PUBLIC.PULLREQUEST;             
CREATE CACHED TABLE IF NOT EXISTS PUBLIC.REPO(
    ID INTEGER NOT NULL CHECK (ID >= 1),
    DESCRIPTION VARCHAR(1000),
    NAME VARCHAR(255) NOT NULL
);     
ALTER TABLE PUBLIC.REPO ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_2 PRIMARY KEY(ID);    
-- 66 +/- SELECT COUNT(*) FROM PUBLIC.REPO;    
CREATE CACHED TABLE IF NOT EXISTS PUBLIC.USER(
    ID INTEGER NOT NULL,
    AVATARURL VARCHAR(255),
    CANLOGIN BOOLEAN,
    USERNAME VARCHAR(255) NOT NULL
);              
ALTER TABLE PUBLIC.USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_27 PRIMARY KEY(ID);   
-- 19 +/- SELECT COUNT(*) FROM PUBLIC.USER;    
ALTER TABLE PUBLIC.REPO ADD CONSTRAINT IF NOT EXISTS PUBLIC.UK_QEDS8S1RPG0DD2O7O4HQJ5T9P UNIQUE(NAME);       
ALTER TABLE PUBLIC.USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.UK_JREODF78A7PL5QIDFH43AXDFB UNIQUE(USERNAME);   
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_BX0S0OC7KKG0QI43E4MO2FTCI FOREIGN KEY(AUTHOR_ID) REFERENCES PUBLIC.USER(ID) NOCHECK;   
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_AQ6TYEWWQ4E4S1U03XW06Q2XC FOREIGN KEY(REPO_ID) REFERENCES PUBLIC.REPO(ID) NOCHECK;     
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_MWCA9DCM3DP9MXMNDVY7Y5287 FOREIGN KEY(ASSIGNEE_ID) REFERENCES PUBLIC.USER(ID) NOCHECK; 