/* =====================================================================
   Data Warehouse за Airbnb (звездна схема с 3 факт таблици – fact constellation)
   6 таблици измерения + 3 таблици факти
   ===================================================================== */
USE master;
GO

IF DB_ID(N'AirbnbDW') IS NOT NULL
BEGIN
    ALTER DATABASE AirbnbDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AirbnbDW;
END
GO

CREATE DATABASE AirbnbDW;
GO

USE AirbnbDW;
GO

/* ------------------------- ИЗМЕРЕНИЯ ------------------------- */
CREATE TABLE DimDate
(
    DateKey   INT  NOT NULL,          -- yyyymmdd
    FullDate  DATE NOT NULL,
    [Day]     INT  NOT NULL,
    [Month]   INT  NOT NULL,
    [Quarter] INT  NOT NULL,
    [Year]    INT  NOT NULL,
    CONSTRAINT PK_DimDate PRIMARY KEY (DateKey)
);

CREATE TABLE DimCity
(
    CityKey  INT IDENTITY(1,1) NOT NULL,
    CityID   INT           NOT NULL,
    CityName NVARCHAR(100) NOT NULL,
    Country  NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_DimCity PRIMARY KEY (CityKey)
);

CREATE TABLE DimListing
(
    ListingKey   INT IDENTITY(1,1) NOT NULL,
    ListingID    INT           NOT NULL,
    Title        NVARCHAR(150) NOT NULL,
    PropertyType NVARCHAR(50)  NOT NULL,
    CONSTRAINT PK_DimListing PRIMARY KEY (ListingKey)
);

CREATE TABLE DimGuest
(
    GuestKey  INT IDENTITY(1,1) NOT NULL,
    UserID    INT           NOT NULL,
    GuestName NVARCHAR(101) NOT NULL,
    CONSTRAINT PK_DimGuest PRIMARY KEY (GuestKey)
);

CREATE TABLE DimHost
(
    HostKey  INT IDENTITY(1,1) NOT NULL,
    UserID   INT           NOT NULL,
    HostName NVARCHAR(101) NOT NULL,
    CONSTRAINT PK_DimHost PRIMARY KEY (HostKey)
);

CREATE TABLE DimPaymentMethod
(
    PaymentMethodKey INT IDENTITY(1,1) NOT NULL,
    MethodName       NVARCHAR(30) NOT NULL,
    CONSTRAINT PK_DimPaymentMethod PRIMARY KEY (PaymentMethodKey)
);

/* --------------------------- ФАКТИ --------------------------- */
CREATE TABLE FactBookings
(
    BookingKey  INT IDENTITY(1,1) NOT NULL,
    BookingID   INT           NOT NULL,
    DateKey     INT           NOT NULL,      -- дата на настаняване
    ListingKey  INT           NOT NULL,
    GuestKey    INT           NOT NULL,
    HostKey     INT           NOT NULL,
    CityKey     INT           NOT NULL,
    Nights      INT           NOT NULL,
    NumGuests   INT           NOT NULL,
    TotalPrice  DECIMAL(10,2) NOT NULL,
    IsCancelled BIT           NOT NULL,
    CONSTRAINT PK_FactBookings PRIMARY KEY (BookingKey),
    CONSTRAINT FK_FactBookings_DimDate    FOREIGN KEY (DateKey)    REFERENCES DimDate(DateKey),
    CONSTRAINT FK_FactBookings_DimListing FOREIGN KEY (ListingKey) REFERENCES DimListing(ListingKey),
    CONSTRAINT FK_FactBookings_DimGuest   FOREIGN KEY (GuestKey)   REFERENCES DimGuest(GuestKey),
    CONSTRAINT FK_FactBookings_DimHost    FOREIGN KEY (HostKey)    REFERENCES DimHost(HostKey),
    CONSTRAINT FK_FactBookings_DimCity    FOREIGN KEY (CityKey)    REFERENCES DimCity(CityKey)
);

CREATE TABLE FactPayments
(
    PaymentKey       INT IDENTITY(1,1) NOT NULL,
    PaymentID        INT           NOT NULL,
    DateKey          INT           NOT NULL,  -- дата на плащане
    GuestKey         INT           NOT NULL,
    ListingKey       INT           NOT NULL,
    PaymentMethodKey INT           NOT NULL,
    Amount           DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_FactPayments PRIMARY KEY (PaymentKey),
    CONSTRAINT FK_FactPayments_DimDate          FOREIGN KEY (DateKey)          REFERENCES DimDate(DateKey),
    CONSTRAINT FK_FactPayments_DimGuest         FOREIGN KEY (GuestKey)         REFERENCES DimGuest(GuestKey),
    CONSTRAINT FK_FactPayments_DimListing       FOREIGN KEY (ListingKey)       REFERENCES DimListing(ListingKey),
    CONSTRAINT FK_FactPayments_DimPaymentMethod FOREIGN KEY (PaymentMethodKey) REFERENCES DimPaymentMethod(PaymentMethodKey)
);

CREATE TABLE FactReviews
(
    ReviewKey  INT IDENTITY(1,1) NOT NULL,
    ReviewID   INT NOT NULL,
    DateKey    INT NOT NULL,                 -- дата на отзива
    ListingKey INT NOT NULL,
    GuestKey   INT NOT NULL,
    HostKey    INT NOT NULL,
    Rating     INT NOT NULL,
    CONSTRAINT PK_FactReviews PRIMARY KEY (ReviewKey),
    CONSTRAINT FK_FactReviews_DimDate    FOREIGN KEY (DateKey)    REFERENCES DimDate(DateKey),
    CONSTRAINT FK_FactReviews_DimListing FOREIGN KEY (ListingKey) REFERENCES DimListing(ListingKey),
    CONSTRAINT FK_FactReviews_DimGuest   FOREIGN KEY (GuestKey)   REFERENCES DimGuest(GuestKey),
    CONSTRAINT FK_FactReviews_DimHost    FOREIGN KEY (HostKey)    REFERENCES DimHost(HostKey)
);
GO
