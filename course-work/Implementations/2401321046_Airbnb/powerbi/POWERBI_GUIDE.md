# Power BI отчет – стъпки

1. **Get data → SQL Server.** Server: `localhost`, Database: `AirbnbDW`, режим Import. Зареди всички 9 таблици (`Dim*` и `Fact*`).
2. **Model view.** Провери дали връзките `Fact*[...Key]` → `Dim*[...Key]` са създадени (едно към много). Ако някоя липсва, създай я, като провлачиш колоната.
3. **Визуализации:**

| # | Визуализация | Настройки |
|---|---|---|
| 1 | Line chart – приходи по месеци | X: `DimDate[Year]`, `DimDate[Month]` · Y: сума на `FactBookings[TotalPrice]` · филтър: `IsCancelled` = False |
| 2 | Bar chart – приходи по град | Y: `DimCity[CityName]` · X: сума на `FactBookings[TotalPrice]` |
| 3 | Column chart – средна оценка по тип имот | X: `DimListing[PropertyType]` · Y: средна стойност на `FactReviews[Rating]` |
| 4 *(по желание)* | Pie chart – методи на плащане | Legend: `DimPaymentMethod[MethodName]` · Values: сума на `FactPayments[Amount]` |

4. Запази файла като `powerbi/Airbnb_Report.pbix` и добави снимка на отчета (`powerbi/report.png`).
