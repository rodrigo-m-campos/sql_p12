--Create the tables
CREATE TABLE AppUser (
	AppUserId NUMBER NOT NULL,
	FirstName VARCHAR2(30) NOT NULL,
	LastName VARCHAR2(30) NOT NULL,
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
	Amount NUMBER(10,2) NOT NULL,
	CurrencyId NUMBER NOT NULL,
	ExpenseDate DATE NOT NULL,
	RegistrationDate DATE NOT NULL,
	DivisionType VARCHAR2(30) NOT NULL DEFAULT Equal CHECK (DivisionType IN ('Equal', 'Shared', 'Exact')),
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
	CurrencyId NUMBER NOT NULL,
	CurrencyName VARCHAR(30) NOT NULL,
	constraint Currency_PK PRIMARY KEY (CurrencyId));

CREATE TABLE ExchangeRate (
	RateId NUMBER NOT NULL,
	CurrencyFrom NUMBER NOT NULL,
	CurrencyTo NUMBER NOT NULL,
	ExchangeDate DATE NOT NULL,
	--Here we should determine decimals (or try a different solution)
	Rate NUMBER(2)
	constraint ExchangeRate_PK PRIMARY KEY (RateId));

CREATE TABLE Payment (
	PaymentId NUMBER NOT NULL,
	PayerId NUMBER NOT NULL,
	PayeeId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	Amount NUMBER(2) NOT NULL,
	CurrencyId NUMBER NOT NULL,
	PaymentDate DATE NOT NULL,
	Note VARCHAR2(30),
	constraint Payment_PK PRIMARY KEY (PaymentId));

CREATE TABLE Notification (
	NotificationId NUMBER NOT NULL,
	PaymentId NUMBER NOT NULL,
	RecipientId NUMBER NOT NULL,
	NotificationText VARCHAR2(30) NOT NULL,
	NotificationTime TIMESTAMP NOT NULL,
	IsRead CHAR(1) NOT NULL CHECK (IsRead IN ('Y', 'N')),
	constraint Notification_PK PRIMARY KEY (NotificationId))

CREATE TABLE MessageGroup (
	MessageGroupId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	SenderId NUMBER NOT NULL,
	MessageText VARCHAR2(30) NOT NULL,
	MessageTime TIMESTAMP NOT NULL,
	constraint MessageGroup_PK PRIMARY KEY (MessageGroupId))

CREATE TABLE MessagePrivate (
	MessagePrivateId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	SenderId NUMBER NOT NULL,
	RecipientId NUMBER NOT NULL,
	MessageText VARCHAR2(30) NOT NULL,
	MessageTime TIMESTAMP NOT NULL,
	constraint MessagePrivate_PK PRIMARY KEY (MessagePrivateId))


--Add foreign keys
ALTER TABLE AppGroup ADD CONSTRAINT AppGroup_fk0 FOREIGN KEY (BaseCurrencyId) REFERENCES Currency(CurrencyId);

ALTER TABLE Membership ADD CONSTRAINT Membership_fk0 FOREIGN KEY (AppUserId) REFERENCES AppUser(AppUserId);
ALTER TABLE Membership ADD CONSTRAINT Membership_fk1 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);

