-- 1
Use assign2;
SELECT
    o.orderNumber,
    o.orderDate,
    od.productCode,
    od.quantityOrdered,
    od.priceEach,
    od.quantityOrdered * od.priceEach AS totalPayment,
    o.customerNumber,
    c.customerName
FROM
    orders o
        JOIN
    orderdetails od ON od.orderNumber = o.orderNumber
        AND o.orderNumber = 10101
        JOIN
    customers c ON o.customerNumber = c.customerNumber;

-- 2
    SELECT 
    SUM(totalPayment) AS Total_Payment,
    COUNT(productCode) AS Product_Variety,
    MAX(priceEach) AS Max_Price,
    MIN(priceEach) AS Min_Price
FROM
    (SELECT 
        o.orderNumber,
            o.orderDate,
            od.productCode,
            od.quantityOrdered,
            od.priceEach,
            od.quantityOrdered * od.priceEach AS totalPayment,
            o.customerNumber,
            c.customerName
    FROM
        orders o
    JOIN orderdetails od ON od.orderNumber = o.orderNumber
        AND o.orderNumber = 10101
    JOIN customers c ON o.customerNumber = c.customerNumber) alias;


-- 3
SELECT 
    c.customerNumber, c.customerName, c.city, c.phone
FROM
    customers c
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            orders o
        WHERE
            c.customerNumber = o.customerNumber)
        AND c.city = 'Madrid'
ORDER BY c.customerNumber DESC;

-- 4
SELECT 
    Q4.productCode, p.productName, Q4.totalQuantityOrdered
FROM
    (SELECT 
    productCode, SUM(quantityOrdered) as totalQuantityOrdered
FROM
    orderdetails 
GROUP BY productCode) Q4
        JOIN
    products p ON Q4.productCode = p.productCode
ORDER BY totalQuantityOrdered DESC
LIMIT 10;

-- Q5
SELECT 
    orderNumber, productCode, quantityOrdered, avg
FROM
    (SELECT 
        Q5.productCode,
            Q5.totalQuantityOrdered,
            Q5.orderNumber,
            Q5.quantityOrdered,
            C.cnt,
            Q5.totalQuantityOrdered / C.cnt AS avg
    FROM
        (SELECT 
        Q4.productCode,
            Q4.totalQuantityOrdered,
            od.orderNumber,
            od.quantityOrdered
    FROM
        (SELECT 
        productCode, SUM(quantityOrdered) AS totalQuantityOrdered
    FROM
        orderdetails
    GROUP BY productCode) Q4
    RIGHT JOIN orderdetails od ON Q4.productCode = od.productCode) Q5
    INNER JOIN (SELECT 
        productCode, COUNT(productCode) AS cnt
    FROM
        (SELECT 
        Q4.productCode,
            Q4.totalQuantityOrdered,
            od.orderNumber,
            od.quantityOrdered
    FROM
        (SELECT 
        productCode, SUM(quantityOrdered) AS totalQuantityOrdered
    FROM
        orderdetails
    GROUP BY productCode) Q4
    RIGHT JOIN orderdetails od ON Q4.productCode = od.productCode) Q5
    GROUP BY productCode) C ON Q5.productCode = C.productCode) Q5_final
WHERE
    quantityOrdered < avg
ORDER BY quantityOrdered;
-- 6
SELECT 
    *
FROM
    (SELECT 
        customers.customerName,
            atp.customerNumber,
            (atp.toBePAid - pcl.TotalPaid) AS amountPayable,
            pcl.creditLimit
    FROM
        (SELECT 
        customerNumber, SUM(amount_per_order) AS toBePAid
    FROM
        (SELECT 
        orders.customerNumber,
            total.orderNumber,
            total.amount_per_order
    FROM
        orders
    JOIN (SELECT 
        od.orderNumber,
            SUM(od.quantityOrdered * od.priceEach) AS amount_per_order
    FROM
        orderdetails od
    GROUP BY od.orderNumber) total ON total.orderNumber = orders.orderNumber) AS oneTable
    GROUP BY customerNumber) atp
    JOIN (SELECT 
        c.customerNumber, SUM(p.Amount) AS TotalPaid, c.creditlimit
    FROM
        customers c
    JOIN payments p ON c.customerNumber = p.customerNumber
    GROUP BY customerNumber) pcl ON atp.customerNumber = pcl.customerNumber
    JOIN customers ON customers.customerNumber = atp.customerNumber) Q6_final
WHERE
    amountPayable > creditLimit;

-- 7
ALTER TABLE customers
ADD creditworthiness varchar(20) NOT NULL
DEFAULT "good";

