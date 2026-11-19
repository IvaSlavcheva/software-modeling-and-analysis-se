USE AirbnbDB;
GO

-- Градове
INSERT INTO Cities (Name, Country) VALUES
(N'Sofia', N'Bulgaria'),
(N'Plovdiv', N'Bulgaria'),
(N'Varna', N'Bulgaria'),
(N'Burgas', N'Bulgaria'),
(N'Bansko', N'Bulgaria'),
(N'Athens', N'Greece');

-- Потребители (1-5 са домакини, 6-12 са гости)
INSERT INTO Users (CityID, FirstName, LastName, Email, Phone, RegistrationDate) VALUES
(1, N'Georgi', N'Petrov', N'georgi.petrov@gmail.com', '0888123456', '2023-02-10'),
(2, N'Maria', N'Ivanova', N'maria.ivanova@abv.bg', '0877234567', '2023-05-21'),
(3, N'Nikolay', N'Stoyanov', N'nikolay.st@gmail.com', '0899345678', '2023-08-03'),
(1, N'Elena', N'Dimitrova', N'elena.dimitrova@mail.bg', '0886456789', '2024-01-15'),
(6, N'Nikos', N'Papadopoulos', N'nikos.papa@gmail.com', '+306912345678', '2024-03-02'),
(1, N'Ivan', N'Georgiev', N'ivan.georgiev@abv.bg', '0878567890', '2024-06-11'),
(2, N'Desislava', N'Nikolova', N'desi.nikolova@gmail.com', '0897678901', '2024-07-19'),
(4, N'Petar', N'Todorov', N'petar.todorov@gmail.com', '0885789012', '2024-09-01'),
(1, N'Gabriela', N'Popova', N'gabi.popova@abv.bg', '0876890123', '2024-10-25'),
(3, N'Stefan', N'Marinov', N'stefan.marinov@mail.bg', '0898901234', '2025-01-08'),
(NULL, N'Viktoria', N'Angelova', N'viki.angelova@gmail.com', '0887012345', '2025-02-14'),
(1, N'Martin', N'Kolev', N'martin.kolev@abv.bg', '0879123450', '2025-03-30');

-- Обяви
INSERT INTO Listings (HostID, CityID, Title, PropertyType, PricePerNight, MaxGuests) VALUES
(1, 1, N'Central apartment', N'Apartment', 55.00, 4),
(2, 1, N'Studio near NDK', N'Studio', 40.00, 2),
(1, 2, N'Old Town apartment', N'Apartment', 48.00, 4),
(3, 3, N'Sea view apartment', N'Apartment', 70.00, 4),
(3, 3, N'Villa with pool', N'Villa', 150.00, 8),
(4, 5, N'Chalet with fireplace', N'Chalet', 95.00, 6),
(5, 4, N'Beach studio', N'Studio', 45.00, 2),
(4, 5, N'Ski lift apartment', N'Apartment', 65.00, 4),
(5, 6, N'Acropolis view apartment', N'Apartment', 85.00, 4),
(2, 1, N'Room in shared flat', N'Room', 25.00, 2);

-- Запазени обяви (любими)
INSERT INTO SavedListings (UserID, ListingID, SavedDate) VALUES
(6, 5, '2025-05-02'),
(6, 9, '2025-06-14'),
(7, 4, '2025-04-20'),
(7, 6, '2025-10-01'),
(8, 1, '2025-02-11'),
(8, 5, '2025-03-08'),
(9, 6, '2024-11-30'),
(10, 7, '2025-06-01'),
(11, 2, '2025-03-15'),
(11, 6, '2026-09-20'),
(12, 3, '2025-04-25'),
(12, 9, '2026-02-10');

-- Удобства
INSERT INTO Amenities (Name) VALUES
(N'Wi-Fi'), (N'Air conditioning'), (N'Kitchen'), (N'Parking'),
(N'Pool'), (N'Washing machine'), (N'Terrace'), (N'Fireplace');

-- Удобства към обявите (много към много)
INSERT INTO ListingAmenities (ListingID, AmenityID) VALUES
(1, 1), (1, 2), (1, 3), (1, 6),
(2, 1), (2, 2),
(3, 1), (3, 3), (3, 7),
(4, 1), (4, 2), (4, 3), (4, 7),
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 7),
(6, 1), (6, 3), (6, 4), (6, 8),
(7, 1), (7, 2),
(8, 1), (8, 3), (8, 4),
(9, 1), (9, 2), (9, 7),
(10, 1);

