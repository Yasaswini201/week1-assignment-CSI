--Query 1:
SELECT * 
FROM dbo.DimCustomer;

--Query 2:
SELECT 
    c.CustomerID,
    s.Name AS CompanyName
FROM 
    Sales.Customer c
JOIN 
    Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE 
    s.Name LIKE '%N'

--Query 3:
SELECT *
FROM dbo.DimCustomer
WHERE City IN ('London' , 'Berlin');

--Query 4:
SELECT *
FROM dbo.DimCustomer
WHERE City IN ('UK' , 'USA');
--Query 5:
SELECT *
FROM dbo.DimProduct
ORDER BY EnglishProductName

--Query 6:
SELECT *
FROM dbo.DimProduct
WHERE EnglishProductName LIKE ‘%A’

--Query 7:
SELECT DISTINCT c.*
FROM dbo.DimCustomer c
JOIN dbo.FactInternetSales fis
    ON c.CustomerKey = fis.CustomerKey;
--Query 8:
SELECT DISTINCT c.*
FROM dbo.DimCustomer c
JOIN dbo.FactInternetSales fis
    ON c.CustomerKey = fis.CustomerKey
JOIN dbo.DimProduct p
    ON fis.ProductKey = p.ProductKey
WHERE c.City = 'London'
  AND p.EnglishProductName = 'Chai';

--Query 9:
SELECT *
FROM dbo.DimCustomer c
LEFT JOIN dbo.FactInternetSales fis
    ON c.CustomerKey = fis.CustomerKey
WHERE fis.CustomerKey IS NULL;
--Query 10:
SELECT  c.*
FROM dbo.DimCustomer c
JOIN dbo.FactInternetSales fis
    ON c.CustomerKey = fis.CustomerKey
JOIN dbo.DimProduct p
    ON fis.ProductKey = p.ProductKey
WHERE  p.EnglishProductName = 'Chai';

--Query 11:
SELECT TOP 1 *
FROM dbo.FactInternetSales
ORDER BY OrderDate ASC;

--Query 12:
SELECT TOP 1 *
FROM dbo.FactInternetSales
ORDER BY SalesAmount DESC;

--Query 13:
SELECT 
    SalesOrderNumber,
    AVG(OrderQuantity) AS AvgQuantityPerOrder
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber;

--Query 14:
SELECT 
    SalesOrderNumber,
    MIN(OrderQuantity) AS MinQuantity,
    MAX(OrderQuantity) AS MaxQuantity
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber;

--Query 15:
SELECT 
    mgr.EmployeeKey AS ManagerID,
    mgr.FirstName + ' ' + mgr.LastName AS ManagerName,
    COUNT(emp.EmployeeKey) AS NumberOfReports
FROM dbo.DimEmployee emp
JOIN dbo.DimEmployee mgr
    ON emp.ParentEmployeeKey = mgr.EmployeeKey
GROUP BY 
    mgr.EmployeeKey,
    mgr.FirstName,
    mgr.LastName
ORDER BY NumberOfReports DESC;

--Query 16:
SELECT 
    SalesOrderNumber,
    SUM(OrderQuantity) AS TotalQuantity
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber
HAVING SUM(OrderQuantity) > 300;

--Query 17:
SELECT *
FROM dbo.FactInternetSales
WHERE OrderDate >= '1996-12-31';

--Query 18:
SELECT 
    fis.SalesOrderNumber,
    fis.OrderDate,
    fis.ShipDate,
    dg.EnglishCountryRegionName AS Country,
    fis.SalesAmount
FROM dbo.FactInternetSales fis
JOIN dbo.DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
JOIN dbo.DimGeography dg ON dc.GeographyKey = dg.GeographyKey
WHERE dg.EnglishCountryRegionName = 'Canada';

--Query 19: 
SELECT 
    SalesOrderNumber,
    SUM(SalesAmount) AS OrderTotal
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber
HAVING SUM(SalesAmount) > 200;

--Query 20: 
SELECT 
    g.EnglishCountryRegionName AS Country,
    SUM(fis.SalesAmount) AS TotalSales
FROM 
    dbo.FactInternetSales fis
    INNER JOIN dbo.DimCustomer c ON fis.CustomerKey = c.CustomerKey
    INNER JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
