-- Engedélyezzük a CLR integrációt az SQL szerveren
sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO

-- A továbbiak a demó adatbázisunkon futtatandó.
use [BIDemo]
go

-- Regisztráljuk a .NET dll-t az SQL szerverben.
CREATE ASSEMBLY IsHolidayUdf FROM '<path-to-dll>\SQLCLR_IsHoliday.dll';
GO
CREATE FUNCTION dbo.IsHoliday(@dt datetime)
RETURNS BIT 
AS EXTERNAL NAME IsHolidayUdf.[SQLCLR_IsHoliday.IsHolidayHelper].IsHoliday;
GO


-- Tesztelés: aktuális évre átlagoljuk az ünnepnapok telefonálásait, és a többi nap telefonálásait
select avg([length]) as avg_call_length_weekday
from [CallLog]
where datepart(year, [Timestamp]) = datepart(year, GETDATE())
and dbo.IsHoliday([Timestamp]) = 0

select avg([length]) as avg_call_length_holiday
from [CallLog]
where datepart(year, [Timestamp]) = datepart(year, GETDATE())
and dbo.IsHoliday([Timestamp]) = 1
