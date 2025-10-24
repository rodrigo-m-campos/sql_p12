--Create the tables
CREATE TABLE AppUser (
	AppUserId NUMBER NOT NULL,
	FirstName VARCHAR2(30) NOT NULL,
	LastName VARCHAR2(30) NOT NULL,
	Email VARCHAR2(50) UNIQUE,
	Alias VARCHAR2(30),
	Phone VARCHAR2(30),
	constraint AppUser_PK PRIMARY KEY (AppUserId));

CREATE TABLE AppGroup (
	AppGroupId NUMBER NOT NULL,
	GroupName VARCHAR2(30) NOT NULL,
	CreationDate DATE NOT NULL,
	GroupDescription VARCHAR2(30),
	BaseCurrencyId NUMBER NOT NULL,
	constraint AppGroup_PK PRIMARY KEY (AppGroupId));

CREATE TABLE Membership (
	AppUserId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	JoiningDate DATE NOT NULL,
	MemberRole VARCHAR2(30) NOT NULL CHECK (MemberRole IN ('Owner', 'Admin', 'Member')),
	LeavingDate DATE,
	constraint Membership_PK PRIMARY KEY (AppUserId, AppGroupId));

CREATE TABLE Expense (
	ExpenseId NUMBER NOT NULL,
	AppUserId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	Amount NUMBER(2) NOT NULL,
	CurrencyId NUMBER NOT NULL,
	ExpenseDate DATE NOT NULL,
	RegistrationDate DATE NOT NULL,
	DivisionType VARCHAR2(30) DEFAULT Equal CHECK (DivisionType IN ('Equal', 'Shared', 'Exact')) Not NULL,
	CategoryId NUMBER NOT NULL,
	constraint Expense_PK PRIMARY KEY (ExpenseId));

CREATE TABLE ParticipationExpense (
	ExpenseId NUMBER NOT NULL,
	AppUserId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	Amount NUMBER(10,2) NOT NULL,
	constraint ParticipationExpense_PK PRIMARY KEY (ExpenseId, AppUserId, AppGroupId));

CREATE TABLE Category (
	CategoryId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	CategoryName VARCHAR(30) NOT NULL,
	constraint Category_PK PRIMARY KEY (CategoryId));

CREATE TABLE Currency (
	CurrencyId Varchar2(3) NOT NULL,
	CurrencyName VARCHAR(30) NOT NULL,
	constraint Currency_PK PRIMARY KEY (CurrencyId));

CREATE TABLE ExchangeRate (
	RateId NUMBER NOT NULL,
	CurrencyFrom NUMBER NOT NULL,
	CurrencyTo NUMBER NOT NULL,
	ExchangeDate DATE NOT NULL,
	--Here we should determine decimals (or try a different solution)
	Rate NUMBER(10,2)
	constraint ExchangeRate_PK PRIMARY KEY (RateId));

CREATE TABLE Payment (
	PaymentId NUMBER NOT NULL,
	PayerId NUMBER NOT NULL,
	PayeeId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	Amount NUMBER(10,2) NOT NULL,
	CurrencyId NUMBER NOT NULL,
	PaymentDate DATE NOT NULL,
	Note VARCHAR2(300),
	constraint Payment_PK PRIMARY KEY (PaymentId));

CREATE TABLE Notification (
	NotificationId NUMBER NOT NULL,
	PaymentId NUMBER NOT NULL,
	RecipientId NUMBER NOT NULL,
	NotificationText VARCHAR2(300) NOT NULL,
	NotificationTime TIMESTAMP NOT NULL,
	IsRead CHAR(1) NOT NULL CHECK (IsRead IN ('Y', 'N')),
	constraint Notification_PK PRIMARY KEY (NotificationId));

CREATE TABLE MessageGroup (
	MessageGroupId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	SenderId NUMBER NOT NULL,
	MessageText VARCHAR2(300) NOT NULL,
	MessageTime TIMESTAMP NOT NULL,
	constraint MessageGroup_PK PRIMARY KEY (MessageGroupId));

