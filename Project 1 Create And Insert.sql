

--Project 1 - Create and Insert

Create database Sales
Go

Use Sales
Go

--Tables:
--1.Customer 
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] NOT NULL PRIMARY KEY,
	[PersonID] [int] NULL,
	[StoreID] [int] NULL,
	[TerritoryID] [int] NULL,
	[AccountNumber] [varchar](10)  NOT NULL ,
	[rowguid] [uniqueidentifier]  ROWGUIDCOL NOT NULL,
	[ModifiedDate] [datetime] NOT NULL DEFAULT ('2014-09-01 00:00:00')
) ON [PRIMARY]
GO
INSERT [dbo].[Customer]
           ([CustomerID]
		   ,[PersonID]
		   ,[StoreID]
           ,[TerritoryID]
           ,[AccountNumber]
           ,[rowguid]
           ,[ModifiedDate] 
		   )
select [CustomerID]
	   ,[PersonID]
	   ,[StoreID]
	   ,[TerritoryID]
	   ,[AccountNumber]
	   ,[rowguid]
	   ,[ModifiedDate]
from [AdventureWorks2022].[Sales].[Customer]

--2.SalesTerritory
CREATE TABLE [dbo].[SalesTerritory](
	[TerritoryID] [int] IDENTITY(1,1) NOT NULL Primary Key,
	[Name] [nvarchar](50) NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[Group] [nvarchar](50) NOT NULL,
	[SalesYTD] [money] NOT NULL,
	[SalesLastYear] [money] NOT NULL,
	[CostYTD] [money] NOT NULL default 0.00,
	[CostLastYear] [money] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[SalesTerritory]
           ([Name],
		   [CountryRegionCode],
		   [Group],
		   [SalesYTD],
		   [SalesLastYear],
		   [CostYTD],
		   [CostLastYear],
		   [rowguid],
		   [ModifiedDate])
select [Name]
	   ,[CountryRegionCode]
	   ,[Group]
	   ,[SalesYTD]
	   ,[SalesLastYear]
	   ,[CostYTD]
	   ,[CostLastYear]
	   ,[rowguid]
	   ,[ModifiedDate]
from [AdventureWorks2022].[Sales].[SalesTerritory]

--3 SalesPerson
CREATE TABLE [dbo].[SalesPerson](
    [BusinessEntityID] [int] IDENTITY(274,1) NOT NULL Primary Key,
	[TerritoryID] [int] NULL,
    [SalesQuota] [money] NULL,
	[Bonus] [money] NOT NULL,
	[CommissionPct] [smallmoney] NOT NULL DEFAULT 0.00,
	[SalesYTD] [money] NOT NULL,
	[SalesLastYear] [money] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[SalesPerson]
		([TerritoryID]
		,[SalesQuota]
		,[Bonus]
		,[CommissionPct]
		,[SalesYTD]
		,[SalesLastYear]
		,[rowguid]
		,[ModifiedDate])
select [TerritoryID]
	   ,[SalesQuota]
	   ,[Bonus]
	   ,[CommissionPct]
	   ,[SalesYTD]
	   ,[SalesLastYear]
	   ,[rowguid]
	   ,[ModifiedDate]
from [AdventureWorks2022].[Sales].[SalesPerson]

--4 CreditCard
CREATE TABLE [dbo].[CreditCard](
    [CreditCardID] [int] IDENTITY(1,1) NOT NULL Primary Key,
	[CardType] [nvarchar](50) NOT NULL,
	[CardNumber] [nvarchar](25) NOT NULL,
	[ExpMonth] [tinyint] NOT NULL,
	[ExpYear] [smallint] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default getdate()
) ON [PRIMARY]
GO
INSERT [dbo].[CreditCard](
			 [CardType]
			,[CardNumber]
			,[ExpMonth]
			,[ExpYear]
			,[ModifiedDate])
select[CardType]
	 ,[CardNumber]
     ,[ExpMonth]
	 ,[ExpYear]
	 ,[ModifiedDate]
from [AdventureWorks2022].[Sales].[CreditCard]

--5 SalesOrderHeader
CREATE TABLE [dbo].[SalesOrderHeader](
	[SalesOrderID] [int] IDENTITY(43659,1) NOT NULL Primary Key,
	[RevisionNumber] [tinyint] DEFAULT 0 NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag] [bit] NOT NULL default 0,
	[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
	[PurchaseOrderNumber] [varchar](25) NULL,
	[AccountNumber] [varchar](25) NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue]  AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),--added
	[Comment] [nvarchar](128) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
)ON [PRIMARY]
GO
INSERT [dbo].[SalesOrderHeader](
      [RevisionNumber]
      ,[OrderDate]
      ,[DueDate]
      ,[ShipDate]
      ,[Status]
      ,[OnlineOrderFlag]
      ,[PurchaseOrderNumber]
      ,[AccountNumber]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[TerritoryID]
      ,[BillToAddressID]
      ,[ShipToAddressID]
      ,[ShipMethodID]
      ,[CreditCardID]
      ,[CreditCardApprovalCode]
      ,[CurrencyRateID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
      ,[Comment]
      ,[rowguid]
      ,[ModifiedDate])  
select
      [RevisionNumber]
      ,[OrderDate]
      ,[DueDate]
      ,[ShipDate]
      ,[Status]
      ,[OnlineOrderFlag]
      ,[PurchaseOrderNumber]
      ,[AccountNumber]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[TerritoryID]
      ,[BillToAddressID]
      ,[ShipToAddressID]
      ,[ShipMethodID]
      ,[CreditCardID]
      ,[CreditCardApprovalCode]
      ,[CurrencyRateID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
      ,[Comment]
      ,[rowguid]
      ,[ModifiedDate]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]

--6 SalesOrederDetail
CREATE TABLE [dbo].[SalesOrderDetail](
	[SalesOrderID] [int] NOT NULL,
    [SalesOrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
    [OrderQty] [smallint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SpecialOfferID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitPriceDiscount] [money] NOT NULL default 0,
	[LineTotal]  AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	 PRIMARY KEY ([SalesOrderID], [SalesOrderDetailID]),
	 FOREIGN KEY ([SalesOrderID]) REFERENCES [SalesOrderHeader] (SalesOrderID)
)ON [PRIMARY]
GO
INSERT [dbo].[SalesOrderDetail](
      [SalesOrderID]
	  ,[CarrierTrackingNumber]
	  ,[OrderQty]
	  ,[ProductID]
	  ,[SpecialOfferID]
	  ,[UnitPrice]
	  ,[UnitPriceDiscount]
	  ,[rowguid]
	  ,[ModifiedDate])
SELECT [SalesOrderID]
	   ,[CarrierTrackingNumber]
	   ,[OrderQty]
	   ,[ProductID]
	   ,[SpecialOfferID]
	   ,[UnitPrice]
	   ,[UnitPriceDiscount]
	   ,[rowguid]
	   ,[ModifiedDate]
FROM [AdventureWorks2022].[Sales].[SalesOrderDetail]

--7 SpecialOfferProduct 
CREATE TABLE [dbo].[SpecialOfferProduct](
	[SpecialOfferID] [int] NOT NULL ,
	[ProductID] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default ('2011-04-01 00:00:00'),
	PRIMARY KEY ([SpecialOfferID], [ProductID])
)ON [PRIMARY]
GO
INSERT [dbo].[SpecialOfferProduct](
	         [SpecialOfferID]
			 ,[ProductID]
			 ,[rowguid]
			 ,[ModifiedDate])
SELECT[SpecialOfferID]
	  ,[ProductID]
	  ,[rowguid]
	  ,[ModifiedDate]
FROM [AdventureWorks2022].[Sales].[SpecialOfferProduct]

--8 Address
CREATE TABLE [dbo].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL Primary Key,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[SpatialLocation] [geography] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default ('2016-06-23 00:00:00')
)ON [PRIMARY]
GO
INSERT [dbo].[Address](
	         [AddressLine1]
			 ,[AddressLine2]
			 ,[City]
			 ,[StateProvinceID]
			 ,[PostalCode]
			 ,[SpatialLocation]
			 ,[rowguid]
			 ,[ModifiedDate])
SELECT [AddressLine1]
	   ,[AddressLine2]
	   ,[City]
	   ,[StateProvinceID]
	   ,[PostalCode]
	   ,[SpatialLocation]
	   ,[rowguid]
	   ,[ModifiedDate]
FROM [AdventureWorks2022].[Person].[Address]

--9 ShipMethod
CREATE TABLE [dbo].[ShipMethod](
	[ShipMethodID] [int] IDENTITY(1,1) NOT NULL Primary Key,
	[Name] [nvarchar](50) NOT NULL,
	[ShipBase] [money] NOT NULL,
	[ShipRate] [money] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default ('2008-04-30 00:00:00'))
ON [PRIMARY]
GO
INSERT [dbo].[ShipMethod](
	         [Name]
			 ,[ShipBase]
			 ,[ShipRate]
			 ,[rowguid]
			 ,[ModifiedDate])
SELECT [Name]
	   ,[ShipBase]
	   ,[ShipRate]
	   ,[rowguid]
	   ,[ModifiedDate]
FROM [AdventureWorks2022].[Purchasing].[ShipMethod]

--10 CurrencyRate
CREATE TABLE [dbo].[CurrencyRate](
	[CurrencyRateID] [int] IDENTITY(1,1) NOT NULL Primary Key,
	[CurrencyRateDate] [datetime] NOT NULL,
	[FromCurrencyCode] [nchar](3) NOT NULL,
	[ToCurrencyCode] [nchar](3) NOT NULL,
	[AverageRate] [money] NOT NULL default 70,
	[EndOfDayRate] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default getdate())
ON [PRIMARY]
GO
INSERT [dbo].[CurrencyRate](
			 [CurrencyRateDate]
			 ,[FromCurrencyCode]
			 ,[ToCurrencyCode]
			 ,[AverageRate]
			 ,[EndOfDayRate]
			 ,[ModifiedDate])
SELECT [CurrencyRateDate]
	  ,[FromCurrencyCode]
	  ,[ToCurrencyCode]
	  ,[AverageRate]
	  ,[EndOfDayRate]
	  ,[ModifiedDate]
FROM [AdventureWorks2022].[Sales].[CurrencyRate]


--Additional tables from the queries section

--Question 1 - Production.Product
CREATE TABLE [dbo].[Product](
	[ProductID] [int] NOT NULL Primary Key,
	[Name] [nvarchar](50) NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] [bit] NOT NULL,
	[FinishedGoodsFlag] [bit] NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL default 0,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
)ON [PRIMARY]
GO
INSERT [dbo].[Product](
	   [ProductID]	
      ,[Name]
      ,[ProductNumber]
      ,[MakeFlag]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[SizeUnitMeasureCode]
      ,[WeightUnitMeasureCode]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[Class]
      ,[Style]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[DiscontinuedDate]
      ,[rowguid]
      ,[ModifiedDate])
