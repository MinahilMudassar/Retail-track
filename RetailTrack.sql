CREATE DATABASE RetailTrack;
USE RetailTrack;

CREATE TABLE Users (
    userID VARCHAR(6),
    userName VARCHAR(25),
    password VARCHAR(255),
    role VARCHAR(10), -- Admin, Manager, Cashier

	PRIMARY KEY (userID)
);

CREATE TABLE Categories (
    categoryID VARCHAR(6),
    categoryName VARCHAR(20),

	PRIMARY KEY (categoryID)
);

CREATE TABLE Suppliers (
    supplierID VARCHAR(6),
    supplierName VARCHAR(25),
    phone VARCHAR(12),
    email VARCHAR(50),
    address VARCHAR(100),

	PRIMARY KEY (supplierID)
);

CREATE TABLE Items (
    itemID VARCHAR(6),
    name VARCHAR(25),
    categoryID VARCHAR(6),
    supplierID VARCHAR(6),
    price FLOAT,

	PRIMARY KEY (itemID),
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID),
    FOREIGN KEY (supplierID) REFERENCES Suppliers(supplierID)
);

CREATE TABLE Inventory (
    inventoryID VARCHAR(6),
    itemID VARCHAR(6),
    quantity INT,
	available INT,

	PRIMARY KEY (inventoryID),
    FOREIGN KEY (itemID) REFERENCES Items(itemID)
);

CREATE TABLE Buying (
    buyingID VARCHAR(6),
    userID VARCHAR(6),
    amount FLOAT,
    date DATE,

	PRIMARY KEY(buyingID),
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