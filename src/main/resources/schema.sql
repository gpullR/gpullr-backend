CREATE USER IF NOT EXISTS "" PASSWORD '' ADMIN;

-- DELETE SEQUENCE IF EXISTS PUBLIC.SYSTEM_SEQUENCE_A5458BDB_906E_4DD7_91FA_53B11E88BEA2;
-- DELETE SEQUENCE IF EXISTS PUBLIC.SYSTEM_SEQUENCE_681B61DE_14D7_43F0_9F8F_1946172AE1BF;
-- DELETE SEQUENCE IF EXISTS PUBLIC.SYSTEM_SEQUENCE_F3397C68_6C71_486F_8E7E_73785F83E058;

CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_12E4548E_F545_42AC_8E0C_08822E6FD9CF START WITH 1 BELONGS_TO_TABLE;    
CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_79A3ABCD_AC32_4B61_9731_9EA75EE3D359 START WITH 1 BELONGS_TO_TABLE;
CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_F3397C68_6C71_486F_8E7E_73785F83E058 START WITH 1 BELONGS_TO_TABLE;

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
ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS ASSIGNEDAT VARCHAR(255);
ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS CLOSEDAT VARCHAR(255);
ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS BRANCHNAME VARCHAR(255);

ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS BUILD_STATE VARCHAR(30);
ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS BUILD_TIMESTAMP VARCHAR(100);

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.RANKING(
    ID BIGINT DEFAULT (NEXT VALUE FOR PUBLIC.SYSTEM_SEQUENCE_12E4548E_F545_42AC_8E0C_08822E6FD9CF) NOT NULL NULL_TO_DEFAULT SEQUENCE PUBLIC.SYSTEM_SEQUENCE_12E4548E_F545_42AC_8E0C_08822E6FD9CF,
    CLOSEDCOUNT BIGINT NOT NULL,
    RANK INTEGER
);     

ALTER TABLE PUBLIC.RANKING ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_6 PRIMARY KEY(ID);

-- 69 +/- SELECT COUNT(*) FROM PUBLIC.PULLREQUEST;             
CREATE CACHED TABLE IF NOT EXISTS PUBLIC.REPO(
    ID INTEGER NOT NULL CHECK (ID >= 1),
    DESCRIPTION VARCHAR(1000),
    NAME VARCHAR(255) NOT NULL
);
ALTER TABLE PUBLIC.REPO ADD COLUMN IF NOT EXISTS ACTIVE BOOLEAN NOT NULL DEFAULT TRUE; 
ALTER TABLE PUBLIC.REPO ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_2 PRIMARY KEY(ID);
-- 66 +/- SELECT COUNT(*) FROM PUBLIC.REPO;    
CREATE CACHED TABLE IF NOT EXISTS PUBLIC.USER(
    ID INTEGER NOT NULL,
    AVATARURL VARCHAR(255),
    CANLOGIN BOOLEAN,
    USERNAME VARCHAR(255) NOT NULL,
    USER_SETTINGS_ID INTEGER
);
ALTER TABLE PUBLIC.USER ADD COLUMN IF NOT EXISTS USER_SETTINGS_ID INTEGER;
ALTER TABLE PUBLIC.USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_27 PRIMARY KEY(ID);
ALTER TABLE PUBLIC.USER ADD COLUMN IF NOT EXISTS FULLNAME VARCHAR(255);
ALTER TABLE PUBLIC.USER ADD COLUMN IF NOT EXISTS PROFILEURL VARCHAR(255);

DROP TABLE IF EXISTS PUBLIC.RANKINGLIST_RANKINGS;

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.RANKINGLIST_RANKING(
    RANKINGLIST_ID BIGINT NOT NULL,
    RANKINGS_ID BIGINT NOT NULL
);     

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.RANKINGLIST(
  ID BIGINT DEFAULT (NEXT VALUE FOR PUBLIC.SYSTEM_SEQUENCE_79A3ABCD_AC32_4B61_9731_9EA75EE3D359) NOT NULL NULL_TO_DEFAULT SEQUENCE PUBLIC.SYSTEM_SEQUENCE_79A3ABCD_AC32_4B61_9731_9EA75EE3D359,
  CALCULATIONDATE VARCHAR(255) NOT NULL,
  RANKINGSCOPE VARCHAR(255) NOT NULL
);
ALTER TABLE PUBLIC.RANKINGLIST ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_F PRIMARY KEY(ID);