Select [ProductID]
	  ,[Name]
      ,[ProductNumber]
      ,[MakeFlag]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[SizeUnitMeasureCode]
      ,[WeightUnitMeasureCode]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[Class]
      ,[Style]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[DiscontinuedDate]
      ,[rowguid]
      ,[ModifiedDate]
FROM [AdventureWorks2022].[Production].[Product]

--Question 2 - production.ProductSubcategory & production.ProductCategory

--ProductSubcategory:
CREATE TABLE [dbo].[ProductSubcategory](
	[ProductSubcategoryID] [int] IDENTITY(1,1) NOT NULL Primary Key,
	[ProductCategoryID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default ('2008-04-30 00:00:00'))
ON [PRIMARY]
GO
Insert [dbo].[ProductSubcategory](
	         [ProductCategoryID]
			 ,[Name]
			 ,[rowguid]
			 ,[ModifiedDate])
Select [ProductCategoryID]
	   ,[Name]
	   ,[rowguid]
	   ,[ModifiedDate]
from [AdventureWorks2022].[Production].[ProductSubcategory]

--ProductCategory:
CREATE TABLE [dbo].[ProductCategory](
	[ProductCategoryID] [int] IDENTITY(1,1) NOT NULL primary key,
	[Name] [nvarchar](50) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default ('2008-04-30 00:00:00')
) ON [PRIMARY]
GO
Insert [dbo].[ProductCategory](
	         [Name],
			 [rowguid],
			 [ModifiedDate])
Select [Name],
	   [rowguid],
	   [ModifiedDate]
from [AdventureWorks2022].[Production].[ProductCategory]

--Question 5 - Person.Person
CREATE TABLE [dbo].[Person](
	[BusinessEntityID] [int] NOT NULL Primary Key,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] [bit] NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL default 0,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
) ON [PRIMARY] 
GO
Insert [dbo].[Person]([BusinessEntityID]
      ,[PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,[EmailPromotion]
      ,[rowguid]
      ,[ModifiedDate])
SELECT [BusinessEntityID]
      ,[PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,[EmailPromotion]
      ,[rowguid]
      ,[ModifiedDate]
 FROM [AdventureWorks2022].[Person].[Person]

--Question 9 - HumanResources.Department 
CREATE TABLE [dbo].[Department](
	[DepartmentID] [smallint] IDENTITY(1,1) NOT NULL Primary Key,
	[Name] [nvarchar](50) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default ('2008-04-30 00:00:00')
) ON [PRIMARY]
GO
Insert [dbo].[Department](
	         [Name]
			 ,[GroupName]
			 ,[ModifiedDate])
Select [Name]
	   ,[GroupName]
	   ,[ModifiedDate]
from [AdventureWorks2022].[HumanResources].[Department]

--Question 10 - HumanResources.Employee & HumanResources.EmployeeDepartmentHistory & humanResources.Shift

--HumanResources.Employee,
CREATE TABLE [dbo].[Employee](
	[BusinessEntityID] [int] NOT NULL Primary Key,
	[NationalIDNumber] [nvarchar](15) NOT NULL,
	[LoginID] [nvarchar](256) NOT NULL,
	[OrganizationNode] [hierarchyid] NULL,
	[JobTitle] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[HireDate] [date] NOT NULL,
	[SalariedFlag] [bit] NOT NULL default 0,
	[VacationHours] [smallint] NOT NULL,
	[SickLeaveHours] [smallint] NOT NULL,
	[CurrentFlag] [bit] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
 ) ON [PRIMARY]
GO
Insert [dbo].[Employee]([BusinessEntityID]
	  ,[NationalIDNumber]
      ,[LoginID]
      ,[OrganizationNode]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
      ,[SalariedFlag]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[rowguid]
      ,[ModifiedDate]
)
Select [BusinessEntityID]
	  ,[NationalIDNumber]
      ,[LoginID]
      ,[OrganizationNode]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
      ,[SalariedFlag]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[rowguid]
      ,[ModifiedDate]
 FROM [AdventureWorks2022].[HumanResources].[Employee]

 --HumanResources.EmployeeDepartmentHistory
 CREATE TABLE [dbo].[EmployeeDepartmentHistory](
	[BusinessEntityID] [int] NOT NULL,
	[DepartmentID] [smallint] NOT NULL,
	[ShiftID] [tinyint] NOT NULL default 1,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NOT NULL,
	CONSTRAINT [PK_EmployeeDepartmentHistory] PRIMARY KEY ([BusinessEntityID],[DepartmentID],[ShiftID],[StartDate]))
	ON [PRIMARY]
GO
Insert [dbo].[EmployeeDepartmentHistory](
	         [BusinessEntityID]
			 ,[DepartmentID]
			 ,[ShiftID]
			 ,[StartDate]
			 ,[EndDate]
			 ,[ModifiedDate])
select [BusinessEntityID]
	   ,[DepartmentID]
	   ,[ShiftID]
	   ,[StartDate]
	   ,[EndDate]
	   ,[ModifiedDate]
from [AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory]

--humanResources.Shift
CREATE TABLE [dbo].[Shift](
	[ShiftID] [tinyint] IDENTITY(1,1) NOT NULL primary key,
	[Name] [nvarchar](50) NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL default ('2008-04-30 00:00:00')
)ON [PRIMARY]
GO
insert [dbo].[shift](
	           [Name]
			  ,[StartTime]
			  ,[EndTime]
			  ,[ModifiedDate])
select [Name]
	   ,[StartTime]
	   ,[EndTime]
	   ,[ModifiedDate]
from [AdventureWorks2022].[HumanResources].[Shift]


