--SUBWAY DATABASE TABLES

CREATE TABLE LINE (
	Colour VARCHAR2(30) NOT NULL,
	Lname VARCHAR2(30) UNIQUE NOT NULL,
	constraint LINE_PK PRIMARY KEY (Colour));



CREATE TABLE STATION (
	Sname VARCHAR2(30) NOT NULL,
	Accessible CHAR(1) NOT NULL,
	Cercanias CHAR(1) NOT NULL,
	constraint STATION_PK PRIMARY KEY (Sname));



CREATE TABLE BE_COMPOUND_OF (
	Line VARCHAR2(30) NOT NULL,
	Station VARCHAR2(30) NOT NULL,
	"Order" INT NOT NULL,
	constraint BE_COMPOUND_OF_PK PRIMARY KEY (Line,Station));



CREATE TABLE "ACCESS" (
	Code INT NOT NULL,
	Aname VARCHAR2(30) NOT NULL,
	Belongs_to VARCHAR2(30) NOT NULL,
	constraint ACCESS_PK PRIMARY KEY (Code));



CREATE TABLE TRAIN (
	Tcode VARCHAR2(10) NOT NULL,
	Model VARCHAR2(50) NOT NULL,
	Age DATE NOT NULL,
	Run_on VARCHAR2(30) NOT NULL,
	Park_at VARCHAR2(10) NOT NULL,
	constraint TRAIN_PK PRIMARY KEY (Tcode));



CREATE TABLE GARAGE (
	Gcode VARCHAR2(10) NOT NULL,
	Address VARCHAR2(50) NOT NULL,
	Capacity NUMBER NOT NULL,
	Assigned_to VARCHAR2(30) NOT NULL,
	constraint GARAGE_PK PRIMARY KEY (Gcode));


ALTER TABLE BE_COMPOUND_OF ADD CONSTRAINT BE_COMPOUND_OF_fk0 FOREIGN KEY (Line) REFERENCES LINE(Colour);
ALTER TABLE BE_COMPOUND_OF ADD CONSTRAINT BE_COMPOUND_OF_fk1 FOREIGN KEY (Station) REFERENCES STATION(Sname);

ALTER TABLE "ACCESS" ADD CONSTRAINT ACCESS_fk0 FOREIGN KEY (Belongs_to) REFERENCES STATION(Sname);

ALTER TABLE TRAIN ADD CONSTRAINT TRAIN_fk0 FOREIGN KEY (Run_on) REFERENCES LINE(Colour);
ALTER TABLE TRAIN ADD CONSTRAINT TRAIN_fk1 FOREIGN KEY (Park_at) REFERENCES GARAGE(Gcode);

ALTER TABLE GARAGE ADD CONSTRAINT GARAGE_fk0 FOREIGN KEY (Assigned_to) REFERENCES STATION(Sname);


--DROPs TABLES

DROP TABLE LINE CASCADE CONSTRAINTS;
DROP TABLE STATION CASCADE CONSTRAINTS;
DROP TABLE BE_COMPOUND_OF CASCADE CONSTRAINTS;
DROP TABLE "ACCESS" CASCADE CONSTRAINTS;
DROP TABLE TRAIN CASCADE CONSTRAINTS;
DROP TABLE GARAGE CASCADE CONSTRAINTS;

-- INSERTIONS
--Lines

insert into LINE values('green', '5');
insert into LINE values('red', '2');
insert into LINE values('blue', '1');
insert into LINE values('brown', '4');
insert into LINE values('yellow', '3');

--Stations
--brown
insert into STATION values('San Bernardo', 'Y', 'N');
insert into STATION values('Alonso Martinez', 'N', 'N');
insert into STATION values('Colon', 'Y', 'N');
insert into STATION values('Velazquez', 'Y', 'N');
insert into STATION values('Serrano', 'N', 'N');

--red
insert into STATION values('Cuatro Caminos', 'Y', 'Y');
insert into STATION values('Noviciado', 'N', 'N');
insert into STATION values('Canal', 'Y', 'N');
insert into STATION values('Quevedo', 'Y', 'N');
insert into STATION values('Opera', 'Y', 'N');
insert into STATION values('Sol', 'Y', 'N');

--blue
insert into STATION values('Chamartin', 'Y', 'Y');
insert into STATION values('Plaza Castilla', 'Y', 'N');
insert into STATION values('Bilbao', 'Y', 'N');
insert into STATION values('Tribunal', 'Y', 'N');
insert into STATION values('Gran Via', 'N', 'N');

--green

