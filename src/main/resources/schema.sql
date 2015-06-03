DROP TABLE IF EXISTS PUBLIC.RANKING_USER;

CREATE USER IF NOT EXISTS "" PASSWORD '' ADMIN;

CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_12E4548E_F545_42AC_8E0C_08822E6FD9CF START WITH 1 BELONGS_TO_TABLE;    
CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_79A3ABCD_AC32_4B61_9731_9EA75EE3D359 START WITH 1 BELONGS_TO_TABLE;
CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_F3397C68_6C71_486F_8E7E_73785F83E058 START WITH 1 BELONGS_TO_TABLE;
CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_8BD59551_2952_42B8_BF8A_903BDCE6E622 START WITH 1 BELONGS_TO_TABLE;
CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_HORST START WITH 1 BELONGS_TO_TABLE;
CREATE SEQUENCE IF NOT EXISTS PUBLIC.SYSTEM_SEQUENCE_PETER START WITH 1 BELONGS_TO_TABLE;

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
ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS UPDATEDAT VARCHAR(255);

ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS BUILD_STATE VARCHAR(30);
ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS BUILD_TIMESTAMP VARCHAR(100);
ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS NUMBEROFCOMMENTS INTEGER DEFAULT 0;
ALTER TABLE PUBLIC.PULLREQUEST ADD COLUMN IF NOT EXISTS BUILD_URI VARCHAR(255);


ALTER TABLE PUBLIC.PULLREQUEST DROP COLUMN IF EXISTS NUMBEROFREVIEWCOMMENTS;

------

DROP TABLE IF EXISTS PUBLIC.RANKING;

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.RANKINGS (
    ID BIGINT DEFAULT (NEXT VALUE FOR PUBLIC.SYSTEM_SEQUENCE_HORST) NOT NULL NULL_TO_DEFAULT SEQUENCE PUBLIC.SYSTEM_SEQUENCE_HORST,
    USER_ID INTEGER NOT NULL,
    SCORE DOUBLE DEFAULT 0 NOT NULL,
    SUMOFLINESADDED INTEGER DEFAULT 0 NOT NULL,
    SUMOFLINESREMOVED INTEGER DEFAULT 0 NOT NULL,
    SUMOFFILESCHANGED INTEGER DEFAULT 0 NOT NULL,
    CLOSEDCOUNT INTEGER DEFAULT 0 NOT NULL,
    SUMOFCOMMENTS INTEGER DEFAULT 0 NOT NULL,
    RANK INTEGER
);

ALTER TABLE PUBLIC.RANKINGS DROP COLUMN IF EXISTS SUMOFSCORES;
ALTER TABLE PUBLIC.RANKINGS ADD COLUMN IF NOT EXISTS SCORE DOUBLE DEFAULT 0 NOT NULL;

ALTER TABLE PUBLIC.RANKINGS ADD COLUMN IF NOT EXISTS SUMOFFILESCHANGED INTEGER;
ALTER TABLE PUBLIC.RANKINGS ADD COLUMN IF NOT EXISTS SUMOFCOMMENTS INTEGER DEFAULT 0 NOT NULL;

