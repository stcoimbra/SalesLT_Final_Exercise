-- Question 1 --

/*
    From the customer data build a projection with the following output:
    - column name constituted by the first and last name of the client separated by a space
    - the first three letters of the phone
    - the email
    Filtered by:
    - only customers finished in vowel (a,e,i,o,u)
    - containing email
*/

SELECT 
    Customer.FirstName + ' ' + Customer.LastName AS Name,   
    LEFT(Customer.Phone,3) AS '3rds Telephone',           
    Customer.EmailAddress AS Email                          
FROM
    Customer
WHERE
    Customer.EmailAddress IS NOT NULL AND                  
    RIGHT(Customer.FirstName,1) IN ('a','e','i','o','u')    

-- Question 2 --

/*
    Build a projection from the table of products with the name of the product and the price and that presents only the 15 products 
    more expensive using the StandardCost column.
    - the output columns should have the label 'Name' and 'Price'.
*/

SELECT TOP 15                                               
    Name AS Name,                                   
    StandardCost AS Price
FROM 
    Product
ORDER BY
    Product.StandardCost DESC                                        

-- Question 3 --

/*
With just one select create a new table Products with the product name, the product category and its description in en (table 
of product descriptions).
*/

SELECT    
    prod.Name AS Nome,                                                                                                    
    prod.ProductCategoryID AS CategoryID, 
    prodDesc.Description AS Description 
INTO ProdutosNovo                                                                                             
FROM Product prod                                                                       
    INNER JOIN ProductCategory prodCat ON prodCat.ProductCategoryID = prod.ProductCategoryID                  
    INNER JOIN ProductModel prodModel ON prod.ProductModelID = prodModel.ProductModelID                      
    INNER JOIN ProductModelProductDescription PmPd ON PmPd.ProductModelID = prodModel.ProductModelID        
    INNER JOIN ProductDescription ProdDesc ON PmPd.ProductDescriptionID = ProdDesc.ProductDescriptionID     
WHERE 
    PmPd.Culture = 'en'                                                                                      
ORDER BY 
    CategoriaID ASC                                                                                         

-- Question 4 --

/*
    In the sales table which is the line with the highest and the lowest sales value per product category ?
    Present the category name and the value
*/                       
 

SELECT                                                                                                 
    ProductCategory.Name AS Categoria,                   
    MAX(SalesOrderDetail.Linetotal) AS 'Higher Sales Value',
    MIN(sod.Linetotal) AS 'Lowest Sales Value'                                        
FROM 
    SalesOrderHeader
    INNER JOIN SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
    INNER JOIN SalesOrderDetail sod on SalesOrderDetail.salesorderid = sod.salesorderiD
    INNER JOIN Product ON SalesOrderDetail.ProductID = Product.ProductID
    INNER JOIN ProductCategory on Product.ProductCategoryID = ProductCategory.ProductCategoryID
GROUP BY                                                                                              
    ProductCategory.Name
ORDER BY 
    ProductCategory.Name ASC                                                                    

-- Question 5 -- 

/*
    Using the sales table build a query that presents the ranking of the best-selling products only for the 
    products that sold in total more than $100. Present the name of the product, the total value of sales and the position in the ranking.
    Present a second select only for products of the color 'black'.
*/

SELECT 
    prod.Name AS Produto,
    SUM(sod.LineTotal) AS 'Total Sales',
    ROW_NUMBER() OVER(ORDER BY SUM(sod.LineTotal) DESC) AS Ranking
FROM 
    SalesOrderDetail sod
    INNER JOIN Product prod ON sod.ProductID = prod.ProductID
GROUP BY
     prod.Name
HAVING 
    SUM(sod.LineTotal) > 100 
ORDER BY
    SUM(sod.LineTotal) DESC

--Present a second select only for 'black' color products.
SELECT 
    prod.Name AS Product,
    SUM(sod.LineTotal) AS 'Total Sales',
    ROW_NUMBER() OVER(ORDER BY SUM(sod.LineTotal) DESC) AS Ranking
FROM 
    SalesOrderDetail sod
    INNER JOIN Product prod ON sod.ProductID = prod.ProductID
WHERE
     prod.Color = 'Black'
GROUP BY
     prod.Name
HAVING 
    SUM(sod.LineTotal) > 100 
ORDER BY
    SUM(sod.LineTotal) DESC
