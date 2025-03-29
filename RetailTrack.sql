CREATE DATABASE RetailTrack;
USE RetailTrack;

CREATE TABLE Users_Info(
    userID INT IDENTITY(1001, 1),
    userName VARCHAR(25) NOT NULL UNIQUE,
	gender VARCHAR(10) NOT NULL CHECK (gender IN ('MALE', 'FEMALE')),
	age INT NOT NULL CHECK (age >= 18 AND age <=60),
	phone VARCHAR(12),
    email VARCHAR(50),
    address VARCHAR(100),

	PRIMARY KEY(userID)
);

CREATE TABLE Users_Login(
    userID INT,
    password VARCHAR(255) NOT NULL CHECK (password LIKE '%[A-Za-z]%' AND password LIKE '%[0-9]%'),
    role VARCHAR(10) NOT NULL CHECK (role IN ('Admin', 'Manager', 'Cashier')),

	PRIMARY KEY(userID),
	FOREIGN KEY (userID) REFERENCES Users_Info(userID)
);


CREATE TABLE Suppliers (
    supplierID INT IDENTITY(1001, 1),
    supplierName VARCHAR(25) NOT NULL,
    phone VARCHAR(12),
    email VARCHAR(50),
    address VARCHAR(100),

	PRIMARY KEY (supplierID)
);

CREATE TABLE Items (
    itemID INT IDENTITY(1001, 1),
    name VARCHAR(25) NOT NULL,
    price FLOAT NOT NULL default 0 CHECK (price >= 0),
	quality TEXT,

	PRIMARY KEY (itemID),
);

CREATE TABLE Delivery (
    deliveryID INT,
	itemID INT NOT NULL,
	supplierID INT NOT NULL,
	delivering_quantity INT NOT NULL,

	PRIMARY KEY (DeliveryID, itemID),
    FOREIGN KEY (itemID) REFERENCES items(itemID),
    FOREIGN KEY (supplierID) REFERENCES Suppliers(supplierID)
);


CREATE TABLE Stocks (
    --StocksID INT IDENTITY(1001, 1),
    itemID INT NOT NULL,
    Ttotal_quantity INT default 0,
	Last_Updated DATETIME DEFAULT GETDATE(),

	PRIMARY KEY (itemID),
    FOREIGN KEY (itemID) REFERENCES Items(itemID)
);


CREATE TABLE Billing (
	billingID INT NOT NULL,
	itemID INT NOT NULL,
    userID INT NOT NULL,
    amount FLOAT NOT NULL CHECK (amount >= 0),
    date DATE NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(billingID),
    FOREIGN KEY (userID) REFERENCES Users_Info(userID)
);


CREATE TABLE Reports (
    reportID INT NOT NULL ,
    type VARCHAR(20) NOT NULL,
    reportdate DATE NOT NULL DEFAULT GETDATE(),
    generatedBy INT NOT NULL,

    PRIMARY KEY (reportID),
    FOREIGN KEY (generatedBy) REFERENCES Users_Info(userID)
);

---------------------------------------TRYING TRIGGERS-------------------------

GO
CREATE TRIGGER Assigning_users
ON Users
AFTER INSERT
AS
BEGIN
	INSERT INTO Users (userID, userName, password, role)
    SELECT 'US' + RIGHT('0000' + CAST(ISNULL((SELECT MAX(CAST(RIGHT(userID, 4) AS INT)) FROM Users), 1000) + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(4)), 4),inserted.userName, inserted.password, inserted.role
    FROM inserted;
END;





GO
CREATE TRIGGER Manage_Stocks
ON Stocks
AFTER INSERT
AS
BEGIN
	

END;

-----------------------------------insertion-----------------------------------

-- Inserting into Users_Info
INSERT INTO Users_Info (userName, gender, age, phone, email, address)
VALUES 
('JohnDoe', 'MALE', 30, '9876543210', 'johndoe@email.com', '123 Main St'),
('JaneSmith', 'FEMALE', 25, '8765432109', 'janesmith@email.com', '456 Elm St'),
('MikeBrown', 'MALE', 40, '7654321098', 'mikebrown@email.com', '789 Oak St');

-- Inserting into Users_Login
INSERT INTO Users_Login (userID, password, role)
VALUES 
(1001, 'Pass1234', 'Admin'),
(1002, 'Secure5678', 'Manager'),
(1003, 'Safe0001', 'Cashier');

-- Inserting into Suppliers
INSERT INTO Suppliers (supplierName, phone, email, address)
VALUES 
('ABC Supplies', '1234567890', 'abc@supply.com', '101 Market St'),
('XYZ Traders', '2345678901', 'xyz@traders.com', '202 Commerce Rd'),
('Global Goods', '3456789012', 'global@goods.com', '303 Business Ave');

-- Inserting into Items
INSERT INTO Items (name, price, quality)
VALUES 
('Racket', 5000, 'High'),
('Shuttle', 350, 'Medium'),
('Net', 1000, 'High');

-- Inserting into Delivery
INSERT INTO Delivery (deliveryID, itemID, supplierID, delivering_quantity)
VALUES 
(1001, 1001, 1001, 20),
(1001, 1002, 1002, 50),
(1001, 1003, 1003, 30);

-- Inserting into Stocks
INSERT INTO Stocks (itemID, Ttotal_quantity)
VALUES 
(1001, 100),
(1002, 200),
(1003, 15);

-- Inserting into Billing
INSERT INTO Billing (billingID, itemID, userID, amount, date)
VALUES 
(1001, 1001, 1001, 800.50, GETDATE()),
(1001, 1002, 1002, 500.99, GETDATE()),
(1001, 1003, 1003, 150.75, GETDATE());

-- Inserting into Reports
INSERT INTO Reports (reportID, type, reportdate, generatedBy)
VALUES 
(1001, 'Sales', GETDATE(), 1001),
(1001, 'Inventory', GETDATE(), 1002),
(1002, 'Delivery', GETDATE(), 1003);



------------------------------------SELECT ALL---------------------------------


SELECT * FROM Users_Info;
SELECT * FROM Users_Login;
SELECT * FROM Suppliers;
SELECT * FROM Items;
SELECT * FROM Delivery;
SELECT * FROM Stocks;
SELECT * FROM Billing;
SELECT * FROM Reports;


------------------------------------DROP ALL---------------------------------

DROP TABLE Reports;
DROP TABLE Billing;
DROP TABLE Stocks;
DROP TABLE Delivery;
DROP TABLE Items;
DROP TABLE Suppliers;
DROP TABLE Users_Login;
DROP TABLE Users_Info;