GROUP BY 
    g.EnglishCountryRegionName
ORDER BY 
    TotalSales DESC;
--Query 21:
SELECT 
    c.FirstName + ' ' + c.LastName AS ContactName,
    COUNT(fis.SalesOrderNumber) AS NumberOfOrders
FROM 
    dbo.FactInternetSales fis
    INNER JOIN dbo.DimCustomer c ON fis.CustomerKey = c.CustomerKey
GROUP BY 
    c.FirstName, c.LastName
ORDER BY 
    NumberOfOrders DESC; 
--Query 22:
SELECT 
    c.FirstName + ' ' + c.LastName AS ContactName
FROM 
    dbo.FactInternetSales fis
    INNER JOIN dbo.DimCustomer c ON fis.CustomerKey = c.CustomerKey
GROUP BY 
    c.FirstName, c.LastName
HAVING 
    COUNT(fis.SalesOrderNumber) > 3
ORDER BY 
    ContactName;

--Query 23:
SELECT 
    p.ProductKey,
    p.ProductAlternateKey,
    p.EnglishProductName
FROM 
    dbo.FactInternetSales fis
    INNER JOIN dbo.DimProduct p ON fis.ProductKey = p.ProductKey
    INNER JOIN dbo.DimDate d ON fis.OrderDateKey = d.DateKey
WHERE 
    p.DiscontinuedDate IS NOT NULL
    AND d.FullDateAlternateKey >= '1997-01-01'
    AND d.FullDateAlternateKey < '1998-01-01'
GROUP BY 
    p.ProductKey, p.ProductAlternateKey, p.EnglishProductName
ORDER BY 
    p.EnglishProductName;

--Query 24:
SELECT 
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    s.FirstName AS SupervisorFirstName,
    s.LastName AS SupervisorLastName
FROM 
    dbo.DimEmployee e
    LEFT JOIN dbo.DimEmployee s
        ON e.ParentEmployeeKey = s.EmployeeKey
ORDER BY 
    e.LastName, e.FirstName;

--Query 25:
SELECT 
    e.EmployeeKey AS EmployeeID,
    SUM(fis.SalesAmount) AS TotalSales
FROM 
    dbo.FactInternetSales fis
    INNER JOIN dbo.DimEmployee e ON fis.SalesPersonKey = e.EmployeeKey
GROUP BY 
    e.EmployeeKey
ORDER BY 
    TotalSales DESC;

--Query 26:
SELECT 
    EmployeeKey,
    FirstName,
    LastName
FROM 
    dbo.DimEmployee
WHERE 
    FirstName LIKE '%a%'
ORDER BY 
    FirstName, LastName;

--Query 27:
SELECT 
    m.EmployeeKey AS ManagerID,
    m.FirstName AS ManagerFirstName,
    m.LastName AS ManagerLastName,
    COUNT(e.EmployeeKey) AS NumberOfDirectReports
FROM 
    dbo.DimEmployee m
    INNER JOIN dbo.DimEmployee e ON m.EmployeeKey = e.ParentEmployeeKey
GROUP BY 
    m.EmployeeKey, m.FirstName, m.LastName
HAVING 
    COUNT(e.EmployeeKey) > 4
ORDER BY 
    NumberOfDirectReports DESC, m.LastName, m.FirstName;

--Query 28:
SELECT 
    fis.SalesOrderNumber AS OrderNumber,
    dp.EnglishProductName AS ProductName
FROM 
    dbo.FactInternetSales fis
    INNER JOIN dbo.DimProduct dp ON fis.ProductKey = dp.ProductKey
ORDER BY 
    dp.EnglishProductName;

--Query 29:
SELECT 
    SalesOrderNumber,
    OrderDateKey,
    SalesAmount
FROM 
    dbo.FactInternetSales
WHERE 
    CustomerKey = (
        SELECT TOP 1 CustomerKey
        FROM dbo.FactInternetSales
        GROUP BY CustomerKey
        ORDER BY SUM(SalesAmount) DESC
    )
ORDER BY 
    OrderDateKey;

