/* =====================================================================
   Зареждане на данните от AirbnbDB в AirbnbDW
   (пуска се след 01_create_dw.sql и след като AirbnbDB е напълнена)
   ===================================================================== */
USE AirbnbDW;
GO

/* ------------------------- DimDate: 2023–2027 ------------------------- */
DECLARE @d DATE = '2023-01-01';
WHILE @d <= '2027-12-31'
BEGIN
    INSERT INTO DimDate (DateKey, FullDate, [Day], [Month], [Quarter], [Year])
    VALUES (CONVERT(INT, CONVERT(CHAR(8), @d, 112)), @d, DAY(@d), MONTH(@d), DATEPART(QUARTER, @d), YEAR(@d));
    SET @d = DATEADD(DAY, 1, @d);
END;

/* --------------------------- Измерения --------------------------- */
INSERT INTO DimCity (CityID, CityName, Country)
SELECT CityID, Name, Country FROM AirbnbDB.dbo.Cities;

INSERT INTO DimListing (ListingID, Title, PropertyType)
SELECT ListingID, Title, PropertyType FROM AirbnbDB.dbo.Listings;

INSERT INTO DimGuest (UserID, GuestName)
SELECT UserID, FirstName + N' ' + LastName FROM AirbnbDB.dbo.Users;

INSERT INTO DimHost (UserID, HostName)
SELECT u.UserID, u.FirstName + N' ' + u.LastName
FROM AirbnbDB.dbo.Users u
WHERE u.UserID IN (SELECT HostID FROM AirbnbDB.dbo.Listings);

INSERT INTO DimPaymentMethod (MethodName)
SELECT DISTINCT Method FROM AirbnbDB.dbo.Payments;

/* ----------------------------- Факти ----------------------------- */
INSERT INTO FactBookings (BookingID, DateKey, ListingKey, GuestKey, HostKey, CityKey,
                          Nights, NumGuests, TotalPrice, IsCancelled)
SELECT b.BookingID,
       CONVERT(INT, CONVERT(CHAR(8), b.CheckInDate, 112)),
       dl.ListingKey, dg.GuestKey, dh.HostKey, dc.CityKey,
       DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate),
       b.NumGuests,
       b.TotalPrice,
       CASE WHEN b.Status = 'Cancelled' THEN 1 ELSE 0 END
FROM AirbnbDB.dbo.Bookings b
JOIN AirbnbDB.dbo.Listings l ON l.ListingID = b.ListingID
JOIN DimListing dl ON dl.ListingID = b.ListingID
JOIN DimGuest   dg ON dg.UserID    = b.GuestID
JOIN DimHost    dh ON dh.UserID    = l.HostID
JOIN DimCity    dc ON dc.CityID    = l.CityID;

INSERT INTO FactPayments (PaymentID, DateKey, GuestKey, ListingKey, PaymentMethodKey, Amount)
SELECT p.PaymentID,
       CONVERT(INT, CONVERT(CHAR(8), p.PaymentDate, 112)),
       dg.GuestKey, dl.ListingKey, dm.PaymentMethodKey, p.Amount
FROM AirbnbDB.dbo.Payments p
JOIN AirbnbDB.dbo.Bookings b ON b.BookingID = p.BookingID
JOIN DimGuest         dg ON dg.UserID     = b.GuestID
JOIN DimListing       dl ON dl.ListingID  = b.ListingID
JOIN DimPaymentMethod dm ON dm.MethodName = p.Method;

INSERT INTO FactReviews (ReviewID, DateKey, ListingKey, GuestKey, HostKey, Rating)
SELECT r.ReviewID,
       CONVERT(INT, CONVERT(CHAR(8), r.ReviewDate, 112)),
       dl.ListingKey, dg.GuestKey, dh.HostKey, r.Rating
FROM AirbnbDB.dbo.Reviews r
JOIN AirbnbDB.dbo.Bookings b ON b.BookingID = r.BookingID
JOIN AirbnbDB.dbo.Listings l ON l.ListingID = b.ListingID
JOIN DimListing dl ON dl.ListingID = b.ListingID
JOIN DimGuest   dg ON dg.UserID    = b.GuestID
JOIN DimHost    dh ON dh.UserID    = l.HostID;
GO

SELECT 'FactBookings' AS TableName, COUNT(*) AS RowsCount FROM FactBookings
UNION ALL SELECT 'FactPayments', COUNT(*) FROM FactPayments
UNION ALL SELECT 'FactReviews',  COUNT(*) FROM FactReviews;
GO
