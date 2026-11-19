/* =====================================================================
   Скрипт 02: Функция, съхранена процедура и тригер
   ===================================================================== */
USE AirbnbDB;
GO

/* ФУНКЦИЯ: цена на престой = брой нощувки * цена на нощ */
CREATE FUNCTION dbo.fn_CalculateTotalPrice
(
    @ListingID INT,
    @CheckIn   DATE,
    @CheckOut  DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Price DECIMAL(10,2);

    SELECT @Price = PricePerNight
    FROM Listings
    WHERE ListingID = @ListingID;

    RETURN DATEDIFF(DAY, @CheckIn, @CheckOut) * @Price;
END;
GO

/* СЪХРАНЕНА ПРОЦЕДУРА: създава нова резервация */
CREATE PROCEDURE dbo.sp_CreateBooking
    @ListingID INT,
    @GuestID   INT,
    @CheckIn   DATE,
    @CheckOut  DATE,
    @NumGuests INT
AS
BEGIN
    IF @NumGuests > (SELECT MaxGuests FROM Listings WHERE ListingID = @ListingID)
    BEGIN
        RAISERROR (N'The number of guests exceeds the listing capacity.', 16, 1);
        RETURN;
    END;

    INSERT INTO Bookings (ListingID, GuestID, CheckInDate, CheckOutDate, NumGuests, TotalPrice, Status)
    VALUES (@ListingID, @GuestID, @CheckIn, @CheckOut, @NumGuests,
            dbo.fn_CalculateTotalPrice(@ListingID, @CheckIn, @CheckOut), 'Confirmed');

    PRINT N'Booking created successfully.';
END;
GO

/* ТРИГЕР: не позволява две резервации за една обява с припокриващи се дати */
CREATE TRIGGER dbo.trg_Bookings_NoOverlap
ON Bookings
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Bookings b
          ON b.ListingID = i.ListingID
         AND b.BookingID <> i.BookingID
        WHERE i.Status <> 'Cancelled'
          AND b.Status <> 'Cancelled'
          AND b.CheckInDate  < i.CheckOutDate
          AND b.CheckOutDate > i.CheckInDate
    )
    BEGIN
        RAISERROR (N'The listing is already booked for these dates.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

/* ---------------- Примерно използване (след зареждане на данните) ----------------
SELECT dbo.fn_CalculateTotalPrice(1, '2027-03-10', '2027-03-14') AS Price;

EXEC dbo.sp_CreateBooking @ListingID = 1, @GuestID = 6,
     @CheckIn = '2027-03-10', @CheckOut = '2027-03-14', @NumGuests = 2;

-- втори опит за същите дати -> тригерът връща грешка
EXEC dbo.sp_CreateBooking @ListingID = 1, @GuestID = 7,
     @CheckIn = '2027-03-12', @CheckOut = '2027-03-15', @NumGuests = 2;
------------------------------------------------------------------------------------ */
