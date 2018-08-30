# Using relational database as a business intelligence system - DEMO

This demo will demonstrate how to build a simple business intelligence system. We will also focus on the common problems of data processing in such systems, that we will cover in more detail during the course.

## Goal

We have a log from a web server in text form. We are seeking to understand if there are problems that need addressing. We also want some basic statistical figures that gives us a hint about the load of the system.

## Let's make a plan

In order to get some answers from the dataset, we need to process it. And in order to process it, we need to understand what it contains, so we can find the right tools.

First, let us see what the data contains. This is an excerpt from the log.

```
"_id";"timestamp";"exception";"httpStatusCode";"logLevel";"message";"requestId";"requestNum";"requestTime";"host"
"ez8eDGIBhK6LQO766OFQ";"2018. 03. 09. 18:56:09";"";"200";"Information";"Request finished in 1707.854ms 200 application/json; charset=utf-8";"0HLC5TTL7UGQL";"1";"1707.854";"host1"
"y_iMGmIBvTB7p1paO9GP";"2018. 03. 12. 14:10:11";"";"200";"Information";"Request finished in 1.5019ms 200 application/json; charset=utf-8";"0HLC812GHTLN2";"1";"1.5019";"host1"
"hyuFGmIBN-IoXSlIdl_O";"2018. 03. 12. 14:02:33";"";"200";"Information";"Request finished in 8.6243ms 200 application/json; charset=utf-8";"0HLC812GHTLN0";"1";"8.6243";"host1"
"PWwCH2IB-6ZMWBq_b31K";"2018. 03. 13. 10:57:14";"";"";"Warning";"System check warning: DB not available";"";"";"";"host1"
```

We see that this is a CSV-like text format, which makes processing easy.

We will process the data using Microsoft SQL Server, SQL command, and Microsoft Excel in the following way:

1. Import the log file into a so called 'staging' area as-is.
1. Transform the raw data to fit further processing needs (e.g. parse string to date type).
1. Use CLR integration to parse custom datetime string.
1. Check basic statistics, like number of requests.
1. Get detailed response time statistics, including standard deviation.
1. Validate if erroneous requests are specific to one of the host servers (which would indicate a configuration error.)
1. Visualize the ratio of success / error requests in Excel.

### Pre-requisites

* Microsoft SQL Server (express edition suffice)
* A new, empty database
* The log file, placed in a directory where SQL server can access it (_not_ My Documents, Desktop, or alike)
* Microsoft Visual Studio
* Microsoft Excel

## Importing the data

First, we map the data in the log file directly, and import everything as text. Let's create a table in the database for this.

```sql
CREATE TABLE [Staging]
(
	[Id] [nvarchar](50) NULL,
	[Timestamp] [nvarchar](50) NULL,
	[Exception] [nvarchar](500) NULL,
	[HttpStatusCode] [nvarchar](10) NULL,
	[LogLevel] [nvarchar](50) NULL,
	[Message] [nvarchar](4000) NULL,
	[RequestId] [nvarchar](50) NULL,
	[RequestNum] [nvarchar](50) NULL,
	[RequestTime] [nvarchar](20) NULL,
	[Host] [nvarchar](50) NULL
)
```

We can import the log file directly with the following command. The WITH options specify how the CSV-like file is to be parsed. (Note. You need to specify a full path in FROM.)

```sql
BULK INSERT [Staging]
FROM 'webserverlog.log'
WITH
(
	FORMAT = 'CSV',
	FIELDTERMINATOR =';',
	FIELDQUOTE = '"',
	ROWTERMINATOR ='\n',
	FIRSTROW = 2
)
```

Let's validate if the import succeeded.

```sql
select top 3 * from [Staging]
```

```
2tmlaGIBd696Dn2qQKrP	2018. 03. 27. 18:08:02	NULL	200	Information	Request finished in 35.0369ms 200 	0HLC90A8E7MUM	1	35.0369	host1
l9mBa2IBd696Dn2qRqsU	2018. 03. 28. 7:27:13	NULL	200	Information	Request finished in 1.3827ms 200 application/json; charset=utf-8	0HLC9NV0B0LOA	1	1.3827	host2
kHSda2IBceyQBL6wbqPb	2018. 03. 28. 7:58:13	NULL	200	Information	Request finished in 1.2024ms 200 application/json; charset=utf-8	0HLC9NV0B0LOF	1	1.2024	host2
```

The Staging table contains data in raw format. In order to process it conveniently, it needs some basic transformations:

* Drop columns that we will not use
* Transform non-text columns to their proper representation

We create a new table to store the pre-processed data.

```sql
CREATE TABLE [Log]
(
	[Timestamp] [datetime] NULL,
	[HttpStatusCode] [int] NULL,
	[LogLevel] [nvarchar](50) NULL,
	[Message] [nvarchar](4000) NULL,
	[RequestId] [nvarchar](50) NULL,
	[RequestTime] [float] NULL,
	[Host] [nvarchar](50) NULL
)
```

Parsing to int and float are simple. But we will have trouble parsing the date. SQL Server can parse a date string is various format, but not this format "2018. 03. 28. 7:58:13" To work around the issue, we will write the date parsing in C# and call this C# method from SQL.

### Call a C# method from SQL Server

Create a new _Class library_ type of project targeting any .NET version. Create a single class in this project with the following code.

```Csharp
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
```

After compiling, let's import the dll assembly into SQL Server. We have to enable support for it first, and disable some security checks. In production, there are alternative ways to do this.

```sql
sp_configure 'show advanced options', 1
go
reconfigure
go
sp_configure 'clr enabled', 1
GO
sp_configure 'clr strict security', 0
GO
RECONFIGURE
GO

-- Regisztráljuk a .NET dll-t az SQL szerverben.
CREATE ASSEMBLY CustomDateParseUdf FROM 'd:\CustomDateParse.dll';
GO
CREATE FUNCTION dbo.ParseDateWithFormat(@value nvarchar(max), @format nvarchar(max))
RETURNS datetime
AS EXTERNAL NAME CustomDateParseUdf.[CustomDateParse.CustomDateParse].ParseDateWithFormat;
GO
```

Let us then test this function. More information on the custom datetime format string (the second argument) is available at <https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings>. It should output a properly parsed value.

```sql
select dbo.ParseDateWithFormat('2018. 03. 28. 17:58:13','yyyy. MM. dd. H:m:s')
```


### Finish the import

Now we call the necessary transformations either using SQL methods or the previously written C# function.

```sql
INSERT INTO [Log]
SELECT
	dbo.ParseDateWithFormat([Timestamp],'yyyy. MM. dd. H:m:s'),
	CONVERT(int, [HttpStatusCode]),
	[LogLevel],
	[Message],
	[RequestId],
	CONVERT(float, [RequestTime]),
	[Host]
	FROM [Staging]
```

And finally, the temporary storage is not needed. Let's clear the table.

```sql
truncate table [Staging]
```

## Basic statistics

Let's use SQL queries to get some information.

#### Number of successful and erroneous requests

```sql
select count(*)
from [Log]
where [HttpStatusCode] = 200
```

#### Requests that took too long to complete

```sql
select *
from [Log]
where [RequestTime] > 25
```

#### Average request time per host

```sql
select [Host], AVG([RequestTime])
from [Log]
group by [Host]
```

## Detailed analysis of response times



## Visualize with Excel