CREATE TABLE MessagePrivate (
	MessagePrivateId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	SenderId NUMBER NOT NULL,
	RecipientId NUMBER NOT NULL,
	MessageText VARCHAR2(300) NOT NULL,
	MessageTime TIMESTAMP NOT NULL,
	constraint MessagePrivate_PK PRIMARY KEY (MessagePrivateId));


--Add foreign keys
ALTER TABLE AppGroup ADD CONSTRAINT AppGroup_fk0 FOREIGN KEY (BaseCurrencyId) REFERENCES Currency(CurrencyId);

ALTER TABLE Membership ADD CONSTRAINT Membership_fk0 FOREIGN KEY (AppUserId) REFERENCES AppUser(AppUserId);
ALTER TABLE Membership ADD CONSTRAINT Membership_fk1 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);

ALTER TABLE Expense ADD CONSTRAINT Expense_fk0 FOREIGN KEY (AppUserId,AppGroupId) REFERENCES Membership(AppUserId,AppGroupId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk2 FOREIGN KEY (CurrencyId) REFERENCES Currency(CurrencyId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk3 FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId);

ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk0 FOREIGN KEY (AppUserId, AppGroupId) REFERENCES Membership(AppUserId, AppGroupId);
--ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk1 FOREIGN KEY (AppGroupId) REFERENCES Membership(AppGroupId);
ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk2 FOREIGN KEY (ExpenseId) REFERENCES Expense(ExpenseId);

ALTER TABLE Category ADD CONSTRAINT Category_fk0 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);

ALTER TABLE ExchangeRate ADD CONSTRAINT ExchangeRate_fk0 FOREIGN KEY (CurrencyFrom) REFERENCES Currency(CurrencyId);
ALTER TABLE ExchangeRate ADD CONSTRAINT ExchangeRate_fk1 FOREIGN KEY (CurrencyTo) REFERENCES Currency(CurrencyId);

ALTER TABLE Payment ADD CONSTRAINT Payment_fk0 FOREIGN KEY (AppGroupId, PayerId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE Payment ADD CONSTRAINT Payment_fk1 FOREIGN KEY (AppGroupId, PayeeId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE Payment ADD CONSTRAINT Payment_fk2 FOREIGN KEY (CurrencyId) REFERENCES Currency(CurrencyId);

ALTER TABLE Notification ADD CONSTRAINT Notification_fk0 FOREIGN KEY (PaymentId) REFERENCES Payment(PaymentId);
ALTER TABLE Notification ADD CONSTRAINT Notification_fk1 FOREIGN KEY (RecipientId) REFERENCES AppUser(AppUserId);

ALTER TABLE MessageGroup ADD CONSTRAINT MessageGroup_fk0 FOREIGN KEY (AppGroupId, SenderId) REFERENCES Membership(AppGroupId, AppUserId);

ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk0 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);
ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk1 FOREIGN KEY (AppGroupId, SenderId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk2 FOREIGN KEY (AppGroupId, RecipientId) REFERENCES Membership(AppGroupId, AppUserId);

-- TABLE DROPS
DROP TABLE MessagePrivate;
DROP TABLE MessageGroup;
DROP TABLE Notification;
DROP TABLE Payment;
DROP TABLE ExchangeRate;
DROP TABLE ParticipationExpense;
DROP TABLE Expense;
DROP TABLE Category;
DROP TABLE Membership;
DROP TABLE AppGroup;
DROP TABLE AppUser;
DROP TABLE Currency;
-- CURRENCY
-- Note: Using standard 3-letter codes as defined in the schema.
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('EUR', 'Euro');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('USD', 'US Dollar');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('GBP', 'British Pound');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('LYD', 'Libyan Dinar');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('TND', 'Tunisian Dinar');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('JPY', 'Japanese Yen');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('CNY', 'Chinese Yuan');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('INR', 'Indian Rupee');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('AUD', 'Australian Dollar');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES ('CAD', 'Canadian Dollar');

-- EXCHANGERATE
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1001, 'EUR', 'USD', TO_DATE('2022-11-03', 'YYYY-MM-DD'), 1.10);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1002, 'USD', 'EUR', TO_DATE('2022-11-03', 'YYYY-MM-DD'), 0.91);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1003, 'EUR', 'GBP', TO_DATE('2025-08-18', 'YYYY-MM-DD'), 0.85);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1004, 'GBP', 'EUR', TO_DATE('2025-08-18', 'YYYY-MM-DD'), 1.18);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1005, 'LYD', 'EUR', TO_DATE('2024-07-20', 'YYYY-MM-DD'), 0.20);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1006, 'EUR', 'JPY', TO_DATE('2025-06-10', 'YYYY-MM-DD'), 145.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1007, 'JPY', 'EUR', TO_DATE('2025-06-10', 'YYYY-MM-DD'), 0.0069);
-- Added for Query 3.2
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1008, 'EUR', 'JPY', TO_DATE('2025-06-07', 'YYYY-MM-DD'), 165.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1009, 'USD', 'GBP', TO_DATE('2025-08-15', 'YYYY-MM-DD'), 0.80);


