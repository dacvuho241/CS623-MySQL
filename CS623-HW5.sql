-- 1.	What are the #prods whose name begins with a ’p’ and are less than $300.00?
SELECT P.prods
FROM Product P
WHERE P.pname=’p%%%’ and P.price < 300.00

-- 2.	Names of the products stocked in "d2".
-- (a) without in/not in
SELECT P.name
FROM Product P AND Stock S
WHERE P.prod = S.prod AND S.dep =’d2’

-- (b) with in/not in
SELECT P.name
FROM Product P
WHERE P.prod IN
(SELECT S.prod 
FROM Stock S
WHERE S.dep=’d2’)

-- 3.	#prod and names of the products that are out of stock.
-- (a) without in/not in
SELECT P.prod , P.pname 
FROM Product P AND Stock S
WHERE P.prod=S.prod AND S.quantity < 1

-- (b) with in/not in
SELECT P.prod, P.pname 
FROM Product P
WHERE P.Prod IN 
	(SELECT S.quantity 
	FROM Stock S
	WHERE S.quantity < 1)

-- 4.	Addresses of the depots where the product "p1" is stocked.
-- (a) without exists/not exists and without in/not in
SELECT D.addr
FROM Depot D AND Stock S
WHERE D.dep = S.dep AND S.dep = ‘d1’ AND S.quantity > 0

-- (b) with in/not in
SELECT D.addr
FROM Depot D AND Stock S
WHERE D.dep IN
(SELECT  S.dep
FROM Stock 
WHERE S.dep = ‘d1’ AND S.quantity > 0

-- (c) with exists/not exists
SELECT D.addr
FROM Depot D
WHERE NOT EXIST
	(SELECT S.dep, S.quantity
	FROM Stock S
	WHERE S.dep = ‘d1’ AND S.quantity > 0)
-- 5.	#prods whose price is between $250.00 and $400.00.
-- (a) using intersect.
SELECT P.prod 
FROM Product P
WHERE P.price > 250.00
INTERSECT
(SELECT P.prod 
FROM Product P
WHERE P.price < 400.00)

-- (b) without intersect.
SELECT P.prod 
FROM Product P
WHERE P.price BETWEEN 250.00 AND  400.00

-- 6.	How many products are out of stock?
SELECT COUNT (S.prod)
FROM Stock S
WHERE S.quantity < 1

-- 7.	 Average of the prices of the products stocked in the "d2" depot.
SELECT S.prod, AVG(P.price)
FROM Product P, Stock S
WHERE P.prod = S.prod AND S.prod = ‘d2’

-- 8.	#deps of the depot(s) with the largest capacity (volume).
SELECT D.dep, MAX(D.volume) AS Largest_Capacity
FROM Depot D
GROUP BY D.dep

-- 9.	Sum of the stocked quantity of each product.
SELECT S.prod , SUM(S.quantity), COUNT(S.prod)
FROM Stock S
GROUP BY P.prod

-- 10.	Products names stocked in at least 3 depots.
-- (a) using count
SELECT P.name, COUNT (DISTINCT S.prod)
FROM product P, Stock S
GROUP BY S.dep
HAVING  COUNT (DISTICNT S.prod )> 2

-- (b) without using count
-- 11.	#prod stocked in all depots.
-- (a) using count
SELECT P.prod, COUNT(S.prod)
FROM Product P, Stock S
WHERE P.prod = S.prod 
GROUP BY P.prod

-- (b) using exists/not exists
SELECT S.prod
FROM Stock S
WHERE EXIST 
	(SELECT D.dep
	FROM Depot 
WHERE D.dep = S.dep)
