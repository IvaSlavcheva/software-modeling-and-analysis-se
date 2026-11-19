USE AirbnbDW;
GO

SELECT 'FactBookings' AS TableName, COUNT(*) AS RowsCount FROM FactBookings
UNION ALL SELECT 'FactPayments',     COUNT(*) FROM FactPayments
UNION ALL SELECT 'FactReviews',      COUNT(*) FROM FactReviews
UNION ALL SELECT 'DimDate',          COUNT(*) FROM DimDate
UNION ALL SELECT 'DimCity',          COUNT(*) FROM DimCity
UNION ALL SELECT 'DimListing',       COUNT(*) FROM DimListing
UNION ALL SELECT 'DimGuest',         COUNT(*) FROM DimGuest
UNION ALL SELECT 'DimHost',          COUNT(*) FROM DimHost
UNION ALL SELECT 'DimPaymentMethod', COUNT(*) FROM DimPaymentMethod;
GO