-- APPUSER
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (101, 'Mohammed', 'Smith', 'mohammedmosmith@gmail.com', 'MO', '+34 637-1231236');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (102, 'Jimmy', 'Page', 'jimmypage@gmail.com', NULL, '+34 644-0046462');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (103, 'Mel', 'Gibson', 'melgibson@gmail.com', NULL, '+34 666-5552555');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (104, 'Diana', 'Prince', 'dianawonderwomanprince@gmail.com', 'Wonder Woman', '+1 (222) 555-1004');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (105, 'Clark', 'Kent', 'clarksupermankent@gmail.com', 'Superman', '619-1005');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (106, 'Peter', 'Parker', 'peterspidermanparker@gmail.com', 'Spider-Man', '+1 (407) 224-1783');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (107, 'Majid', 'Ben Ghet', 'majidbenghet@gmail.com', NULL, '+218 091-3496121');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (108, 'Derek', 'Trotter', 'derekdeltrotter@gmail.com', 'Del', '+44 016-1008');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (109, 'Harry', 'Potter', 'harrypotter@gmail.com', NULL, '+44 619-1009100');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (110, 'Rodrigo', 'Campos', 'rodrigorodderscampos@gmail.com', 'Rodders', '+34 631-1010201');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Email, Alias, Phone) VALUES (111, 'Ana', 'García', 'anagarcia@gmail.com', NULL, '+34 644-1011121');

--- APPGROUP
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (201, 'Family', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'Family expenses', 'EUR');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (202, 'Friends', TO_DATE('2023-02-20', 'YYYY-MM-DD'), 'Friends trips and outings', 'EUR');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (203, 'Work', TO_DATE('2023-03-10', 'YYYY-MM-DD'), 'Work-related expenses', 'EUR');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (204, 'JAPAN2025', TO_DATE('2025-06-05', 'YYYY-MM-DD'), 'Travel Expenses', 'JPY');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (205, 'London trip', TO_DATE('2025-08-12', 'YYYY-MM-DD'), 'Travel Expenses', 'GBP');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (206, 'Friday nights out', TO_DATE('2022-11-01', 'YYYY-MM-DD'), 'Weekly outings', 'USD');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (207, 'Rent', TO_DATE('2023-04-18', 'YYYY-MM-DD'), 'rent and other household expenses', 'EUR');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (208, 'Ski weekend', TO_DATE('2023-05-22', 'YYYY-MM-DD'), NULL, 'EUR');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (209, 'Gym buddies', TO_DATE('2023-06-30', 'YYYY-MM-DD'), 'Shared fitness expenses', 'GBP');
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (210, 'Summer In North Africa', TO_DATE('2024-07-14', 'YYYY-MM-DD'), 'Travel expenses', 'LYD');

