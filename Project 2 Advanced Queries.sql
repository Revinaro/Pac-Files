--Project 2

--1 
with cte
as(
select year(orderDate) as OrderYear,
	   sum(quantity*unitprice) as IncomePerYear,
	   count(distinct Month(orderdate)) as NumberOfDistinctMonths, 
	   sum(Quantity * UnitPrice) / count(distinct month(OrderDate)) * 12 as YearlyLinearIncome 
from sales.Invoices I 
	 join sales.invoiceLines IL on I.invoiceID = IL.invoiceID 
	 join Sales.orders o on I.orderid = o.orderId
group by year(orderdate))

select OrderYear, 
	   IncomePerYear,
	   NumberOfDistinctMonths,
	   cast(YearlyLinearIncome as Decimal(10,2)) as YearlyLinearIncome,
	   cast((YearlyLinearIncome/lag(YearlyLinearIncome) over (order by orderYear)-1)*100 as decimal(10,2)) as Ratio
from cte

--2
with CTE
as(
select year(OrderDate) as Year,
	   datepart(quarter,orderdate) as TheQuarter,
	   CustomerName, 
	   sum(quantity * IL.unitprice) as incomePerYear,
	   dense_Rank() over(partition by year(OrderDate),datepart(quarter,orderdate) Order by sum(quantity * IL.unitprice) desc) as DNR
from sales.Invoices I 
	 join sales.invoiceLines IL on I.invoiceID = IL.invoiceID 
	 join Sales.orders o on I.orderid = o.orderId 
	 join Sales.Customers c on o.CustomerID= c.CustomerID
group by year(OrderDate), 
         datepart(quarter,orderdate), 
		 CustomerName)

select Year,
	   TheQuarter, 
	   CustomerName, 
	   IncomePerYear, 
	   DNR
from CTE
where DNR <= 5
order by Year,
		 TheQuarter

--3
with CTE
as(
select s.StockItemID, 
	   StockItemName, 
	   sum(quantity * IL.unitprice) as TotalProfit
from sales.Invoices I 
	 join sales.invoiceLines IL on I.invoiceID = IL.invoiceID 
	 join Sales.orders o on I.orderid = o.orderId 
	 join Warehouse.StockItems s on il.stockItemId= s.stockItemID
group by s.StockItemID, 
	     StockItemName)

select top 10 StockItemID, 
	          StockItemName,
			  TotalProfit
from CTE
order by totalProfit desc

--4
with CTE
as(
select StockItemID, 
	   StockItemName,
	   UnitPrice,
	   RecommendedRetailPrice,
	   abs(UnitPrice-RecommendedRetailPrice) as NominalProductProfit
from Warehouse.StockItems
where getdate() < validto)

select row_number() over (order by NominalProductProfit desc) as Rn,
	   *, 
	   dense_Rank() over (Order by NominalProductProfit desc) as DNR
from CTE

--5
with CTE
as(
 select SU.supplierID, 
        cast(SU.supplierID as nvarchar(40)) + ' - ' + SupplierName as SupplierDetails,
        cast(StockItemID as nvarchar(40)) + ' ' + StockItemName as Products
 from Purchasing.Suppliers SU 
	  Join Warehouse.StockItems ST on SU.SupplierID = ST.SupplierID
)

select SupplierDetails, 
	   String_Agg(Products,' /, ') as ProductDetails
from CTE
group by SupplierDetails, 
		 SupplierID
Order by SupplierID

--6
Select top 5 c.CustomerID, 
		     CityName,
			 CountryName,
			 Continent,
			 Region,
			 sum(ExtendedPrice) as TotalExtendedPrices
from [Sales].[Invoices] I 
	 join [Sales].[InvoiceLines] IL on I.[InvoiceID] = IL.[InvoiceID] 
	 join [Sales].[Customers] C on I.[CustomerID] = C.[CustomerID] 
	 join [Application].[Cities] CI on C.[DeliveryCityID] = CI.[CityID]
     join [Application].[StateProvinces] ST on CI.[StateProvinceID]= ST.[StateProvinceID]
	 join [Application].[Countries] Cou on ST.[CountryID] = Cou.[CountryID]