--Query 30:
SELECT 
    fs.SalesOrderNumber,
    fs.OrderDate,
    fs.SalesAmount,
    dc.CustomerKey
FROM 
    dbo.FactInternetSales AS fs
JOIN 
    dbo.DimCustomer AS dc ON fs.CustomerKey = dc.CustomerKey
WHERE 
    dc.FaxNumber IS NULL
ORDER BY 
    fs.OrderDate DESC;
--Query 31:
SELECT DISTINCT dc.PostalCode
FROM dbo.FactInternetSales fis
JOIN dbo.DimProduct dp ON fis.ProductKey = dp.ProductKey
JOIN dbo.DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
WHERE dp.EnglishProductName = 'Tofu'
ORDER BY dc.PostalCode;

--Query 32:
SELECT DISTINCT dp.EnglishProductName
FROM dbo.FactInternetSales fis
JOIN dbo.DimProduct dp ON fis.ProductKey = dp.ProductKey
JOIN dbo.DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
WHERE dc.CountryRegionName = 'France'
ORDER BY dp.EnglishProductName;

--Query 33:
SELECT DISTINCT
    p.EnglishProductName AS ProductName,
    pc.EnglishProductCategoryName AS ProductCategory
FROM dbo.DimProduct p
JOIN dbo.DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN dbo.DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
JOIN Purchasing.ProductVendor pv ON p.ProductKey = pv.ProductKey
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'speciality biscuits ltd'
ORDER BY p.EnglishProductName;


--Query 34:
SELECT p.EnglishProductName
FROM dbo.DimProduct p
LEFT JOIN dbo.FactInternetSales fis ON p.ProductKey = fis.ProductKey
WHERE fis.ProductKey IS NULL
ORDER BY p.EnglishProductName;

--Query 35:
SELECT dp.EnglishProductName
FROM dbo.DimProduct dp
JOIN dbo.FactProductInventory fpi ON dp.ProductKey = fpi.ProductKey
WHERE fpi.UnitsInStock < 10
  AND fpi.UnitsOnOrder = 0
ORDER BY dp.EnglishProductName;

--Query 36:
SELECT TOP 10 
    dc.CountryRegionName AS Country,
    SUM(fis.SalesAmount) AS TotalSales
FROM 
    dbo.FactInternetSales fis
JOIN 
    dbo.DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
GROUP BY 
    dc.CountryRegionName
ORDER BY 
    TotalSales DESC;

--Query 37:
SELECT 
    fi.EmployeeKey,
    COUNT(*) AS NumberOfOrders
FROM 
    dbo.FactInternetSales fi
JOIN 
    dbo.DimCustomer dc ON fi.CustomerKey = dc.CustomerKey
WHERE 
    dc.CustomerAlternateKey IN ('A', 'AO')
GROUP BY 
    fi.EmployeeKey
ORDER BY 
    NumberOfOrders DESC;

--Query 38:
SELECT TOP 1 OrderDate, SalesAmount
FROM dbo.FactInternetSales
ORDER BY SalesAmount DESC;

--Query 39:
SELECT 
    dp.EnglishProductName AS ProductName,
    SUM(fis.SalesAmount) AS TotalRevenue
FROM 
    dbo.FactInternetSales fis
JOIN 
    dbo.DimProduct dp ON fis.ProductKey = dp.ProductKey
GROUP BY 
    dp.EnglishProductName
ORDER BY 
    TotalRevenue DESC;

--Query 40:
SELECT 
    pv.BusinessEntityID AS SupplierID,
    COUNT(pv.ProductID) AS NumberOfProductsOffered
FROM 
    Purchasing.ProductVendor pv
GROUP BY 
    pv.BusinessEntityID
ORDER BY 
    NumberOfProductsOffered DESC;

--Query 41:
SELECT TOP 10
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    SUM(fis.SalesAmount) AS TotalSales
FROM
    dbo.FactInternetSales fis
JOIN
    dbo.DimCustomer c ON fis.CustomerKey = c.CustomerKey
GROUP BY
    c.CustomerKey, c.FirstName, c.LastName
ORDER BY
    TotalSales DESC;

--Query 42:
SELECT SUM(SalesAmount) AS TotalRevenue
FROM dbo.FactInternetSales;
