CREATE DATABASE RetailTrack;
USE RetailTrack;

CREATE TABLE Users (
    userID VARCHAR(6)  NOT NULL ,
    userName VARCHAR(25) NOT NULL UNIQUE ,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10)  NOT NULL CHECK IN(' Admin',' Manager', 'Cashier')

	PRIMARY KEY (userID)
);

CREATE TABLE Categories (
    categoryID VARCHAR(6) NOT NULL,
    categoryName VARCHAR(20) NOT NULL UNIQUE,

	PRIMARY KEY (categoryID)
);

CREATE TABLE Suppliers (
    supplierID VARCHAR(6) NOT NULL,
    supplierName VARCHAR(25) ) NOT NULL,
    phone VARCHAR(12),
    email VARCHAR(50),
    address VARCHAR(100),

	PRIMARY KEY (supplierID)
);

CREATE TABLE Items (
    itemID VARCHAR(6)) NOT NULL,
    name VARCHAR(25)) NOT NULL,
    categoryID VARCHAR(6) ) NOT NULL,
    supplierID VARCHAR(6)) NOT NULL,
    price FLOAT  NOT NULL CHECK(price > 0) ,

	PRIMARY KEY (itemID),
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID) on DELETE CASCADE,
    FOREIGN KEY (supplierID) REFERENCES Suppliers(supplierID)
);

CREATE TABLE Inventory (
    inventoryID VARCHAR(6) ) NOT NULL,
    itemID VARCHAR(6)) NOT NULL,
    quantity INT,
	available INT,

	PRIMARY KEY (inventoryID),
    FOREIGN KEY (itemID) REFERENCES Items(itemID)
);

CREATE TABLE Billing (
    billingID VARCHAR(6),
    userID VARCHAR(6),
    amount FLOAT,
    date DATE,

	PRIMARY KEY(billingID),
    FOREIGN KEY (userID) REFERENCES Users(userID)
);

CREATE TABLE Reports (
    reportID INT,
    type VARCHAR(20),
    date DATE,
    generatedBy VARCHAR(6),

	PRIMARY KEY (reportID),
    FOREIGN KEY (generatedBy) REFERENCES Users(userID)
);