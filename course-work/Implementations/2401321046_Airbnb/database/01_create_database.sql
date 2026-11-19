/* =====================================================================
   Курсова работа: Airbnb – релационна база данни
   Ива Славчева, ф.н. 2401321046, СИ
   Скрипт 01: Създаване на базата и таблиците
   ===================================================================== */
USE master;
GO

IF DB_ID(N'AirbnbDB') IS NOT NULL
BEGIN
    ALTER DATABASE AirbnbDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AirbnbDB;
END
GO

CREATE DATABASE AirbnbDB;
GO

USE AirbnbDB;
GO

-- 1. Градове
CREATE TABLE Cities
(
    CityID   INT IDENTITY(1,1) PRIMARY KEY,
    Name     NVARCHAR(100) NOT NULL,
    Country  NVARCHAR(100) NOT NULL
);

-- 2. Потребители (гости и домакини)
CREATE TABLE Users
(
    UserID           INT IDENTITY(1,1) PRIMARY KEY,
    CityID           INT           NULL REFERENCES Cities(CityID),   -- град, в който живее (не е задължителен)
    FirstName        NVARCHAR(50)  NOT NULL,
    LastName         NVARCHAR(50)  NOT NULL,
    Email            NVARCHAR(150) NOT NULL UNIQUE,
    Phone            VARCHAR(20)   NULL,
    RegistrationDate DATE          NOT NULL DEFAULT (GETDATE())
);

-- 3. Обяви (имоти)
CREATE TABLE Listings
(
    ListingID     INT IDENTITY(1,1) PRIMARY KEY,
    HostID        INT           NOT NULL REFERENCES Users(UserID),
    CityID        INT           NOT NULL REFERENCES Cities(CityID),
    Title         NVARCHAR(150) NOT NULL,
    PropertyType  NVARCHAR(50)  NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL CHECK (PricePerNight > 0),
    MaxGuests     INT           NOT NULL CHECK (MaxGuests > 0)
);

-- 4. Запазени обяви (любими) – връзка МНОГО КЪМ МНОГО между Users и Listings
CREATE TABLE SavedListings
(
    UserID    INT  NOT NULL REFERENCES Users(UserID),
    ListingID INT  NOT NULL REFERENCES Listings(ListingID),
    SavedDate DATE NOT NULL DEFAULT (GETDATE()),
    PRIMARY KEY (UserID, ListingID)
);

-- 5. Удобства
CREATE TABLE Amenities
(
    AmenityID INT IDENTITY(1,1) PRIMARY KEY,
    Name      NVARCHAR(80) NOT NULL UNIQUE
);

-- 6. Обява <-> Удобство  (връзка МНОГО КЪМ МНОГО)
CREATE TABLE ListingAmenities
(
    ListingID INT NOT NULL REFERENCES Listings(ListingID),
    AmenityID INT NOT NULL REFERENCES Amenities(AmenityID),
    PRIMARY KEY (ListingID, AmenityID)
);

-- 7. Резервации
CREATE TABLE Bookings
(
    BookingID    INT IDENTITY(1,1) PRIMARY KEY,
    ListingID    INT           NOT NULL REFERENCES Listings(ListingID),
    GuestID      INT           NOT NULL REFERENCES Users(UserID),
    CheckInDate  DATE          NOT NULL,
    CheckOutDate DATE          NOT NULL,
    NumGuests    INT           NOT NULL,
    TotalPrice   DECIMAL(10,2) NOT NULL,
    Status       NVARCHAR(20)  NOT NULL DEFAULT ('Confirmed')
                 CHECK (Status IN ('Confirmed', 'Completed', 'Cancelled')),
    CHECK (CheckOutDate > CheckInDate)
);

-- 8. Плащания
CREATE TABLE Payments
(
    PaymentID   INT IDENTITY(1,1) PRIMARY KEY,
    BookingID   INT           NOT NULL REFERENCES Bookings(BookingID),
    Amount      DECIMAL(10,2) NOT NULL,
    Method      NVARCHAR(30)  NOT NULL,
    PaymentDate DATE          NOT NULL
);

-- 9. Отзиви
CREATE TABLE Reviews
(
    ReviewID   INT IDENTITY(1,1) PRIMARY KEY,
    BookingID  INT            NOT NULL UNIQUE REFERENCES Bookings(BookingID),
    Rating     INT            NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment    NVARCHAR(500)  NULL,
    ReviewDate DATE           NOT NULL
);
GO
