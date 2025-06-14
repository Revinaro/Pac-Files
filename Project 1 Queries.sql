
--Project 1 - Queries

--1
Select top 5 p.ProductID, p.Name,  sum(unitPrice*OrderQty) as TotalPrice
from Product p join SalesOrderDetail s on p.productid = s.productid
group by p.productid,p.Name
Order by TotalPrice desc
--2
Select PC.Name,round(Avg(s.UnitPrice), 2) as AvgPrice
from Product p join salesOrderDetail s on p.productid = s.productid 
join ProductSubcategory psub on p.ProductSubcategoryID = psub.ProductSubcategoryID 
join ProductCategory PC on psub.productCategoryID = PC.ProductCategoryID
where PC.Name in ('Bikes','Components')
Group by  PC.Name
--3
select p.Name as [Product Name], sum(OrderQty) as [Product Quantity] 
from Product p join salesOrderDetail s on p.productid = s.productid 
join ProductSubcategory psub on p.ProductSubcategoryID = psub.ProductSubcategoryID 
join ProductCategory PC on psub.productCategoryID = PC.ProductCategoryID
where PC.name not in ('Clothing','Components')
Group by p.Name
--4
Select top 3 ST.Name as [Territory Name], sum(TotalDue) as [Total Sales]
From SalesTerritory ST join SalesOrderHeader SOH on ST.territoryID = SOH.territoryID
group by ST.Name
order by [Total Sales] desc
--5
Select CustomerID, FirstName +' '+ LastName as "Full Name"
from Customer C left Join Person p on C.customerID= p.BusinessEntityID
Where C.CustomerID not in (Select customerID from SalesOrderHeader)
Order by CustomerID
--6
Delete from [SalesTerritory]
Where TerritoryID in
(Select ST.TerritoryID
 From SalesTerritory ST Left Join SalesPerson SP on ST.TerritoryID = SP.TerritoryID
 Where BusinessEntityID is Null)
--7
INSERT INTO [dbo].[SalesTerritory] (
    [Name],
    [CountryRegionCode],
    [Group],
    [SalesYTD],
    [SalesLastYear],
    [CostYTD],
    [CostLastYear],
    [rowguid],
    [ModifiedDate]
)
SELECT T.[Name],
    T.[CountryRegionCode],
    T.[Group],
    T.[SalesYTD],
    T.[SalesLastYear],
    T.[CostYTD],
    T.[CostLastYear],
    T.[rowguid],
    T.[ModifiedDate]
FROM [AdventureWorks2022].[Sales].[SalesTerritory] T LEFT JOIN 
    [AdventureWorks2022].[Sales].[SalesPerson] SP ON T.TerritoryID = SP.TerritoryID
WHERE SP.BusinessEntityID IS NULL;
--8
Select BusinessEntityID, FirstName, LastName, count(C.CustomerID) as AmountOfOrders
from customer C join Person p on c.PersonID = p.BusinessEntityID
Join SalesOrderHeader SOH on C.customerid = SOH.customerID 
group by BusinessEntityID,firstName, LastName
having count(C.CustomerID) > 20
--9
Select GroupName, count(Name) as [Amount Of Departments]
from Department
group by GroupName
Having count(Name)>2
--10
Select p.FirstName +' '+p.LastName [Full Employee Name], d.Name as [Department], s.name as [Shift]
from Employee as e join EmployeeDepartmentHistory as edh 
on e.BusinessEntityID = edh.BusinessEntityID join Shift as s 
on edh.ShiftId = s.shiftId join Department as d 
on edh.departmentId= d.departmentId join Person as p --I added Person table for the full employee name
on e.BusinessEntityID = p.BusinessEntityID
Where year(StartDate) > 2010 and d.GroupName IN ('Quality Assurance', 'Manufacturing');
