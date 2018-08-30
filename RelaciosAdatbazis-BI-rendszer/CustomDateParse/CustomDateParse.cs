using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

namespace CustomDateParse
{
    public static class CustomDateParse
    {
        [SqlFunction(DataAccess = DataAccessKind.None)]
        public static SqlDateTime ParseDateWithFormat(string value, string format)
        {
            return new SqlDateTime(DateTime.ParseExact(value, format, null));
        }
    }
}
