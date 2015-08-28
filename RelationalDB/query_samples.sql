-- Mennyi az elõfizetõk átlagéletkora? Hogyan oszlik el a korosztályok között (-17, 18-34, 35-59, 60-)?
select avg(age) from customer
select '-17', count(*) from customer where age<=17
select '18-34', count(*) from customer where age>17 and age <= 34
select '35-59', count(*) from customer where age>34 and age <= 59
select '60-', count(*) from customer where age>59




-- Mennyi idõt telefonálnak átlagosan az elõfizetõk az egyes heteken?

-- a DATEPART egy dátumból vissza tudja adni az évet, hónapot, napot, hetet
-- csoportosítjuk elõfizetõnként és hetenként és vesszük a telefonálás hosszok átlagát
select UserID, DATEPART(week, Timestamp) as week, avg(Length) as avg_on_week from CallLog
group by UserID, DATEPART(week, Timestamp)
order by UserID, week




-- A nõk vagy a férfiak telefonálnak hosszabban? Számoljuk ki a leghosszabb hívást a két nemre,
-- de elõször szûrjük ki az extrém hosszú hívásokat (ezeket outliernek szokás hívni).
-- Egy lehetséges módszer a kiszûrésre, ha feltételezzük, hogy a hívások normál eloszlás szerint alakulnak
-- (valóságban: nem, inkább Posisson vagy Weibull), a kétszeres szóráson túli elemeket (5%) eldobjuk.

-- mind a két táblára szükségünk lesz, nemenként csoportosítva a leghosszabb hívásra vagyunk kíváncsiak
select Gender, max(Length) as LongestCall
from CallLog join Customer on CallLog.UserID = Customer.UserID
join (
	-- ez a belsõ lekérdezés számolja ki a nemenkénti átlagot és a kétszeres szórást
select Gender as FilterGender, avg(Length) as AvgLength, 2*STDEVP(Length) StdDeviation
	from CallLog join Customer on CallLog.UserID = Customer.UserID
	group by Gender ) filter
on Gender = filter.FilterGender
-- ezzel szûrjük ki a kétszeres szórásnál hosszabb hívásokat
and Length <= filter.AvgLength + filter.StdDeviation 
group by Gender






-- Készítsünk egy nézetet, ami egy gyors jelentésként mûködhet. Ezt a nézetet felhasználhatjuk,
-- hogy összehasonlítsunk két hetet. Elõfizetõnként szeretnénk látni az elõzõ hetet és az aktuális
-- hetet, valamint, hogy milyen irányba változott a telefonálások átlaga. Az egyszerûség kedvéért
-- a változást egy + vagy – jellel jelöljük.

-- nézet létrehozása
create view WeeklyAverage as
select UserID, DATEPART(week, Timestamp) as week, avg(Length) as avg_on_week from CallLog
group by UserID, DATEPART(week, Timestamp)

-- A + és - jelhez egy segéd függvény.
CREATE FUNCTION PlusMinusNoChange(
	@val1 int, @val2 int
)
RETURNS char(1)
AS
BEGIN
	if @val1 < @val2
		return '-'
	else if @val1 > @val2
		return '+'
	return '='
END
GO

-- Futtassuk e heteket összehasonlító lekérdezést.
select top 5 w1.UserId, w1.week, w2.week, dbo.PlusMinusNoChange(w1.avg_on_week, w2.avg_on_week) as change
from WeeklyAverage w1 join WeeklyAverage w2 on w1.UserId = w2.UserId
where w1.week < w2.week