insert into STATION values('Casa de Campo', 'Y', 'N');
insert into STATION values('Puerta Toledo', 'Y', 'N');
insert into STATION values('Callao', 'Y', 'N');


--yellow
insert into STATION values('Moncloa', 'Y', 'N');
insert into STATION values('Plaza España', 'Y', 'Y');
insert into STATION values('Legazpi', 'Y', 'N');


--Be_Compound_of


insert into BE_COMPOUND_OF values('green', 'Casa de Campo', 1);
insert into BE_COMPOUND_OF values('green', 'Puerta Toledo', 11);
insert into BE_COMPOUND_OF values('green', 'Callao', 13);
insert into BE_COMPOUND_OF values('green', 'Alonso Martinez', 16);
insert into BE_COMPOUND_OF values('green', 'Opera', 12);
insert into BE_COMPOUND_OF values('green', 'Gran Via', 14);


insert into BE_COMPOUND_OF values('yellow', 'Moncloa', 1);
insert into BE_COMPOUND_OF values('yellow', 'Plaza España', 4);
insert into BE_COMPOUND_OF values('yellow', 'Legazpi', 11);
insert into BE_COMPOUND_OF values('yellow', 'Sol', 6);
insert into BE_COMPOUND_OF values('yellow', 'Callao', 5);

insert into BE_COMPOUND_OF values('brown', 'San Bernardo', 2);
insert into BE_COMPOUND_OF values('brown', 'Alonso Martinez', 4);
insert into BE_COMPOUND_OF values('brown', 'Colon', 5);
insert into BE_COMPOUND_OF values('brown', 'Velazquez', 6);
insert into BE_COMPOUND_OF values('brown', 'Serrano', 7);
insert into BE_COMPOUND_OF values('brown', 'Bilbao', 3);


insert into BE_COMPOUND_OF values('red', 'Cuatro Caminos', 1);
insert into BE_COMPOUND_OF values('red', 'Canal', 2);
insert into BE_COMPOUND_OF values('red', 'Quevedo', 3);
insert into BE_COMPOUND_OF values('red', 'Opera', 6);
insert into BE_COMPOUND_OF values('red', 'Sol', 7);
insert into BE_COMPOUND_OF values('red', 'Noviciado', 5);
insert into BE_COMPOUND_OF values('red', 'San Bernardo', 4);

insert into BE_COMPOUND_OF values('blue', 'Chamartin', 3);
insert into BE_COMPOUND_OF values('blue', 'Plaza Castilla', 4);
insert into BE_COMPOUND_OF values('blue', 'Bilbao', 11);
insert into BE_COMPOUND_OF values('blue', 'Tribunal', 12);
insert into BE_COMPOUND_OF values('blue', 'Gran Via', 13);
insert into BE_COMPOUND_OF values('blue', 'Cuatro Caminos', 9);
insert into BE_COMPOUND_OF values('blue', 'Sol', 14);

insert into GARAGE values('G1', 'Centro', 1000, 'Gran Via');
insert into GARAGE values('G2', 'Norte', 2000, 'Chamartin');
insert into GARAGE values('G3', 'Sur', 1000, 'Casa de Campo');

insert into TRAIN values('TR100', 'Model1', to_date('03/29/2000', 'mm/dd/yyyy'), 'green', 'G1');
insert into TRAIN values('TR200', 'Model2', to_date('11/01/2010', 'mm/dd/yyyy'), 'blue', 'G2');
insert into TRAIN values('TR300', 'Model1', to_date('03/01/1999', 'mm/dd/yyyy'), 'red', 'G1');
insert into TRAIN values('TR400', 'Model1', to_date('02/10/1999', 'mm/dd/yyyy'), 'brown', 'G2');

insert into "ACCESS" values(1, 'Calle Carretas', 'Sol');
insert into "ACCESS" values(2, 'Calle Alcala', 'Sol');
insert into "ACCESS" values(3, 'Calle Preciados', 'Sol');

--Queries

-- 7.1 What are the name of stations of 'red' line?
SELECT Station
FROM BE_COMPOUND_OF
WHERE Line = 'red';

--7.2 Find the number of stations per line
SELECT COUNT(*), Line_id
FROM BE_COMPOUND_OF
GROUP BY Line;

--7.3 Order the stations by the number of connections in the metro network
SELECT Station, COUNT(*)
FROM BE_COMPOUND_OF
GROUP BY Station
ORDER BY COUNT(*);

--Some other things
--We can rename the attribute in the output using 'as':
SELECT COLOUR, LNAME as LineName FROM LINE WHERE colour='blue' OR LNAME='5'