-- Резервации
INSERT INTO Bookings (ListingID, GuestID, CheckInDate, CheckOutDate, NumGuests, TotalPrice, Status) VALUES
(1, 6,  '2025-03-14', '2025-03-17', 2, 165.00,  'Completed'),
(4, 7,  '2025-07-05', '2025-07-12', 4, 490.00,  'Completed'),
(5, 8,  '2025-07-20', '2025-07-27', 6, 1050.00, 'Completed'),
(6, 9,  '2025-01-10', '2025-01-14', 4, 380.00,  'Completed'),
(7, 10, '2025-08-01', '2025-08-05', 2, 180.00,  'Completed'),
(2, 11, '2025-04-02', '2025-04-04', 1, 80.00,   'Completed'),
(3, 12, '2025-05-09', '2025-05-11', 2, 96.00,   'Completed'),
(9, 6,  '2025-09-15', '2025-09-19', 2, 340.00,  'Completed'),
(8, 7,  '2025-02-07', '2025-02-10', 3, 195.00,  'Completed'),
(1, 8,  '2025-10-03', '2025-10-05', 3, 110.00,  'Cancelled'),
(4, 11, '2025-08-10', '2025-08-15', 3, 350.00,  'Completed'),
(5, 12, '2025-08-16', '2025-08-23', 8, 1050.00, 'Completed'),
(10, 9, '2025-11-20', '2025-11-23', 1, 75.00,   'Completed'),
(6, 10, '2025-12-27', '2026-01-02', 5, 570.00,  'Completed'),
(1, 11, '2026-02-13', '2026-02-15', 2, 110.00,  'Completed'),
(7, 6,  '2026-06-20', '2026-06-27', 2, 315.00,  'Completed'),
(4, 9,  '2026-07-10', '2026-07-17', 4, 490.00,  'Completed'),
(9, 12, '2026-04-03', '2026-04-07', 2, 340.00,  'Completed'),
(3, 7,  '2026-05-22', '2026-05-24', 2, 96.00,   'Cancelled'),
(8, 8,  '2026-01-23', '2026-01-26', 4, 195.00,  'Completed'),
(2, 10, '2026-09-11', '2026-09-14', 2, 120.00,  'Completed'),
(5, 6,  '2026-08-01', '2026-08-08', 7, 1050.00, 'Completed'),
(1, 12, '2026-11-20', '2026-11-23', 2, 165.00,  'Confirmed'),
(6, 11, '2026-12-28', '2027-01-03', 6, 570.00,  'Confirmed'),
(9, 8,  '2026-12-05', '2026-12-09', 3, 340.00,  'Confirmed'),
(10, 7, '2026-10-15', '2026-10-17', 1, 50.00,   'Completed'),
(4, 10, '2026-08-20', '2026-08-25', 2, 350.00,  'Completed'),
(7, 9,  '2026-07-15', '2026-07-18', 2, 135.00,  'Cancelled');

-- Плащания (за анулираните резервации 10, 19 и 28 няма плащане)
INSERT INTO Payments (BookingID, Amount, Method, PaymentDate) VALUES
(1, 165.00,  N'Card',      '2025-03-01'),
(2, 490.00,  N'Card',      '2025-05-20'),
(3, 1050.00, N'PayPal',     '2025-06-15'),
(4, 380.00,  N'Card',      '2024-12-12'),
(5, 180.00,  N'Apple Pay',  '2025-07-10'),
(6, 80.00,   N'Card',      '2025-03-30'),
(7, 96.00,   N'Google Pay', '2025-05-02'),
(8, 340.00,  N'PayPal',     '2025-08-28'),
(9, 195.00,  N'Card',      '2025-01-20'),
(11, 350.00, N'Card',      '2025-07-18'),
(12, 1050.00, N'Card',     '2025-07-01'),
(13, 75.00,  N'Apple Pay',  '2025-11-15'),
(14, 570.00, N'Card',      '2025-11-30'),
(15, 110.00, N'Google Pay', '2026-02-05'),
(16, 315.00, N'Card',      '2026-05-28'),
(17, 490.00, N'PayPal',     '2026-06-01'),
(18, 340.00, N'Card',      '2026-03-10'),
(20, 195.00, N'Card',      '2026-01-10'),
(21, 120.00, N'Apple Pay',  '2026-09-01'),
(22, 1050.00, N'Card',     '2026-06-20'),
(23, 165.00, N'Card',      '2026-11-02'),
(24, 570.00, N'PayPal',     '2026-11-05'),
(25, 340.00, N'Card',      '2026-11-08'),
(26, 50.00,  N'Google Pay', '2026-10-10'),
(27, 350.00, N'Card',      '2026-07-30');

-- Отзиви
INSERT INTO Reviews (BookingID, Rating, Comment, ReviewDate) VALUES
(1, 5,  N'Very clean and cozy, right in the center.', '2025-03-18'),
(2, 5,  N'Beautiful sea view!', '2025-07-13'),
(3, 4,  N'Great villa, the pool is amazing. A bit far from the beach.', '2025-07-28'),
(4, 5,  N'The fireplace was the best part. Highly recommend!', '2025-01-15'),
(5, 4,  N'Nice studio, close to the beach.', '2025-08-06'),
(7, 3,  N'Nice place, but noisy at night.', '2025-05-12'),
(8, 5,  N'Great location, the host was very kind.', '2025-09-20'),
(11, 4, N'Everything was fine.', '2025-08-16'),
(12, 5, N'Perfect for a big group.', '2025-08-24'),
(14, 5, N'We celebrated New Year here, it was wonderful.', '2026-01-03'),
(16, 3, N'The air conditioning did not work well.', '2026-06-28'),
(17, 4, N'Nice apartment, we would come again.', '2026-07-18'),
(18, 5, N'Great location, very clean!', '2026-04-08'),
(22, 4, N'Very nice villa.', '2026-08-09'),
(26, 2, N'The room was smaller than in the photos.', '2026-10-18');
GO
