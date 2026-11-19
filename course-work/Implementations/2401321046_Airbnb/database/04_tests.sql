USE AirbnbDB;
GO

-- 0) Почистване, за да може скриптът да се пуска многократно
DELETE FROM Bookings
WHERE ListingID = 1 AND CheckInDate IN ('2027-03-10', '2027-03-12');
GO

-- 1) FUNCTION: price for 4 nights in listing 1 (55 per night) -> 220.00
SELECT dbo.fn_CalculateTotalPrice(1, '2027-03-10', '2027-03-14') AS TotalPrice;
GO

-- 2) PROCEDURE: successful booking
EXEC dbo.sp_CreateBooking @ListingID = 1, @GuestID = 6,
     @CheckIn = '2027-03-10', @CheckOut = '2027-03-14', @NumGuests = 2;
GO

-- 3) PROCEDURE: too many guests (capacity 4) -> error from the procedure
EXEC dbo.sp_CreateBooking @ListingID = 1, @GuestID = 7,
     @CheckIn = '2027-04-01', @CheckOut = '2027-04-03', @NumGuests = 10;
GO

-- 4) TRIGGER: overlapping dates for the same listing -> error from the trigger
EXEC dbo.sp_CreateBooking @ListingID = 1, @GuestID = 7,
     @CheckIn = '2027-03-12', @CheckOut = '2027-03-15', @NumGuests = 2;
GO

-- 5) Result: only the successful booking is saved
SELECT * FROM Bookings
WHERE ListingID = 1 AND CheckInDate >= '2027-01-01';
GO