UPDATE customers SET creditworthiness = 'bad'
WHERE customerNumber IN (SELECT customerNumber FROM (SELECT 
                customers.customerName,atp.customerNumber, (atp.toBePAid - pcl.TotalPaid) AS amountPayable,
                pcl.creditLimit
            FROM (SELECT 
                customerNumber, SUM(amount_per_order) AS toBePAid
            FROM (SELECT 
                orders.customerNumber, total.orderNumber, total.amount_per_order
            FROM orders
            JOIN (SELECT 
                od.orderNumber,
                    SUM(od.quantityOrdered * od.priceEach) AS amount_per_order
            FROM
                orderdetails od
            GROUP BY od.orderNumber) total ON total.orderNumber = orders.orderNumber) AS oneTable
            GROUP BY customerNumber) atp
            JOIN (SELECT 
                c.customerNumber, SUM(p.Amount) AS TotalPaid, c.creditlimit
            FROM
                customers c
            JOIN payments p ON c.customerNumber = p.customerNumber
            GROUP BY customerNumber) pcl ON atp.customerNumber = pcl.customerNumber
            JOIN customers ON customers.customerNumber = atp.customerNumber) Q6_final
        WHERE
            amountPayable > creditLimit);
            
SELECT 
    *
FROM
    customers
ORDER BY creditworthiness;

-- 8
SELECT DISTINCT
    middle_class.lastName,
    middle_class.firstName,
    middle_class.jobTitle,
    COUNT(*) AS num_employee,
    middle_class.manager
FROM
    (SELECT 
        m.employeeNumber AS middle_class_ID,
            m.lastName,
            m.firstName,
            m.jobTitle,
            bm.employeeNumber AS manager
    FROM
        employees e
    JOIN employees m ON e.reportsTo = m.employeeNumber
    JOIN employees bm ON m.reportsTo = bm.employeeNumber) middle_class
GROUP BY middle_class_ID;

-- 9 
SELECT 
    sales.productLine, SUM(sales.totalSales) AS TotalSales
FROM
    (SELECT 
        pl.productLine,
            p.productCode,
            od.quantityOrdered * od.priceEach AS totalSales
    FROM
        productlines pl
    RIGHT JOIN products p ON p.productLine = pl.productLine
    RIGHT JOIN orderdetails od ON od.productCode = p.productCode) sales
GROUP BY sales.productLine
ORDER BY TotalSales ASC
LIMIT 1;

-- 10 
SELECT 
    t.customerNumber, COUNT(distinct(c.productCode)) sameProduct
FROM
    (SELECT 
        o.customerNumber, od.productCode
    FROM
        orders o
    RIGHT JOIN orderdetails od ON o.orderNumber = od.orderNumber) c
        JOIN
    (SELECT 
        o.customerNumber, od.productCode
    FROM
        orders o
    RIGHT JOIN orderdetails od ON o.orderNumber = od.orderNumber) t ON c.productCode = t.productcode
        AND c.customerNumber != t.customerNumber
WHERE
    c.customerNumber = 124
GROUP BY t.customerNumber
ORDER BY sameProduct DESC
LIMIT 1;
    
    
    
    SELECT 
    o.customerNumber AS Customer_id,
    COUNT(o.productCode) AS Same_products
FROM
    (SELECT DISTINCT
        p.customerNumber, p.productCode
    FROM
        (SELECT 
        orders.customerNumber, orderdetails.productCode
    FROM
        orders, orderdetails
    WHERE
        orders.orderNumber = orderdetails.orderNumber) p
    WHERE
        p.productCode IN (SELECT DISTINCT
                orderdetails.productCode AS productid
            FROM
                orders, orderdetails
            WHERE
                orders.customerNumber = 124
                    AND orderdetails.orderNumber = orders.orderNumber)) o
WHERE
    o.customerNumber != 124
GROUP BY o.customerNumber
ORDER BY Same_products DESC
LIMIT 1;

      
SELECT 
    customerNumber, COUNT(DISTINCT (productCode)) countx
FROM
    (SELECT 
        o.customerNumber, od.productCode
    FROM
        orders o
    JOIN orderdetails od ON o.ordernumber = od.ordernumber
    JOIN (SELECT DISTINCT
        od.productCode
    FROM
        orders o
    JOIN orderdetails od ON o.ordernumber = od.ordernumber
        AND o.customerNumber = 124) a ON a.productCode = od.productCode) b
WHERE
    customerNumber != 124
GROUP BY customerNumber
ORDER BY countx DESC
LIMIT 1;
	