CREATE DATABASE RetailTrack;
USE RetailTrack;

CREATE TABLE Users (
    userID VARCHAR(6) PRIMARY KEY,
    userName VARCHAR(25) NOT NULL UNIQUE ,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10) NOT NULL CHECK (role IN ('Admin', 'Manager', 'Cashier'))
);


CREATE TABLE Categories (
    categoryID VARCHAR(6) NOT NULL,
    categoryName VARCHAR(20) NOT NULL UNIQUE,

	PRIMARY KEY (categoryID)
);

CREATE TABLE Suppliers (
    supplierID VARCHAR(6) NOT NULL,
    supplierName VARCHAR(25) NOT NULL,
    phone VARCHAR(12),
    email VARCHAR(50),
    address VARCHAR(100),

	PRIMARY KEY (supplierID)
);

CREATE TABLE Items (
    itemID VARCHAR(6) NOT NULL,
    name VARCHAR(25) NOT NULL,
    categoryID VARCHAR(6) NOT NULL,
    supplierID VARCHAR(6) NOT NULL,
    price FLOAT NOT NULL default 0 CHECK (price >= 0) ,

	PRIMARY KEY (itemID),
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID) on DELETE CASCADE,
    FOREIGN KEY (supplierID) REFERENCES Suppliers(supplierID)
);

CREATE TABLE Inventory (
    inventoryID VARCHAR(6) NOT NULL,
    itemID VARCHAR(6) NOT NULL,
    quantity INT default 0,
	available INT default 0,
	 PRIMARY KEY (inventoryID),
    FOREIGN KEY (itemID) REFERENCES Items(itemID) ON DELETE CASCADE
);

CREATE TABLE Billing (
    billingID VARCHAR(6) NOT NULL,
    userID VARCHAR(6) NOT NULL,
    amount FLOAT NOT NULL CHECK (amount >= 0),
    date DATE NOT NULL DEFAULT CURRENT_DATE,

	PRIMARY KEY(billingID),
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE SET NULL
);


CREATE TABLE Reports (
    reportID INT NOT NULL ,
    type VARCHAR(20) NOT NULL,
    reportdate DATE NOT NULL DEFAULT CURRENT_DATE,
    generatedBy VARCHAR(6) NOT NULL,

    PRIMARY KEY (reportID),
    FOREIGN KEY (generatedBy) REFERENCES Users(userID) ON DELETE SET NULL
);
GO
GO
CREATE TRIGGER trg_before_insert_users
ON Users
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Users (userID, userName, password, role)
    SELECT 
        'US' + RIGHT('0000' + CAST(ISNULL((SELECT MAX(CAST(RIGHT(userID, 4) AS INT)) FROM Users), 1000) + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(4)), 4),
        i.userName, i.password, i.role
    FROM inserted i;
END;