ALTER TABLE PUBLIC.USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_27 PRIMARY KEY(ID);

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.RANKING_USER(
    RANKING_ID BIGINT NOT NULL,
    USERS_ID INTEGER NOT NULL
); 

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.USERSETTINGS(
  USER_SETTINGS_ID BIGINT DEFAULT (NEXT VALUE FOR PUBLIC.SYSTEM_SEQUENCE_F3397C68_6C71_486F_8E7E_73785F83E058) NOT NULL NULL_TO_DEFAULT SEQUENCE PUBLIC.SYSTEM_SEQUENCE_F3397C68_6C71_486F_8E7E_73785F83E058,
  DEFAULTPULLREQUESTLISTORDERING VARCHAR(255)
);
ALTER TABLE PUBLIC.USERSETTINGS ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_A PRIMARY KEY(USER_SETTINGS_ID);
ALTER TABLE PUBLIC.USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_702JWPB793YTB2ON5BP4EIU4 FOREIGN KEY(USER_SETTINGS_ID) REFERENCES PUBLIC.USERSETTINGS(USER_SETTINGS_ID) NOCHECK;

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.USERSETTINGS_REPOBLACKLIST(
    USERSETTINGS_USER_SETTINGS_ID BIGINT NOT NULL,
    REPOBLACKLIST INTEGER
);

-- 19 +/- SELECT COUNT(*) FROM PUBLIC.USER;
ALTER TABLE PUBLIC.REPO ADD CONSTRAINT IF NOT EXISTS PUBLIC.UK_QEDS8S1RPG0DD2O7O4HQJ5T9P UNIQUE(NAME);
ALTER TABLE PUBLIC.USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.UK_JREODF78A7PL5QIDFH43AXDFB UNIQUE(USERNAME);
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_BX0S0OC7KKG0QI43E4MO2FTCI FOREIGN KEY(AUTHOR_ID) REFERENCES PUBLIC.USER(ID) NOCHECK;
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_AQ6TYEWWQ4E4S1U03XW06Q2XC FOREIGN KEY(REPO_ID) REFERENCES PUBLIC.REPO(ID) NOCHECK;
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_MWCA9DCM3DP9MXMNDVY7Y5287 FOREIGN KEY(ASSIGNEE_ID) REFERENCES PUBLIC.USER(ID) NOCHECK;

--ALTER TABLE PUBLIC.RANKINGLIST_RANKINGS ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_EMFDMDTC71X5V8YP9ULTYGS0D FOREIGN KEY(RANKINGLIST_ID) REFERENCES PUBLIC.RANKINGLIST(ID) NOCHECK;
-- ALTER TABLE PUBLIC.RANKINGLIST_RANKINGS ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_8HCB0777CMIUQBG26D62GTMFW FOREIGN KEY(USER_ID) REFERENCES PUBLIC.USER(ID) NOCHECK;
ALTER TABLE PUBLIC.RANKINGLIST_RANKING ADD CONSTRAINT IF NOT EXISTS PUBLIC.UK_FMAFF0D12LAUTORMWKTL9LL2E UNIQUE(RANKINGS_ID); 
ALTER TABLE PUBLIC.RANKINGLIST_RANKING ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_FMAFF0D12LAUTORMWKTL9LL2E FOREIGN KEY(RANKINGS_ID) REFERENCES PUBLIC.RANKING(ID) NOCHECK; 
ALTER TABLE PUBLIC.RANKINGLIST_RANKING ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_FEUO42FRWRR47EK7OLE6IDRB2 FOREIGN KEY(RANKINGLIST_ID) REFERENCES PUBLIC.RANKINGLIST(ID) NOCHECK;               
ALTER TABLE PUBLIC.RANKING_USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_E0O65F404A9D6MBKLQLSHJ50G FOREIGN KEY(RANKING_ID) REFERENCES PUBLIC.RANKING(ID) NOCHECK;              
ALTER TABLE PUBLIC.RANKING_USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_G7WUFMP19K7BNGYRD0NI5FPE FOREIGN KEY(USERS_ID) REFERENCES PUBLIC.USER(ID) NOCHECK; 
