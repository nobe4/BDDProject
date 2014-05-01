-- -----------------------------------------------------
-- Dropping all tables
-- -----------------------------------------------------

select 'DROP ALL TABLES' as " " from dual;

DROP TABLE SUPPLIERBUNDLE;
DROP TABLE BUNDLEINREPOSITORY;

DROP TABLE CLIENTCOMMANDPRODUCT;
DROP TABLE CLIENTCOMMAND;
DROP TABLE SHIPPINGADDRESS;
DROP TABLE CLIENT;

DROP TABLE WHOLESALERCOMMANDPRODUCT;
DROP TABLE WHOLESALERCOMMAND;
DROP TABLE SUPPLIER;
DROP TABLE POSSIBILITY;

DROP TABLE BUNDLE;
DROP TABLE REPOSITORY;
DROP TABLE WHOLESALER;
DROP TABLE FOOD;
DROP TABLE CLOTH;
DROP TABLE PRODUCT;


select 'Create tables' as " " from dual;
select 'Create table PRODUCT' as " " from dual;
CREATE TABLE PRODUCT (
  ID      INT       NOT NULL,
  -- add auto increment on id with trigger
  NAME      VARCHAR(45)   NOT NULL,
  BASEPRICE   INT       NOT NULL,
  constraint PRODUCT_PK PRIMARY KEY (ID, NAME)
  );


-- -----------------------------------------------------
-- Table CLOTH
-- -----------------------------------------------------

select 'Create table CLOTH' as " " from dual;
CREATE TABLE CLOTH (
    ID         INT              NOT NULL,
    NAME      VARCHAR(45)     NOT NULL,
    CLOTHSIZE      INT             NOT NULL, -- CHANGE NAME BECAUSE OF CONFLICTS
    COLOR     VARCHAR(45)     NOT NULL,
  constraint CLOTH_PK PRIMARY KEY (ID, NAME),
  constraint CLOTH_FK FOREIGN KEY (ID, NAME) REFERENCES PRODUCT(ID, NAME)
);    

-- -----------------------------------------------------
-- Table FOOD
-- -----------------------------------------------------
select 'Create table FOOD' as " " from dual;
CREATE TABLE FOOD (
  ID          INT           NOT NULL,
  NAME        VARCHAR(45)   NOT NULL,
  USEBYDATE   DATE          NOT NULL,
  TEMPERATURE INT           NULL,
  constraint FOOD_PK  PRIMARY KEY (ID, NAME),
  constraint FOOD_FK  FOREIGN KEY (ID, NAME) REFERENCES PRODUCT(ID, NAME)    
);

-- -----------------------------------------------------
-- Table WHOLESALER
-- -----------------------------------------------------
select 'Create table WHOLESALER' as " " from dual;
CREATE TABLE WHOLESALER (
  ID          INT           NOT NULL, --AUTO_INCREMENT,
  NAME        VARCHAR(45)   NOT NULL,
  ADDRESS     VARCHAR(255)  NOT NULL,
  constraint WHOLESALER_PK PRIMARY KEY (ID) -- REMOVE NAME FROM PRIMARY KEY
);

-- -----------------------------------------------------
-- Table REPOSITORY
-- -----------------------------------------------------
select 'Create table REPOSITORY' as " " from dual;
CREATE TABLE REPOSITORY (
  ADDRESS       VARCHAR(255)  NOT NULL,
  CAPACITY      INT           NOT NULL,
  WHOLESALERID  INT           NOT NULL,
  constraint REPOSITORY_PK PRIMARY KEY (ADDRESS),
  constraint REPOSITORY_FK FOREIGN KEY (WHOLESALERID) REFERENCES WHOLESALER (ID)  
);

-- -----------------------------------------------------
-- Table BUNDLE
-- -----------------------------------------------------
select 'Create table BUNDLE' as " " from dual;
CREATE TABLE BUNDLE (
  ID        INT                 NOT NULL, -- AUTO_INCREMENT, -- CHANGE FROM NUMBER TO ID
  PRODUCTID     INT             NOT NULL,
  PRODUCTNAME   VARCHAR(45)     NOT NULL,
  QUANTITY      INT             NOT NULL,
  CONSTRAINT BUNDLE_PK PRIMARY KEY (ID, PRODUCTID),
  CONSTRAINT PRODUCT_FK
    FOREIGN KEY (PRODUCTID, PRODUCTNAME)
    REFERENCES PRODUCT (ID, NAME) -- WORK BECAUSE OF MODIFICATION ON PRODUCT TABLE
);

