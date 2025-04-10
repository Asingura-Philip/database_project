create database granary_ug;

use granary_ug;

create table Farmers (
    FarmerID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    Address VARCHAR(255)
);

CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    FarmerID INT,
    ServiceType VARCHAR(50) CHECK (ServiceType IN ('Storage', 'Drying', 'Storage & Drying')),
    Amount DECIMAL(10, 2),
    IssueDate DATE,
    DueDate DATE,
    FOREIGN KEY (FarmerID) REFERENCES Farmers(FarmerID)
);

CREATE TABLE Produces (
    ProduceID INT PRIMARY KEY,
    FarmerID INT,
    Type VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL, -- Number of bags or quantity of the produce
    ServiceRequired VARCHAR(50) CHECK (ServiceRequired IN ('Storage', 'Drying')),
    EntryDate DATE,  -- New column for the date when produce is entered into storage
    StorageDurationWeeks INT,  -- New column for the number of weeks the produce will be stored
    FOREIGN KEY (FarmerID) REFERENCES Farmers(FarmerID)
);

CREATE TABLE Managers (
    ManagerID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255)
);

CREATE TABLE Storekeepers (
    StoreKeeperID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255)
);

CREATE TABLE StorageUnits (
    StorageUnitID INT PRIMARY KEY,
    StoreKeeperID INT,
    Location VARCHAR(255) NOT NULL,
    Temperature DECIMAL(5, 2),
    Humidity DECIMAL(5, 2),
    Capacity INT NOT NULL, -- Maximum capacity in terms of quantity
    CurrentLoad INT,      -- Current quantity stored in the unit
    FOREIGN KEY (StoreKeeperID) REFERENCES Storekeepers(StoreKeeperID)
);


CREATE TABLE DryingExperts (
    DryingExpertID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255)
);

CREATE TABLE DryingUnits (
    DryingUnitID INT PRIMARY KEY,
    DryingExpertID INT,
    Location VARCHAR(255) NOT NULL,
    Capacity INT,  -- Maximum capacity in terms of batches
    FOREIGN KEY (DryingExpertID) REFERENCES DryingExperts(DryingExpertID)
);

CREATE TABLE Batches (
    BatchNumber INT PRIMARY KEY,
    DryingUnitID INT,
    StartDate DATE,
    EndDate DATE,      -- End date for drying
    Status VARCHAR(50) CHECK (Status IN ('Pending', 'In Progress', 'Completed')),
    FOREIGN KEY (DryingUnitID) REFERENCES DryingUnits(DryingUnitID)
);

CREATE TABLE Machines (
    MachineID INT PRIMARY KEY,
    DryingUnitID INT,
    MachineType VARCHAR(100) NOT NULL,
    Capacity INT,  -- Capacity of the machine
    FOREIGN KEY (DryingUnitID) REFERENCES DryingUnits(DryingUnitID)
);


CREATE TABLE StoredProduces (
    ProduceID INT PRIMARY KEY,
    StorageUnitID INT NOT NULL,  -- Foreign Key referencing StorageUnits
    StorageDurationWeeks INT NOT NULL,  -- The number of weeks to store
    FOREIGN KEY (ProduceID) REFERENCES Produces(ProduceID),
    FOREIGN KEY (StorageUnitID) REFERENCES StorageUnits(StorageUnitID)
);

CREATE TABLE DriedProduces (
    ProduceID INT PRIMARY KEY,
    BatchNumber INT NOT NULL,  -- Foreign Key referencing Batches
    DryingDuration INT NOT NULL,  -- The duration for drying
    StoredAfterDrying BOOLEAN DEFAULT FALSE,  -- Whether to store it after drying
    FOREIGN KEY (ProduceID) REFERENCES Produces(ProduceID),
    FOREIGN KEY (BatchNumber) REFERENCES Batches(BatchNumber)
);


CREATE TABLE TemperatureHumidityLogs (
    LogID INT PRIMARY KEY,
    StorageUnitID INT,
    Temperature DECIMAL(5, 2),
    Humidity DECIMAL(5, 2),
    LogDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StorageUnitID) REFERENCES StorageUnits(StorageUnitID)
);

CREATE TABLE ProduceInStorage (
    ProduceID INT,
    StorageUnitID INT,
    Quantity INT,
    PRIMARY KEY (ProduceID, StorageUnitID),
    FOREIGN KEY (ProduceID) REFERENCES Produces(ProduceID),
    FOREIGN KEY (StorageUnitID) REFERENCES StorageUnits(StorageUnitID)
);

show tables;

