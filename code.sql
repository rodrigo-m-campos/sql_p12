--Create the tables
CREATE TABLE AppUser (
	AppUserId NUMBER NOT NULL,
	FirstName VARCHAR2(30) NOT NULL,
	LastName VARCHAR2(30) NOT NULL,
	'Alias' VARCHAR2(30),
	Phone VARCHAR2(30),
	constraint AppUser_PK PRIMARY KEY (AppUserId));
-- Test once more
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
	DivisionType VARCHAR2(30) NOT NULL DEFAULT ('Equal'),
	CategoryId NUMBER NOT NULL,
	constraint Expense_PK PRIMARY KEY (ExpenseId)
	constraint CH_Division CHECK (DivisionType IN ('Equal', 'Shared', 'Exact')));

CREATE TABLE ParticipationExpense (
	ExpenseId NUMBER NOT NULL,
	AppUserId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	Amount NUMBER(10,2) NOT NULL,
	constraint ParticipationExpense_PK PRIMARY KEY (ExpenseId, AppUserId, AppGroupId));

CREATE TABLE 'Category' (
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
	Rate NUMBER(10,2),
	constraint ExchangeRate_PK PRIMARY KEY (RateId));

CREATE TABLE Payment (
	PaymentId NUMBER NOT NULL,
	PayerId NUMBER NOT NULL,
	PayeeId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	Amount NUMBER(10,2) NOT NULL,
	CurrencyId NUMBER NOT NULL,
	PaymentDate DATE NOT NULL,
	Note VARCHAR2(30),
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

ALTER TABLE Expense ADD CONSTRAINT Expense_fk0 FOREIGN KEY (AppUserId, AppGroupId) REFERENCES Membership(AppUserId, AppGroupId);
--ALTER TABLE Expense ADD CONSTRAINT Expense_fk1 FOREIGN KEY (AppGroupId) REFERENCES Membership(AppGroupId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk2 FOREIGN KEY (CurrencyId) REFERENCES Currency(CurrencyId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk3 FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId);

ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk0 FOREIGN KEY (AppUserId, AppGroupId) REFERENCES Membership(AppUserId, AppGroupId);
--ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk1 FOREIGN KEY (AppGroupId) REFERENCES Membership(AppGroupId);
ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk2 FOREIGN KEY (ExpenseId) REFERENCES Expense(ExpenseId);

ALTER TABLE 'Category' ADD CONSTRAINT Category_fk0 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);

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
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (1, 1, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.10);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (2, 2, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.91);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (3, 1, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.85);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (4, 3, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.18);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (5, 1, 4, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 4.95);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (6, 4, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.20);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (7, 1, 5, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 3.30);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (8, 5, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.30);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (9, 1, 6, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 145.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (10, 6, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.0069);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (11, 1, 7, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 7.50);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (12, 7, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.13);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (13, 1, 8, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 90.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (14, 8, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.011);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (15, 1, 9, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.60);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (16, 9, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.62);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (17, 1, 10, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.45);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (18, 10, 1, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.69);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (19, 2, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.77);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (20, 3, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.30);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (21, 2, 4, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 4.50);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (22, 4, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.22);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (23, 2, 5, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 3.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (24, 5, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.33);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (25, 2, 6, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 132.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (26, 6, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.0076);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (27, 2, 7, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 6.80);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (28, 7, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.15);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (29, 2, 8, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 82.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (30, 8, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.012);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (31, 2, 9, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.45);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (32, 9, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.69);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (33, 2, 10, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.30);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (34, 10, 2, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.77);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (35, 3, 4, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 5.80);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (36, 4, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.17);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (37, 3, 5, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 3.90);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (38, 5, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.26);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (39, 3, 6, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 155.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (40, 6, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.0065);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (41, 3, 7, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 8.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (42, 7, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.13);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (43, 3, 8, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 95.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (44, 8, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.011);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (45, 3, 9, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.70);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (46, 9, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.59);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (47, 3, 10, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 1.50);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (48, 10, 3, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 0.67);
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
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (301, 201, 'Groceries');
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (302, 201, 'Utilities');
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (303, 201, 'Rent');
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (304, 202, 'Travel');
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (305, 202, 'Dining');
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (306, 202, 'Entertainment');
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (307, 203, 'Office Supplies');
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (308, 203, 'Client Entertainment');
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (309, 204, 'Flights');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (310, 204, 'Accommodation');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (311, 204, 'Food');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (312, 205, 'Flights');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (313, 205, 'Accommodation');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (314, 205, 'Food');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (315,206, 'Dining');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (316,206, 'Entertainment');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (317,207, 'Rent');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (318,207, 'Utilities');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (319,208, 'Ski Passes');			
INSERT INTO 'Category' (CategoryId, AppGroupId, CategoryName) VALUES (320,208, 'Accommodation');
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
---PARTICIPATIONEXPENSE (ORDERED BY EXPENSEID)
-- Expense 401 (150.00 EUR / Group 201)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 101, 201, 50.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 102, 201, 50.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 103, 201, 50.00);
-- Expense 402 (75.00 EUR / Group 201) - Corrected to 18.75 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 101, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 102, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 103, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 104, 201, 18.75);
-- Expense 403 (1200.00 EUR / Group 201)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (403, 103, 201, 1200.00);
-- Expense 404 (300.00 EUR / Group 202) - Corrected to 75.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 101, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 102, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 103, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 104, 202, 75.00);
-- Expense 405 (200.00 EUR / Group 203) - Corrected to 200.00 for the only participant
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (405, 105, 203, 200.00);
-- Expense 406 (800.00 JPY / Group 204) - Missing, added as 400.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (406, 101, 204, 400.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (406, 106, 204, 400.00);
-- Expense 407 (600.00 GBP / Group 205) - Missing, added as 300.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (407, 107, 205, 300.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (407, 108, 205, 300.00);
-- Expense 408 (120.00 USD / Group 206) - Missing, added as 120.00 for the only active member
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (408, 108, 206, 120.00);
-- Expense 409 (950.00 EUR / Group 207) - Missing, added as 950.00 for the only active member
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (409, 109, 207, 950.00);
-- Expense 410 (400.00 EUR / Group 208) - Missing, added as 200.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (410, 109, 208, 200.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (410, 110, 208, 200.00);
---PAYMENT
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (501, 101, 102, 201, 75.00, 1, TO_DATE('2023-01-22','YYYY-MM-DD'), 'Reimbursement for utilities');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (502, 103, 101, 201, 400.00, 1, TO_DATE('2023-02-05','YYYY-MM-DD'), 'Rent payment');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (503, 104, 102, 202, 150.00, 1, TO_DATE('2023-02-25','YYYY-MM-DD'), 'Trip expenses');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (504, 105, 101, 203, 200.00, 1, TO_DATE('2023-03-15','YYYY-MM-DD'), 'Office supplies reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (505, 107, 101, 204, 400.00, 6, TO_DATE('2025-06-10','YYYY-MM-DD'), 'Flight reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (506, 108, 107, 205, 300.00, 3, TO_DATE('2025-08-18','YYYY-MM-DD'), 'Accommodation reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (507, 108, 108, 206, 120.00, 2, TO_DATE('2022-11-05','YYYY-MM-DD'), 'Dinner reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (508, 109, 109, 207, 950.00, 1, TO_DATE('2023-04-22','YYYY-MM-DD'), 'Rent payment');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (509, 110, 109, 208, 200.00, 1, TO_DATE('2023-05-26','YYYY-MM-DD'), 'Ski pass reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (510, 107, 105, 210, 300.00, 4, TO_DATE('2024-07-20','YYYY-MM-DD'), 'Travel expenses reimbursement');
---NOTIFICATION
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (601, 501, 102, 'You have received a payment of 75.00 EUR from Mohammed Smith.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (602, 502, 101, 'You have received a payment of 400.00 EUR from Mel Gibson.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (603, 503, 102, 'You have received a payment of 150.00 EUR from Diana Prince.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (604, 504, 101, 'You have received a payment of 200.00 EUR from Clark Kent.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (605, 505, 101, 'You have received a payment of 400.00 JPY from Majid Ben Ghet.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (606, 506, 107, 'You have received a payment of 300.00 GBP from Derek Trotter.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (607, 507, 108, 'You have received a payment of 120.00 USD from Derek Trotter.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (608, 508, 109, 'You have received a payment of 950.00 EUR from Harry Potter.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (609, 509, 109, 'You have received a payment of 200.00 EUR from Rodrigo Campos.', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (610, 510, 105, 'You have received a payment of 300.00 LYD from Majid Ben Ghet.', SYSTIMESTAMP, 'N');
---MESSAGEGROUP
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (701, 201, 101, 'Hello Family, welcome to the expenses group', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (702, 202, 104, 'The trip is coming up soon, do not forget your pssports', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (703, 203, 105, 'Don''t forget the meeting tomorrow.', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (704, 204, 101, 'Japan trip is coming up', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (705, 205, 107, 'Can''t wait for London, what is on the itinerary?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (706, 206, 108, 'Friday night plans?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (707, 207, 109, 'Rent is due next week.', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (708, 208, 110, 'Ski weekend is going to be fun!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (709, 209, 111, 'Gym session tomorrow?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (710, 210, 107, 'Summer trip planning!', SYSTIMESTAMP);
--MESSAGEPRIVATE
--Add AppGroupId
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (801, 101, 102, 'Hey Jimmy, can you pay me back ASAP?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (802, 102, 101, 'Hi Mohammed, I am good thank You.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (803, 103, 104, 'Mel here, ready for the trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (804, 104, 103, 'Diana, absolutely! Can''t wait!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (805, 105, 106, 'Clark here, did you make the payment?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (806, 106, 105, 'Peter, almost done. Will send it over soon.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (807, 107, 108, 'Majid here, are you joining the Japan trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (808, 108, 107, 'Derek, yes I am! Looking forward to it.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (809, 109, 110, 'Harry here, did you book the accommodation?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (810, 110, 109, 'Rodrigo, yes I did.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (811, 111, 101, 'Ana here, can you help me with the payment?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (812, 101, 111, 'Sure Ana, what do you need?', SYSTIMESTAMP);

--Queries 
--1. Average of payment by user by group ordered alphabetically
SELECT AppUser.FirstName,AppUser.LastName, AppGroup.GroupName, AVG(Amount) AS AveragePayment
from Payment
Join AppUser ON Payment.PayerId = AppUser.AppUserId
left Join AppGroup ON Payment.AppGroupId = AppGroup.AppGroupId
group by FirstName,LastName, GroupName
ORDER BY AppUser.FirstName, AppUser.LastName, AppGroup.GroupName;
--3. Retrieve the total number of group messages, the total number of private
--messages, and the overall total of all messages sent by each user. List the first name and
--the last name of the users, and order the overall total of messages sent in descending
--order
SELECT AppUser.FirstName, AppUser.LastName, 
		(SELECT COUNT(*) 
		 FROM MessageGroup 
		 WHERE MessageGroup.SenderId = AppUser.AppUserId) AS TotalGroupMessages,
		(SELECT COUNT(*) MessagePrivate.senderID=AppUser.AppUserId
		 FROM MessagePrivate 
		 WHERE MessagePrivate.SenderId = AppUser.AppUserId) AS TotalPrivateMessages,
		((SELECT COUNT(*) 
		 FROM MessageGroup 
		 WHERE MessageGroup.SenderId = AppUser.AppUserId) +
		 (SELECT COUNT(*) 
		 FROM MessagePrivate 
		 WHERE MessagePrivate.SenderId = AppUser.AppUserId)) AS OverallTotalMessages
		from AppUser
		WHERE OverallTotalMessages > 0
		 Order By OverallTotalMessages DESC 