-- -----------------------------------------------------
-- Table POSSIBILITY
-- -----------------------------------------------------

select 'Create table POSSIBILITY' as " " from dual;
CREATE TABLE POSSIBILITY (
  NAME                VARCHAR(255)    NOT NULL,
  REPOSITORYADDRESS   VARCHAR(255)    NOT NULL,
  CONSTRAINT POSSIBILITY_PK PRIMARY KEY (NAME, REPOSITORYADDRESS),
  CONSTRAINT REPOSITORYADDRESS_FK
    FOREIGN KEY (REPOSITORYADDRESS)
    REFERENCES REPOSITORY (ADDRESS)
);

-- -----------------------------------------------------
-- Table SUPPLIER
-- -----------------------------------------------------

select 'Create table SUPPLIER' as " " from dual;
CREATE TABLE SUPPLIER (
  ID            INT           NOT NULL, -- AUTO_INCREMENT,
  NAME          VARCHAR(45)   NOT NULL,
  ADDRESS       VARCHAR(255)  NOT NULL,
  PHONENUMBER   VARCHAR(45)   NOT NULL,
  CONSTRAINT SUPPLIER_PK PRIMARY KEY (ID, NAME)
);

-- -----------------------------------------------------
-- Table WHOLESALERCOMMAND
-- -----------------------------------------------------

select 'Create table WHOLESALERCOMMAND' as " " from dual;
CREATE TABLE WHOLESALERCOMMAND (
  ID              INT           NOT NULL, -- AUTO_INCREMENT,
  SUPPLIERID      INT           NOT NULL,
  SUPPLIERNAME    VARCHAR(45)   NOT NULL, -- ADD BECAUSE OF SUPPLIER PRIMARY KEY DEFINITION
  WHOLESALERID    INT           NOT NULL,
  CONSTRAINT WHOLESALERCOMMAND_PK PRIMARY KEY (ID),
  CONSTRAINT WHOLESALERIDFORCOMMAND_FK
    FOREIGN KEY (WHOLESALERID)
    REFERENCES WHOLESALER (ID),
  CONSTRAINT SUPPLIERID_FK
    FOREIGN KEY (SUPPLIERID, SUPPLIERNAME)
    REFERENCES SUPPLIER (ID, NAME)         -- ADDED BECAUSE OF SUPPLIER PRIMARY KEY DEFINITION
);

-- -----------------------------------------------------
-- Table WHOLESALERCOMMANDPRODUCT
-- -----------------------------------------------------

select 'Create table WHOLESALERCOMMANDPRODUCT' as " " from dual;
CREATE TABLE WHOLESALERCOMMANDPRODUCT (
  COMMANDID           INT       NOT NULL,
  BUNDLEID        INT       NOT NULL,
  PRODUCTID       INT       NOT NULL,
  QUANTITY            INT       NOT NULL,
  NEGOCIATEDPRICE     NUMBER    NOT NULL,
  CONSTRAINT WHOLESALERCOMMANDPRODUCT_PK PRIMARY KEY (COMMANDID, BUNDLEID),
  CONSTRAINT BUNDLE_FK
    FOREIGN KEY (BUNDLEID, PRODUCTID)
    REFERENCES BUNDLE (ID, PRODUCTID),
  CONSTRAINT COMMAND_FK
    FOREIGN KEY (COMMANDID)
    REFERENCES WHOLESALERCOMMAND (ID)
);

-- -----------------------------------------------------
-- Table CLIENT
-- -----------------------------------------------------
select 'Create table CLIENT' as " " from dual;
CREATE TABLE CLIENT (
  ID              INT               NOT NULL,
  NAME            VARCHAR(45)       NOT NULL,
  MAINADDRESS     VARCHAR(255)      NOT NULL,
  PHONENUMBER     VARCHAR(45)       NOT NULL,
  CONSTRAINT CLIENT_PK PRIMARY KEY (ID) -- , NAME) -- REMOVE NAME FROM PRIMARY KEY
);

-- -----------------------------------------------------
-- Table SHIPPINGADDRESS
-- -----------------------------------------------------
select 'Create table SHIPPINGADDRESS' as " " from dual;
CREATE TABLE SHIPPINGADDRESS (
  CLIENTID      INT           NOT NULL,
  ADDRESS       VARCHAR(255)  NOT NULL,
  CONSTRAINT SHIPPINGADDRESS_PK PRIMARY KEY (CLIENTID, ADDRESS),
  CONSTRAINT FKCLIENT
    FOREIGN KEY (CLIENTID)
    REFERENCES CLIENT (ID)
);