Group by c.CustomerID, 
		 CityName,
		 Countryname,
		 Continent,
		 Region
Order by sum([ExtendedPrice]) desc

--7
with CTE as (
select distinct year(orderdate) as OrderYear, 
	   Month(orderdate) as ordermonth,
	   sum(unitprice*quantity) over (partition by month(orderdate),year(orderdate))as Sales,
	   sum(unitprice*quantity) over (partition by year(orderdate) order by month(orderdate),
	   year(orderdate))as RunningTotal
from sales.Invoices I 
	 join sales.invoiceLines IL on I.invoiceID = IL.invoiceID 
     join Sales.orders o on I.orderid = o.orderId 

union all

select year(orderdate)as OrderYear,
	   null,
	   sum(unitprice*quantity),
	   sum(unitprice*quantity)
from sales.Invoices I 
	 join sales.invoiceLines IL on I.invoiceID = IL.invoiceID 
     join Sales.orders o on I.orderid = o.orderId 
group by year(orderdate)
)

Select Orderyear,
	   case when ordermonth is null then 'Grand Total' else cast(ordermonth as varchar) end as Months,
	   Sales, 
	   RunningTotal
from CTE
order by orderyear, isnull(ordermonth,13)

--8
select *
from (select year(orderdate) as YY, 
			 Month(orderdate) as OrderMonth, 
			 orderid
		from sales.orders) o
pivot (count(orderid) For yy in ([2013],[2014],[2015],[2016])) pvt
order by OrderMonth

--9
with CTE as(
Select CustomerID,
	   CustomerName,
	   OrderDate,
	   previousOrderDate,
	   DaysSinceLastOrder,
	   avg(Daydiff) over (partition by customerID) AverageDaysBetweenOrder,
	   case when DaysSinceLastOrder/Nullif(avg(Daydiff) over (partition by customerID),0) < 2 then 'Active' else 'In Potential To Leave ' end as CustomerStatus,
	   row_number() over (partition by o.CustomerID order by o.OrderDate desc) as rowNum
from (Select o.customerID, 
	         customerName,
			 Orderdate, 
			 datediff(day,Orderdate,Max(Orderdate) over(partition by null)) as DaysSinceLastOrder,
			 lead(Orderdate) over (Partition by o.customerID order by orderdate desc) previousOrderDate,
			 abs(datediff(day,Orderdate,lag(Orderdate) over (Partition by o.customerID order by orderdate desc)))DayDiff
	   from [Sales].[Customers] c join [Sales].[Orders] O on c.customerID =O.customerID ) o
)

Select CustomerID,
       CustomerName,
	   OrderDate,
	   previousOrderDate,
	   DaysSinceLastOrder,
	   AverageDaysBetweenOrder,
	   CustomerStatus
from CTE
where rowNum = 1
order by customerID

--10
with CTE 
as(
select CustomerCategoryName,
	   count(distinct customername1) as CustomerCOUNT,
	   sum(count(distinct customername1)) over () as TotalCustCount
from (Select CustomerCategoryName, 
	         customername,
	         case when c.customerName like '%wingtip%' then 'wingtip'
		          when c.customerName like '%Tailspin%' then 'Tailspin'
		          else c.customername end as customerName1
	  from Sales.Customers c join Sales.CustomerCategories CC on c.CustomerCategoryID = CC.CustomerCategoryID
	  group by CustomerCategoryName, customerName) a
group by CustomerCategoryName
)

select *,
	   concat(cast(CustomerCOUNT * 100.0 /  nullif(TotalCustCount, 0) as decimal(10,2)), '%') AS DistributionFactor 
from CTE
order by CustomerCategoryName