--- MEMBERSHIP
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (101, 201, TO_DATE('2023-01-15','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (102, 201, TO_DATE('2023-01-20','YYYY-MM-DD'), 'Admin', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (103, 201, TO_DATE('2023-02-01','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (104, 202, TO_DATE('2023-02-21','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (105, 203, TO_DATE('2023-03-11','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (106, 203, TO_DATE('2023-03-11','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (106, 204, TO_DATE('2025-06-06','YYYY-MM-DD'), 'Member', TO_DATE('2025-06-25','YYYY-MM-DD'));
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (101, 204, TO_DATE('2025-06-05','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (107, 205, TO_DATE('2025-08-13','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (108, 205, TO_DATE('2025-08-14','YYYY-MM-DD'), 'Member', TO_DATE('2025-08-20','YYYY-MM-DD'));
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (108, 206, TO_DATE('2022-11-02','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (101, 206, TO_DATE('2022-11-02','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (109, 207, TO_DATE('2023-04-19','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (102, 207, TO_DATE('2023-04-19','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (110, 208, TO_DATE('2023-05-23','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (109, 208, TO_DATE('2023-05-23','YYYY-MM-DD'), 'Admin', TO_DATE('2023-05-27','YYYY-MM-DD'));
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (111, 209, TO_DATE('2023-07-01','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (105, 210, TO_DATE('2024-07-15','YYYY-MM-DD'), 'Member', TO_DATE('2025-04-01','YYYY-MM-DD'));
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (107, 210, TO_DATE('2024-07-16','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (101, 202, TO_DATE('2023-03-01','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (102, 202, TO_DATE('2023-03-05','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (103, 202, TO_DATE('2023-03-10','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (104, 201, TO_DATE('2023-02-25','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (106, 202, TO_DATE('2023-03-15','YYYY-MM-DD'), 'Member', NULL);

--- CATEGORY
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (301, 201, 'Groceries');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (302, 201, 'Utilities');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (303, 201, 'Rent');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (304, 202, 'Travel');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (305, 202, 'Dining');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (306, 202, 'Entertainment');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (307, 203, 'Office Supplies');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (308, 203, 'Client Entertainment');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (309, 204, 'Flights');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (310, 204, 'Accommodation');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (311, 204, 'Food');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (312, 205, 'Flights');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (313, 205, 'Accommodation');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (314, 205, 'Food');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (315, 206, 'Dining');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (316, 206, 'Entertainment');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (317, 207, 'Rent');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (318, 207, 'Utilities');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (319, 208, 'Ski Passes');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (320, 208, 'Accommodation');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (321, 208, 'Invoices');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (322, 209, 'Invoices');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (323, 206, 'Invoices');

--- EXPENSE
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (401, 101, 201, 150.00, 'EUR', TO_DATE('2023-01-16','YYYY-MM-DD'), TO_DATE('2023-01-16','YYYY-MM-DD'), 'Equal', 301);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (402, 102, 201, 75.00, 'EUR', TO_DATE('2023-01-21','YYYY-MM-DD'), TO_DATE('2023-01-21','YYYY-MM-DD'), 'Shared', 302);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (403, 103, 201, 1200.00, 'EUR', TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-02-02','YYYY-MM-DD'), 'Exact', 303);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (404, 104, 202, 300.00, 'EUR', TO_DATE('2023-02-22','YYYY-MM-DD'), TO_DATE('2023-02-22','YYYY-MM-DD'), 'Equal', 304);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (405, 105, 203, 200.00, 'EUR', TO_DATE('2023-03-12','YYYY-MM-DD'), TO_DATE('2023-03-12','YYYY-MM-DD'), 'Shared', 307);
-- MODIFIED for Query 3.2 test
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (406, 101, 204, 500.00, 'EUR', TO_DATE('2025-06-07','YYYY-MM-DD'), TO_DATE('2025-06-07','YYYY-MM-DD'), 'Equal', 309);
-- MODIFIED for Query 3.2 test
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (407, 107, 205, 750.00, 'USD', TO_DATE('2025-08-15','YYYY-MM-DD'), TO_DATE('2025-08-15','YYYY-MM-DD'), 'Shared', 312);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (408, 108, 206, 120.00, 'USD', TO_DATE('2022-11-03','YYYY-MM-DD'), TO_DATE('2022-11-03','YYYY-MM-DD'), 'Equal', 315);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (409, 109, 207, 950.00, 'EUR', TO_DATE('2023-04-20','YYYY-MM-DD'), TO_DATE('2023-04-20','YYYY-MM-DD'), 'Exact', 317);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (410, 110, 208, 400.00, 'EUR', TO_DATE('2023-05-24','YYYY-MM-DD'), TO_DATE('2023-05-24','YYYY-MM-DD'), 'Shared', 319);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (411, 101, 206, 50.00, 'USD', TO_DATE('2022-11-10','YYYY-MM-DD'), TO_DATE('2022-11-10','YYYY-MM-DD'), 'Equal', 323);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (412, 101, 206, 250.00, 'USD', TO_DATE('2022-11-15','YYYY-MM-DD'), TO_DATE('2022-11-15','YYYY-MM-DD'), 'Equal', 323);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (413, 108, 206, 75.00, 'USD', TO_DATE('2022-11-12','YYYY-MM-DD'), TO_DATE('2022-11-12','YYYY-MM-DD'), 'Equal', 323);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (414, 110, 208, 100.00, 'EUR', TO_DATE('2023-05-25','YYYY-MM-DD'), TO_DATE('2023-05-25','YYYY-MM-DD'), 'Equal', 321);
--- PARTICIPATIONEXPENSE
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 101, 201, 50.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 102, 201, 50.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 103, 201, 50.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 101, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 102, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 103, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 104, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (403, 103, 201, 1200.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 101, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 102, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 103, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 104, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (405, 105, 203, 200.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (406, 101, 204, 41250.00); -- 250 EUR * 165 JPY/EUR = 41250 JPY
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (406, 106, 204, 41250.00); -- 250 EUR * 165 JPY/EUR = 41250 JPY
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (407, 107, 205, 300.00); -- 375 USD * 0.80 GBP/USD = 300 GBP
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (407, 108, 205, 300.00); -- 375 USD * 0.80 GBP/USD = 300 GBP
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (408, 108, 206, 120.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (409, 109, 207, 950.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (410, 109, 208, 200.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (410, 110, 208, 200.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (411, 101, 206, 25.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (411, 108, 206, 25.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (412, 101, 206, 125.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (412, 108, 206, 125.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (413, 101, 206, 37.50);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (413, 108, 206, 37.50);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (414, 110, 208, 100.00);

--- PAYMENT
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (501, 101, 102, 201, 75.00, 'EUR', TO_DATE('2023-01-22','YYYY-MM-DD'), 'Reimbursement for utilities');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (502, 103, 101, 201, 400.00, 'EUR', TO_DATE('2023-02-05','YYYY-MM-DD'), 'Rent payment');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (503, 104, 102, 202, 150.00, 'EUR', TO_DATE('2023-02-25','YYYY-MM-DD'), 'Trip expenses');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (504, 105, 101, 203, 200.00, 'EUR', TO_DATE('2023-03-15','YYYY-MM-DD'), 'Office supplies reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (505, 106, 101, 204, 82500.00, 'JPY', TO_DATE('2025-06-10','YYYY-MM-DD'), 'Flight reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (506, 108, 107, 205, 300.00, 'GBP', TO_DATE('2025-08-18','YYYY-MM-DD'), 'Accommodation reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (507, 108, 101, 206, 120.00, 'USD', TO_DATE('2022-11-05','YYYY-MM-DD'), 'Dinner reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (508, 109, 102, 207, 950.00, 'EUR', TO_DATE('2023-04-22','YYYY-MM-DD'), 'Rent payment');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (509, 110, 109, 208, 200.00, 'EUR', TO_DATE('2023-05-26','YYYY-MM-DD'), 'Ski pass reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (510, 107, 105, 210, 300.00, 'LYD', TO_DATE('2024-07-20','YYYY-MM-DD'), 'Travel expenses reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (511,102, 109, 207, 50.00, 'EUR', TO_DATE('2023-04-25','YYYY-MM-DD'), 'Utilities share');

--- NOTIFICATION
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (601, 501, 102, 'You have received a payment of 75.00 EUR from Mohammed Smith.', TO_TIMESTAMP('2023-01-22 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (602, 502, 101, 'You have received a payment of 400.00 EUR from Mel Gibson.', TO_TIMESTAMP('2023-02-05 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (603, 503, 102, 'You have received a payment of 150.00 EUR from Diana Prince.', TO_TIMESTAMP('2023-02-25 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (604, 504, 101, 'You have received a payment of 200.00 EUR from Clark Kent.', TO_TIMESTAMP('2023-03-15 09:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (605, 505, 101, 'You have received a payment of 82500.00 JPY from Peter Parker.', TO_TIMESTAMP('2025-06-10 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (606, 506, 107, 'You have received a payment of 300.00 GBP from Derek Trotter.', TO_TIMESTAMP('2025-08-18 20:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (607, 507, 101, 'You have received a payment of 120.00 USD from Derek Trotter.', TO_TIMESTAMP('2022-11-05 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (608, 508, 102, 'You have received a payment of 950.00 EUR from Harry Potter.', TO_TIMESTAMP('2023-04-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (609, 509, 109, 'You have received a payment of 200.00 EUR from Rodrigo Campos.', TO_TIMESTAMP('2023-05-26 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (610, 510, 105, 'You have received a payment of 300.00 LYD from Majid Ben Ghet.', TO_TIMESTAMP('2024-07-20 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (611,511, 109, 'You have received a payment of 50.00 EUR from Jimmy Page.', TO_TIMESTAMP('2023-04-25 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'N');

--- MESSAGEGROUP
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (701, 201, 101, 'Hello Family, welcome to the expenses group', TO_TIMESTAMP('2023-01-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (702, 202, 104, 'The trip is coming up soon, do not forget your passports', TO_TIMESTAMP('2023-02-22 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (703, 203, 105, 'Don''t forget the meeting tomorrow.', TO_TIMESTAMP('2023-03-12 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (704, 204, 101, 'Japan trip is coming up', TO_TIMESTAMP('2025-06-06 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (705, 205, 107, 'Can''t wait for London, what is on the itinerary?', TO_TIMESTAMP('2025-08-14 13:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (706, 206, 108, 'Friday night plans?', TO_TIMESTAMP('2022-11-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (707, 207, 109, 'Rent is due next week.', TO_TIMESTAMP('2023-04-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (708, 208, 110, 'Ski weekend is going to be fun!', TO_TIMESTAMP('2023-05-24 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (709, 209, 111, 'Gym session tomorrow?', TO_TIMESTAMP('2023-07-01 20:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (710, 210, 107, 'Summer trip planning!', TO_TIMESTAMP('2024-07-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));

--- MESSAGEPRIVATE
-- Note: MessagePrivateId and MessageTime are omitted as they are handled by the trigger
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (801,201, 101, 102, 'Hey Jimmy, can you pay me back ASAP?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (802,201, 102, 101, 'Hi Mohammed, payment for what?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (803,202, 103, 104, 'Mel here, ready for the trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (804,202, 104, 103, 'Diana, absolutely! Can''t wait!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (805,203, 105, 106, 'Clark here, did you get the invoice?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (806,203, 106, 105, 'Peter, almost done. Will send payment over soon.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (807,205, 107, 108, 'Majid here, are you joining the London trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (808,205, 108, 107, 'Derek, yes I am! Looking forward to it.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (809,208, 109, 110, 'Harry here, did you book the accommodation?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (810,208, 110, 109, 'Rodrigo, yes I did.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (811,202, 101, 111, 'Ana here, can you help me with the payment?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (812,202, 101, 111, 'Sure Ana, what do you need?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (813,201, 101, 102, 'Reminder: utilities bill is due tomorrow.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (814,201, 102, 103, 'Can you confirm the amount for the dinner?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (815,202, 104, 101, 'Packing list for the trip: don''t forget chargers.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (816,204, 101, 106, 'Have you arranged the transfer for the flight?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (817,205, 107, 108, 'Do you want to split the accommodation evenly?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (818,208, 110, 109, 'Did you renew the ski pass or should I handle it?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (819,210, 107, 105, 'Are you coming to the planning meeting next week?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (820,201, 103, 101, 'Thanks for covering my part, I''ll reimburse next week.', SYSTIMESTAMP);


--- Queries
-- 3.1 Obtain the average amount spent by each user in each group. The result must
--show the first name, last name, group name and average amount spent by the user in the
--group. Order the result in alphabetical ascending order by first name, last name and group
--name.
Select AU.FirstName, AU.LastName, AG.GroupName, 
	   AVG(P.Amount) AS AverageAmountSpent
From AppUser AU
Join Payment P ON AU.AppUserId = P.PayerId
Join AppGroup AG ON P.AppGroupId = AG.AppGroupId
Group By AU.FirstName, AU.LastName, AG.GroupName
Order By AU.FirstName ASC, AU.LastName ASC, AG.GroupName ASC;
-- 3.2 For each group and category obtain the average amount of the expenses for the
---    months of June, July, and August of the year 2025. The average value must be calculated
---    in the default currency of the group.
Select AG.GroupName, C.CategoryName, 
	   AVG(E.Amount * ER.Rate) AS AverageExpenseInBaseCurrency
From Expense E
Join AppGroup AG ON E.AppGroupId = AG.AppGroupId
Join Category C ON E.CategoryId = C.CategoryId
Join ExchangeRate ER ON E.CurrencyId = ER.CurrencyFrom 
					 AND AG.BaseCurrencyId = ER.CurrencyTo
					 AND ER.ExchangeDate = E.ExpenseDate 
Where EXTRACT(MONTH FROM E.ExpenseDate) IN (6, 7, 8)
  AND EXTRACT(YEAR FROM E.ExpenseDate) = 2025
group by g.GroupName, C.CategoryName;

---3.3
Select AU.FirstName, AU.lastName,
	COUNT(mg.MessageGroupId) AS GroupMessagesSent,
    COUNT(mp.MessagePrivateId) AS PrivateMessagesSent,
    (COUNT(mg.MessageGroupId) + COUNT(mp.MessagePrivateId)) AS TotalMessagesSent
From AppUser AU
Left Join MessageGroup mg ON AU.AppUserId = mg.SenderId
Left Join MessagePrivate mp ON AU.AppUserId = mp.SenderId
Group By AU.FirstName, AU.LastName
order by TotalMessagesSent DESC;

---3.4
Select AG.GroupName,AU,.FirstName, AU.LastName,P.Amount, P.PaymentDate,
	   AG.GroupName
From Payment P
Join AppGroup AG ON P.AppGroupId = AG.AppGroupId
Join AppUser AU ON P.PayerId = AU.AppUserId
Join AppUser AU2 ON P.PayeeId = AU2.AppUserId
where P.amount > (
	Select AVG(Amount)
	From Payment
	Where AppGroupId = AG.AppGroupId
)
group by AG.GroupName, AU.FirstName, AU.LastName, P.Amount, P.PaymentDate
order by AG.GroupName, P.Amount DESC;
---3.5
Select AU.Firstname, AU.LastName, AG.GroupName, MAX(E.Amount),MIN(E.Amount)
From Expense E
Join AppUser AU ON E.AppUserId = AU.AppUserId
Join AppGroup AG ON E.AppGroupId = AG.AppGroupId
Join Category C ON E.CategoryId = C.CategoryId
where C.CategoryName = 'Invoices'
group by AU.FirstName, AU.LastName, AG.GroupName
order by AU.FirstName, AU.LastName, AG.GroupName;
---3.6
select (AU.FirstName||' '|| AU.LastName), AG.GroupName,COUNT(N.NotificationId) AS UnreadNotifications
From AppUser AU
Join Notification N ON AU.AppUserId = N.RecipientId
Join Membership M ON AU.AppUserId = M.AppUserId
Join AppGroup AG ON M.AppGroupId = AG.AppGroupId
WHERE m.LeavingDate IS NULL
  AND m.MemberRole IN ('OWNER', 'ADMIN')
  AND n.IsRead = 'N'
group by AU.FirstName, AU.LastName, AG.GroupName
HAVING COUNT(N.NotificationId) > 0;


--- TRIGGERS
CREATE OR REPLACE TRIGGER check_balance_before_leaving
BEFORE UPDATE OF LeavingDate ON Membership
FOR EACH ROW
DECLARE
    v_balance NUMBER;
    v_expenses_created NUMBER;
    v_payments_received NUMBER;
    v_participations_owed NUMBER;
    v_payments_paid NUMBER;
BEGIN
    -- Only run this check if the user is being marked as having left
    IF :NEW.LeavingDate IS NOT NULL AND :OLD.LeavingDate IS NULL THEN
        
        -- 1. Get all money the user is OWED
        SELECT COALESCE(SUM(Amount), 0) 
        INTO v_expenses_created 
        FROM Expense 
        WHERE AppUserId = :OLD.AppUserId AND AppGroupId = :OLD.AppGroupId;
        
        SELECT COALESCE(SUM(Amount), 0) 
        INTO v_payments_received 
        FROM Payment 
        WHERE PayeeId = :OLD.AppUserId AND AppGroupId = :OLD.AppGroupId;

        -- 2. Get all money the user OWES
        SELECT COALESCE(SUM(Amount), 0) 
        INTO v_participations_owed 
        FROM ParticipationExpense 
        WHERE AppUserId = :OLD.AppUserId AND AppGroupId = :OLD.AppGroupId;

        SELECT COALESCE(SUM(Amount), 0) 
        INTO v_payments_paid 
        FROM Payment 
        WHERE PayerId = :OLD.AppUserId AND AppGroupId = :OLD.AppGroupId;

        -- 3. Calculate the final balance
        v_balance := (v_expenses_created + v_payments_received) - (v_participations_owed + v_payments_paid);

        -- 4. Check the balance
        IF v_balance != 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Member cannot leave group with a non-zero balance. Current balance is: ' || v_balance);
        END IF;
    END IF;
END;

---coalesce was used above to handle null values in case there are no expenses/payments/participations for the user so it returns 0 instead of null

--4.2.
CREATE TRIGGER MembershipCheck
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
	IF NOT EXISTS (
	SELECT 1
	FROM Membership m1
	JOIN Membership m2 ON m2.AppGroupId = m1.AppGroupId AND m1.AppUserId = :NEW.PayerId AND m2.AppUserId = :NEW.PayeeId
	HAVING m1.AppGroupId = m2.AppGroupId
	) THEN
		raise_application_error(-20001, 'Payer and payee do not belong to the same group.')
	END IF;
END;

--4.3 When sending a private message set automatically the message Id (as a
--sequence) and the message date (current date).
--- sequence for MessagePrivateId
Create sequence MessagePrivateSeq
START WITH 800
INCREMENT BY 1;
--- trigger for setting MessagePrivateId and MessageTime
Create OR REPLACE TRIGGER set_messageprivate_fields
Before Insert ON MessagePrivate
FOR EACH ROW
Begin
	:NEW.MessagePrivateId := MessagePrivateSeq.NEXTVAL;
	:NEW.MessageTime := SYSTIMESTAMP;
End;

--4.4 

CREATE TRIGGER ExchangeRateExists
BEFORE INSERT ON Payment
for each row
---When the 2 conditions are met we aise the error, if either one isn't met then all is good.
when (:new.CurrencyId != (SELECT BaseCurrencyId FROM AppGroup WHERE AppGroupId = :new.AppGroupId) 
      And (select count (*)
	from ExchangeRate
	where CurrencyFrom = :new.CurrencyId and CurrencyTo = (SELECT BaseCurrencyId FROM AppGroup WHERE AppGroupId = :new.AppGroupId)
	 and :new.PaymentDate!=ER.ExchangeDate ) = 0
	)
BEGIN
	raise_application_error(-20002, 'No exchange rate exists for the payment currency to the group base currency on the payment date.');
END;