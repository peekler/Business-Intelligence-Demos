using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.SqlServer.Server;

namespace SQLCLR_IsHoliday
{
    public class IsHolidayHelper
    {
        [SqlFunction(DataAccess = DataAccessKind.None)]
        public static bool IsHoliday(DateTime dt)
        {
            var holidays = GetHolidaysList();
            return holidays.Any(holiday => isSameDay(holiday, dt));
        }

        private static bool isSameDay(DateTime holiday, DateTime dt)
        {
            return holiday.Year == dt.Year && holiday.Month == dt.Month && holiday.Day == dt.Day;
        }

        public static IEnumerable<DateTime> GetHolidaysList()
        {
            // teszt implementacio: itt kellene a kulso fajbol betolteni az unnepnapokat
            yield return new DateTime(2015, 8, 20);
        }
    }
}