-- -----------------------------------------------------
-- Table CLIENTCOMMAND
-- -----------------------------------------------------
select 'Create table CLIENTCOMMAND' as " " from dual;
CREATE TABLE CLIENTCOMMAND (
  ID                  INT             NOT NULL,
  CLIENTID            INT             NOT NULL,
  WHOLESALERID        INT             NOT NULL,
  SHIPPINGADDRESS     VARCHAR(255)    NOT NULL,
  CONSTRAINT CLIENTCOMMAND_PK PRIMARY KEY (ID, CLIENTID),
  CONSTRAINT SHIPPINGADDRESS_FK
    FOREIGN KEY (CLIENTID, SHIPPINGADDRESS)
    REFERENCES SHIPPINGADDRESS (CLIENTID, ADDRESS)
  ,
  CONSTRAINT CLIENTID_FK
    FOREIGN KEY (CLIENTID)
    REFERENCES CLIENT (ID)
  ,
  CONSTRAINT WHOLESALERIDFORCLIENT_FK
    FOREIGN KEY (WHOLESALERID)
    REFERENCES WHOLESALER (ID)
);

-- -----------------------------------------------------
-- Table CLIENTCOMMANDPRODUCT
-- -----------------------------------------------------
select 'Create table CLIENTCOMMANDPRODUCT' as " " from dual;
CREATE TABLE CLIENTCOMMANDPRODUCT (
  COMMANDID           	INT       	NOT NULL,
  BUNDLEID        		INT       	NOT NULL,
  CLIENTID 				INT 		NOT NULL, -- Added to match CLIENTCOMMAND primary key
  PRODUCTID 			INT 		NOT NULL, -- Added to match BUNDLE primary key
  QUANTITY            	INT       	NOT NULL,
  NEGOCIATEDPRICE     	DECIMAL    	NOT NULL,
  CONSTRAINT CLIENTCOMMANDPRODUCT_PK PRIMARY KEY (COMMANDID, BUNDLEID),
  CONSTRAINT COMMANDFORCLIENT_FK
    FOREIGN KEY (CLIENTID, COMMANDID)
    REFERENCES CLIENTCOMMAND (CLIENTID, ID)
  ,
  CONSTRAINT BUNDLEFORCLIENT_FK
    FOREIGN KEY (BUNDLEID, PRODUCTID)
    REFERENCES BUNDLE (ID, PRODUCTID)
);

-- -----------------------------------------------------
-- Table BUNDLEINREPOSITORY
-- -----------------------------------------------------
select 'Create table BUNDLEINREPOSITORY' as " " from dual;
CREATE TABLE BUNDLEINREPOSITORY (
  BUNDLEID         	INT             NOT NULL,
  REPOSITORYADDRESS     	VARCHAR(255)    NOT NULL,
  PRODUCTID 				INT 			NOT NULL, -- Added to match BUNDLE primary key
  CONSTRAINT BUNDLEINREPOSITORY_PK PRIMARY KEY (BUNDLEID, REPOSITORYADDRESS),
  CONSTRAINT BUNDLEINREPOSITORY_FK
    FOREIGN KEY (BUNDLEID, PRODUCTID)
    REFERENCES BUNDLE (ID, PRODUCTID)
  ,
  CONSTRAINT REPOSITORYADDRESSFORREPO_FK
    FOREIGN KEY (REPOSITORYADDRESS)
    REFERENCES REPOSITORY (ADDRESS)
);

-- -----------------------------------------------------
-- Table SUPPLIERBUNDLE
-- -----------------------------------------------------
select 'Create table SUPPLIERBUNDLE' as " " from dual;
CREATE TABLE SUPPLIERBUNDLE (
  BUNDLEID      INT 			NOT NULL,
  SUPPLIERID    INT 			NOT NULL,
  SUPPLIERNAME 	VARCHAR(45)  	NOT NULL, -- Added to match SUPPLIER primary key
  PRODUCTID 	INT 			NOT NULL, -- Added to match BUNDLE primary key
  CONSTRAINT SUPPLIERBUNDLE_PK PRIMARY KEY (BUNDLEID, SUPPLIERID),
  CONSTRAINT BUNDLEFORSUPPLIER_FK
    FOREIGN KEY (BUNDLEID, PRODUCTID)
    REFERENCES BUNDLE (ID, PRODUCTID)
  ,
  CONSTRAINT SUPPLIERFORSUPPLIERBUNDLE_FK
    FOREIGN KEY (SUPPLIERID, SUPPLIERNAME)
    REFERENCES SUPPLIER (ID, NAME)
);
select 'Finished.' as " " from dual;