ALTER TABLE Expense ADD CONSTRAINT Expense_fk0 FOREIGN KEY (AppUserId) REFERENCES Membership(AppUserId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk1 FOREIGN KEY (AppGroupId) REFERENCES Membership(AppGroupId);
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

--INSERTIONS
--CURRENCY
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (1, 'EUR');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (2, 'USD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (3, 'GBP');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (4, 'LYD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (5, 'TND');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (6, 'JPY');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (7, 'CNY');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (8, 'INR');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (9, 'AUD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (10, 'CAD');
--EXCHANGERATE
--APPUSER
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (101, 'Mohammed', 'Smith', 'MO', '+34 637-1231236');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (102, 'Jimmy', 'Page',NULL, '+34 644-0046462');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (103, 'Mel', 'Gibson',NULL, '+34 666-5552555');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (104, 'Diana', 'Prince', 'Wonder Woman', '+1 (222) 555-1004');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (105, 'Clark', 'Kent', 'Superman', '619-1005');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (106, 'Peter', 'Parker', 'Spider-Man', '+1 (407) 224-1783');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (107, 'Majid', 'Ben Ghet',Null, '+218 091-3496121');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (108, 'Derek', 'Trotter', 'Del', '+44 016-1008');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (109, 'Harry', 'Potter',Null, '+44 619-1009100');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (110, 'Rodrigo', 'Campos', 'Milton', '+34 631-1010201');
INSERT INTO AppUser (AppUserId, FirstName, LastName, Alias, Phone) VALUES (111, 'Ana', 'García',Null, '+34 644-1011121');
---APPGROUP
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (201, 'Family', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'Family expenses', 1);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (202, 'Friends', TO_DATE('2023-02-20', 'YYYY-MM-DD'), 'Friends trips and outings', 1);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (203, 'Work', TO_DATE('2023-03-10', 'YYYY-MM-DD'), 'Work-related expenses', 1);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (204, 'JAPAN2025', TO_DATE('2025-06-05', 'YYYY-MM-DD'), 'Travel Expenses', 6);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (205, 'London trip', TO_DATE('2025-08-12', 'YYYY-MM-DD'), 'Travel Expenses', 3);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (206, 'Friday nights out', TO_DATE('2022-11-01', 'YYYY-MM-DD'), 'Weekly outings', 2);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (207, 'Rent', TO_DATE('2023-04-18', 'YYYY-MM-DD'), 'rent and other household expenses', 1);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (208, 'Ski weekend', TO_DATE('2023-05-22', 'YYYY-MM-DD'), NULL, 1);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (209, 'Gym buddies', TO_DATE('2023-06-30', 'YYYY-MM-DD'), 'Shared fitness expenses', 3);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (210, 'Summer In North Africa', TO_DATE('2024-07-14', 'YYYY-MM-DD'), 'Travel expenses', 4);	
---MEMBERSHIP
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (101, 201, TO_DATE('2023-01-15','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (102, 201, TO_DATE('2023-01-20','YYYY-MM-DD'), 'Admin', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (103, 201, TO_DATE('2023-02-01','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (104, 202, TO_DATE('2023-02-21','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (105, 203, TO_DATE('2023-03-11','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (106, 204, TO_DATE('2025-06-06','YYYY-MM-DD'), 'Member', TO_DATE('2025-06-25','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (101, 204, TO_DATE('2025-06-05','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (107, 205, TO_DATE('2025-08-13','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (108, 205, TO_DATE('2025-08-14','YYYY-MM-DD'), 'Member', TO_DATE('2025-08-20','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (108, 206, TO_DATE('2022-11-02','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (109, 207, TO_DATE('2023-04-19','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (110, 208, TO_DATE('2023-05-23','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (109, 208, TO_DATE('2023-05-23','YYYY-MM-DD'), 'Admin', TO_DATE('2023-05-27','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (111, 209, TO_DATE('2023-07-01','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (105, 210, TO_DATE('2024-07-15','YYYY-MM-DD'), 'Member', TO_DATE('2025-04-01','YYYY-MM-DD')); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (107, 210, TO_DATE('2024-07-16','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (101, 202, TO_DATE('2023-03-01','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (102, 202, TO_DATE('2023-03-05','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (103, 202, TO_DATE('2023-03-10','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (104, 201, TO_DATE('2023-02-25','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (106, 202, TO_DATE('2023-03-15','YYYY-MM-DD'), 'Member', NULL);
---CATEGORY
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
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (315,206, 'Dining');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (316,206, 'Entertainment');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (317,207, 'Rent');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (318,207, 'Utilities');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (319,208, 'Ski Passes');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (320,208, 'Accommodation');
---EXPENSE
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (401, 101, 201, 150.00, 1, TO_DATE('2023-01-16','YYYY-MM-DD'), TO_DATE('2023-01-16','YYYY-MM-DD'), 'Equal', 301);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (402, 102, 201, 75.00, 1, TO_DATE('2023-01-21','YYYY-MM-DD'), TO_DATE('2023-01-21','YYYY-MM-DD'), 'Shared', 302);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (403, 103, 201, 1200.00, 1, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-02-02','YYYY-MM-DD'), 'Exact', 303);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (404, 104, 202, 300.00, 1, TO_DATE('2023-02-22','YYYY-MM-DD'), TO_DATE('2023-02-22','YYYY-MM-DD'), 'Equal', 304);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (405, 105, 203, 200.00, 1, TO_DATE('2023-03-12','YYYY-MM-DD'), TO_DATE('2023-03-12','YYYY-MM-DD'), 'Shared', 307);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (406, 101, 204, 800.00, 6, TO_DATE('2025-06-07','YYYY-MM-DD'), TO_DATE('2025-06-07','YYYY-MM-DD'), 'Equal', 309);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (407, 107, 205, 600.00, 3, TO_DATE('2025-08-15','YYYY-MM-DD'), TO_DATE('2025-08-15','YYYY-MM-DD'), 'Shared', 312);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (408, 108, 206, 120.00, 2, TO_DATE('2022-11-03','YYYY-MM-DD'), TO_DATE('2022-11-03','YYYY-MM-DD'), 'Equal', 315);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (409, 109, 207, 950.00, 1, TO_DATE('2023-04-20','YYYY-MM-DD'), TO_DATE('2023-04-20','YYYY-MM-DD'), 'Exact', 317);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (410, 110, 208, 400.00, 1, TO_DATE('2023-05-24','YYYY-MM-DD'), TO_DATE('2023-05-24','YYYY-MM-DD'), 'Shared', 319);