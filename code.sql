--Create the tables
--FUCK U RODRIGO
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
	Amount NUMBER(2) NOT NULL,
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
	Amount NUMBER(2) NOT NULL,
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