INSERT INTO Farmers (FarmerID, Name, ContactInfo, Address) VALUES
(1, 'Timothy Wilson', '123-456-7890', 'Farm Lane 10, Townsville'),
(2, 'Sarah Thompson', '234-567-8901', 'Riverside Ave 25, Greenfield'),
(3, 'John Doe', '345-678-9012', 'Sunnyhill Rd 30, Bright Valley'),
(4, 'Emma Carter', '456-789-0123', 'Oakwood St 12, Meadowbrook'),
(5, 'Liam Smith', '567-890-1234', 'Cedar Rd 45, Redfield'),
(6, 'Olivia Davis', '678-901-2345', 'Pine St 50, Westpoint'),
(7, 'James Miller', '789-012-3456', 'Willow Dr 5, Eastfield'),
(8, 'Sophia Garcia', '890-123-4567', 'Maple St 15, Rivertown'),
(9, 'Mason Brown', '901-234-5678', 'Elm St 20, Lakeview'),
(10, 'Ava Martinez', '012-345-6789', 'Birch St 100, Oakhill');

select * from farmers;

INSERT INTO Managers (ManagerID, Name, ContactInfo) VALUES
(1, 'Daniel King', '111-222-3333'),
(2, 'Rachel Adams', '222-333-4444'),
(3, 'Michael Clark', '333-444-5555');

select * from managers;

INSERT INTO Storekeepers (StoreKeeperID, Name, ContactInfo) VALUES
(1, 'George Walker', '444-555-6666'),
(2, 'Helen Scott', '555-666-7777');

INSERT INTO DryingExperts (DryingExpertID, Name, ContactInfo) VALUES
(1, 'Lucas White', '666-777-8888'),
(2, 'Zoe Harris', '777-888-9999'),
(3, 'Elijah Lewis', '888-999-0000');

INSERT INTO StorageUnits (StorageUnitID, StoreKeeperID, Location, Temperature, Humidity, Capacity, CurrentLoad) VALUES
(1, 1, 'Unit A - Zone 1', 18.5, 60, 100, 50),
(2, 2, 'Unit B - Zone 2', 20.0, 65, 200, 120),
(3, 1, 'Unit C - Zone 3', 15.0, 55, 150, 80),
(4, 2, 'Unit D - Zone 4', 19.0, 70, 180, 150);

select * from StorageUnits;

INSERT INTO DryingUnits (DryingUnitID, DryingExpertID, Location, Capacity) VALUES
(1, 1, 'Dryer Room 1 - North Wing', 100),
(2, 2, 'Dryer Room 2 - South Wing', 120),
(3, 3, 'Dryer Room 3 - East Wing', 150);

INSERT INTO Machines (MachineID, DryingUnitID, MachineType, Capacity) VALUES
(1, 1, 'Heat Blower', 50),
(2, 1, 'Dehumidifier', 50),
(3, 2, 'Heat Blower', 60),
(4, 2, 'Dehumidifier', 60),
(5, 3, 'Heat Blower', 75),
(6, 3, 'Dehumidifier', 75);

-- Insert into Produces table
INSERT INTO Produces (ProduceID, FarmerID, Type, Quantity, ServiceRequired, EntryDate, StorageDurationWeeks) VALUES
(1, 1, 'Maize', 30, 'Storage', '2025-04-06', 12),
(2, 2, 'Wheat', 50, 'Storage', '2025-04-01', 8),
(3, 3, 'Rice', 40, 'Drying', '2025-04-06', NULL),
(4, 4, 'Maize', 60, 'Storage', '2025-03-25', 10),
(5, 5, 'Wheat', 25, 'Drying', '2025-03-30', NULL),
(6, 6, 'Rice', 100, 'Storage', '2025-04-03', 6),
(7, 7, 'Barley', 20, 'Drying', '2025-04-02', NULL),
(8, 8, 'Maize', 40, 'Storage', '2025-04-02', 14),
(9, 9, 'Wheat', 30, 'Storage', '2025-03-30', 9),
(10, 10, 'Rice', 50, 'Drying', '2025-04-01', NULL);

select * from produces where produceid = 8;
-- Insert records for stored produce
INSERT INTO StoredProduces (ProduceID, StorageUnitID, StorageDurationWeeks) VALUES
(1, 1, 12),
(2, 2, 8),
(4, 3, 10),
(6, 4, 6),
(8, 1, 14),
(9, 2, 9);
select * from storedproduces where storageunitid = 1;

-- Insert records for dried produce
INSERT INTO DriedProduces (ProduceID, BatchNumber, DryingDuration) VALUES
(3, 101, 4),
(5, 102, 3),
(7, 103, 2),
(10, 102, 1);


INSERT INTO Batches (BatchNumber, DryingUnitID, StartDate, EndDate, Status) VALUES
(101, 1, '2025-04-06', '2025-04-10', 'In Progress'),
(102, 2, '2025-03-30', '2025-04-06', 'Completed'),
(103, 3, '2025-04-02', '2025-04-08', 'Pending');



