ALTER TABLE PUBLIC.RANKINGS ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_6 PRIMARY KEY(ID);
ALTER TABLE PUBLIC.RANKINGS DROP COLUMN IF EXISTS RANKING_LIST_ID;


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
ALTER TABLE PUBLIC.USER ADD COLUMN IF NOT EXISTS ACCESSTOKEN VARCHAR(255);

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.RANKINGLIST_RANKINGS(
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

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.USERSETTINGS(
  USER_SETTINGS_ID BIGINT DEFAULT (NEXT VALUE FOR PUBLIC.SYSTEM_SEQUENCE_F3397C68_6C71_486F_8E7E_73785F83E058) NOT NULL NULL_TO_DEFAULT SEQUENCE PUBLIC.SYSTEM_SEQUENCE_F3397C68_6C71_486F_8E7E_73785F83E058,
  DEFAULTPULLREQUESTLISTORDERING VARCHAR(255)
);

ALTER TABLE PUBLIC.USERSETTINGS ADD COLUMN IF NOT EXISTS LANGUAGE VARCHAR(3);
ALTER TABLE PUBLIC.USERSETTINGS ALTER COLUMN LANGUAGE VARCHAR(3);
ALTER TABLE PUBLIC.USERSETTINGS ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_A PRIMARY KEY(USER_SETTINGS_ID);
ALTER TABLE PUBLIC.USERSETTINGS DROP COLUMN IF EXISTS DEFAULTPULLREQUESTLISTORDERING;
ALTER TABLE PUBLIC.USERSETTINGS ADD COLUMN IF NOT EXISTS ASSIGNED_PULLREQUESTS_ORDERING VARCHAR(10);
ALTER TABLE PUBLIC.USERSETTINGS ADD COLUMN IF NOT EXISTS UNASSIGNED_PULLREQUESTS_ORDERING VARCHAR(10);



ALTER TABLE PUBLIC.USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_702JWPB793YTB2ON5BP4EIU4 FOREIGN KEY(USER_SETTINGS_ID) REFERENCES PUBLIC.USERSETTINGS(USER_SETTINGS_ID) NOCHECK;

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.USERSETTINGS_REPOBLACKLIST(
    USERSETTINGS_USER_SETTINGS_ID BIGINT NOT NULL,
    REPOBLACKLIST INTEGER
);

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.NOTIFICATION(
    ID BIGINT DEFAULT (NEXT VALUE FOR PUBLIC.SYSTEM_SEQUENCE_8BD59551_2952_42B8_BF8A_903BDCE6E622) NOT NULL NULL_TO_DEFAULT SEQUENCE PUBLIC.SYSTEM_SEQUENCE_8BD59551_2952_42B8_BF8A_903BDCE6E622,
    TMSTMP VARCHAR(255),
    NOTIFICATIONTYPE VARCHAR(255),
    RECEIVINGUSERID BIGINT NOT NULL CHECK (RECEIVINGUSERID >= 1),
    SEEN BOOLEAN,
    COUNT INTEGER,
    ACTOR_ID INTEGER NULL,
    PULLREQUEST_ID INTEGER
);
ALTER TABLE PUBLIC.NOTIFICATION ADD COLUMN IF NOT EXISTS COUNT INTEGER;
ALTER TABLE PUBLIC.NOTIFICATION ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_AD PRIMARY KEY(ID);
ALTER TABLE PUBLIC.NOTIFICATION ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_H796FEJ80BPP4Y9BPYSS7F1C FOREIGN KEY(PULLREQUEST_ID) REFERENCES PUBLIC.PULLREQUEST(ID) NOCHECK;
ALTER TABLE PUBLIC.NOTIFICATION ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_CDANGPKSKYY9Q1LXP6PJ7TOHK FOREIGN KEY(ACTOR_ID)  REFERENCES PUBLIC.USER(ID) NOCHECK;

-- DROP TABLE IF EXISTS PUBLIC.COMMENTS;

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.COMMENTS(
    ID INTEGER NOT NULL CHECK (ID >= 1),
    DIFFHUNK VARCHAR(255),
    CREATEDAT VARCHAR(255),
    PULLREQUEST_ID INTEGER
);
ALTER TABLE PUBLIC.COMMENTS ADD CONSTRAINT IF NOT EXISTS PUBLIC.CONSTRAINT_XYZ PRIMARY KEY(ID);
ALTER TABLE PUBLIC.COMMENTS ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_CMNTS_PR FOREIGN KEY(PULLREQUEST_ID) REFERENCES PUBLIC.PULLREQUEST(ID) NOCHECK;

CREATE CACHED TABLE IF NOT EXISTS PUBLIC.NOTIFICATION_COMMENTS(
  NOTIFICATION_ID INTEGER NOT NULL CHECK (NOTIFICATION_ID >= 1),
  COMMENT_ID INTEGER NOT NULL CHECK (COMMENT_ID >= 1)
);

ALTER TABLE PUBLIC.NOTIFICATION_COMMENTS ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_NC_NOTIFICATION FOREIGN KEY(NOTIFICATION_ID) REFERENCES PUBLIC.NOTIFICATION(ID) NOCHECK; 
ALTER TABLE PUBLIC.NOTIFICATION_COMMENTS ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_NC_COMMENT FOREIGN KEY(COMMENT_ID) REFERENCES PUBLIC.COMMENTS(ID) NOCHECK;

-- 19 +/- SELECT COUNT(*) FROM PUBLIC.USER;
ALTER TABLE PUBLIC.REPO ADD CONSTRAINT IF NOT EXISTS PUBLIC.UK_QEDS8S1RPG0DD2O7O4HQJ5T9P UNIQUE(NAME);
ALTER TABLE PUBLIC.USER ADD CONSTRAINT IF NOT EXISTS PUBLIC.UK_JREODF78A7PL5QIDFH43AXDFB UNIQUE(USERNAME);
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_BX0S0OC7KKG0QI43E4MO2FTCI FOREIGN KEY(AUTHOR_ID) REFERENCES PUBLIC.USER(ID) NOCHECK;
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_AQ6TYEWWQ4E4S1U03XW06Q2XC FOREIGN KEY(REPO_ID) REFERENCES PUBLIC.REPO(ID) NOCHECK;
ALTER TABLE PUBLIC.PULLREQUEST ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_MWCA9DCM3DP9MXMNDVY7Y5287 FOREIGN KEY(ASSIGNEE_ID) REFERENCES PUBLIC.USER(ID) NOCHECK;

ALTER TABLE PUBLIC.RANKINGLIST_RANKINGS ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_RANKING_LIST_ID FOREIGN KEY(RANKINGLIST_ID) REFERENCES PUBLIC.RANKINGLIST(ID) NOCHECK;
ALTER TABLE PUBLIC.RANKINGLIST_RANKINGS ADD CONSTRAINT IF NOT EXISTS PUBLIC.FK_RANKING_ID FOREIGN KEY(RANKINGS_ID) REFERENCES PUBLIC.RANKINGS(ID) NOCHECK;
