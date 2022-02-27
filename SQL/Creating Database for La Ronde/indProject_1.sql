use indProject;
CREATE TABLE Customer (
    CUSTOMER_ID VARCHAR(10),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    EMAIL VARCHAR(100),
    MOBILE_NUM CHAR(12),
    ADDRESS VARCHAR(500),
    GENDER VARCHAR(10),
    DOB VARCHAR(10),
    DATE_OF_REG VARCHAR(10),
    POSTAL_CODE CHAR(7),
    PRIMARY KEY (CUSTOMER_ID)
);

CREATE TABLE Ticket_Category (
    CATEGORY_OF_TICKET_ID INT,
    CATEGORY_OF_TICKET_DESC VARCHAR(50),
    PRIMARY KEY (CATEGORY_OF_TICKET_ID)
);

CREATE TABLE Payment_Method (
    PAYMENT_METHOD_ID INT,
    PAYMENT_METHOD_DESC VARCHAR(50),
    PRIMARY KEY (PAYMENT_METHOD_ID)
);


CREATE TABLE Ticket (
    TICKET_ID INTEGER,
    CUSTOMER_ID VARCHAR(10),
    PURCHASE_DATE CHAR(10),
    PROMO_APPLIED  INTEGER,
    CATEGORY_OF_TICKET_ID INTEGER,
    PAYMENT_METHOD_ID INTEGER,
    PURCHASE_MODE  VARCHAR(10),
    PRICE INTEGER,
    PRIMARY KEY (TICKET_ID),
    FOREIGN KEY (CUSTOMER_ID)
        REFERENCES Customer (CUSTOMER_ID),
        FOREIGN KEY (CATEGORY_OF_TICKET_ID) REFERENCES Ticket_Category(CATEGORY_OF_TICKET_ID),
        FOREIGN KEY (PAYMENT_METHOD_ID) REFERENCES Payment_Method(PAYMENT_METHOD_ID)
);



CREATE TABLE Facility (
    FACILITY_ID VARCHAR(10),
    FACILITY_DESC VARCHAR(200),
    FACILITY_TYPE  VARCHAR(20),
    FACILITY_CAPACITY  INTEGER,
    FACILITY_SUBTYPE  VARCHAR(100),
    LOCATION VARCHAR(100),
    PRIMARY KEY (Facility_ID)
);

CREATE TABLE Facilities_Tickets (
    FACILITY_TICKET_ID INTEGER,
    FACILITY_ID VARCHAR(10),
    TICKET_ID INTEGER,
    TIME_ACCESSED VARCHAR(100),
    PRIMARY KEY (FACILITY_TICKET_ID),
    FOREIGN KEY (FACILITY_ID)
        REFERENCES Facility (FACILITY_ID),
    FOREIGN KEY (TICKET_ID)
        REFERENCES Ticket (TICKET_ID)
);

CREATE TABLE Ride (
    RIDE_ID CHAR(4),
    RIDE_NAME VARCHAR(100),
    TYPE_OF_RIDE VARCHAR(30),
    CAPACITY_OF_A_RIDE VARCHAR(10),
    RIDE_HEIGHT_FT VARCHAR(10),
    YEAR_STARTED VARCHAR(10),
    DESCRIPTION VARCHAR(500),
    MIN_RIDE_HEIGHT_CM VARCHAR(20),
    MANUFACTURER VARCHAR(100),
    TOP_SPEED_MPH VARCHAR(10),
    TRACK_LENGTH_FT VARCHAR(10),
    ADDITIONAL_FEES CHAR(1),
    PRIMARY KEY (RIDE_ID)
);

CREATE TABLE Rides_Tickets (
    RIDE_TICKET_ID INTEGER,
    RIDE_ID CHAR(4),
    TICKET_ID INTEGER,
    TIME_ACCESSED TIMESTAMP,
    PRIMARY KEY (RIDE_TICKET_ID),
    FOREIGN KEY (RIDE_ID)
        REFERENCES Ride (RIDE_ID),
    FOREIGN KEY (TICKET_ID)
        REFERENCES Ticket (TICKET_ID)
);



UPDATE Rides_Tickets 
SET 
    TIME_ACCESSED = STR_TO_DATE(TIME_ACCESSED, '%Y-%m-%d %H:%i:%s');

UPDATE Customer 
SET 
    DOB = STR_TO_DATE(DOB, '%m/%d/%Y');
    
UPDATE Customer 
SET 
    DATE_OF_REG = STR_TO_DATE(DATE_OF_REG, '%m/%d/%Y');

UPDATE Ticket 
SET 
    PURCHASE_DATE = STR_TO_DATE(PURCHASE_DATE, '%d-%m-%Y');

UPDATE Facilities_Tickets 
SET 
    TIME_ACCESSED = STR_TO_DATE(TIME_ACCESSED, '%d/%m/%Y %H:%i'); 
    

 
 
use indProject;
-- 1
-- Objective: number of tickets sold and amount sold by year and month in order to figure out the trend:
-- Assumption: Aug 2020 is not considered as the date is not complete (until 2020-08-13)
SELECT 
    Year, month, Count, Sales, growth_rate
FROM
    (SELECT 
        Year,
            month,
            Count,
            Sales,
            IF(@last_entry = 0, 0, ROUND(((Sales - @last_entry) / @last_entry) * 100, 2)) growth_rate,
            @last_entry:=Sales
    FROM
        (SELECT @last_entry:=0) x, (SELECT 
        Year, month, Count, Sales
    FROM
        (SELECT 
        YEAR(purchase_date) Year,
            MONTH(purchase_date) Month,
            COUNT(ticket_id) Count,
            SUM(Price) AS Sales
    FROM
        Ticket
    WHERE
        purchase_date >= '2019-11-01'
            AND purchase_date <= '2020-07-31'
    GROUP BY YEAR(purchase_date) , MONTH(purchase_date)) temp) y) temp2;	

-- 2
-- Objective: The average number of ride & facility accessed per ticket.
SELECT 
    SUM(num_service) / COUNT(Ticket_ID) AS avg_num_access
FROM
    (SELECT 
        Ticket_ID, COUNT(Service_ID) AS num_service
    FROM
        (SELECT 
        Ticket_ID, Ride_ID AS Service_ID
    FROM
        Rides_Tickets UNION SELECT 
        Ticket_ID, Facility_ID
    FROM
        Facilities_Tickets) service -- all services including rides and facilities
    GROUP BY Ticket_ID) count_per_ID;


-- 3
-- Objective: Averaged Age of customers when they came to La Ronde for the first time (pruchase date of their first ticket).
-- (able to see what age group La Ronde attracts.)
-- Assumption: Consider only the customers who has purchased and has at least accessed a ride or facility. 
SELECT 
    ROUND(AVG(Age), 1) AS avg_age
FROM
    (SELECT 
        unique_c.Customer_ID,
            Date_first_entry,
            cc.DOB,
            Date_first_entry - cc.DOB AS Age
    FROM
        (SELECT 
        Customer_ID, MIN(Purchase_Date) AS Date_first_entry
    FROM
        (SELECT 
        c.Customer_ID, t.Purchase_Date
    FROM
        Customer c
    RIGHT JOIN Ticket t ON c.Customer_ID = t.Customer_ID -- join ticket
    RIGHT JOIN (SELECT 
        Ticket_ID, Ride_ID AS Service_ID
    FROM
        Rides_Tickets UNION SELECT 
        Ticket_ID, Facility_ID
    FROM -- all services including rides and facilities
        Facilities_Tickets) service ON service.Ticket_ID = t.Ticket_ID) ct -- join services
    GROUP BY Customer_ID) unique_c
    LEFT JOIN Customer cc ON cc.customer_ID = unique_c.Customer_ID) customer_age; -- join customers
    

-- 4
-- Objective: Find top 5 loyal customers who spent most money and get how many months they have been with La Ronde.
-- Assumption: the number of months with La Ronde is calculated from their first entry when they accesed 
-- at least one facility or ride to the last date of the database, which is 2020-08-13.
  SELECT 
    customer_loyalty.customer_ID,
    cl.Total_Paid,
    customer_loyalty.Months AS peiod_since_first_visit
FROM
    (SELECT 
        Customer_ID,
            MIN(Purchase_Date) AS first_entry,
            STR_TO_DATE('2020-08-13', '%Y-%m-%d') AS Until,
            ROUND(DATEDIFF('2020-08-13', MIN(Purchase_Date)) / 30, 0) Months -- visualize the start date, end date and duration
    FROM
        (SELECT 
        c.Customer_ID, t.Purchase_Date
    FROM
        Customer c
    RIGHT JOIN Ticket t ON c.Customer_ID = t.Customer_ID
    RIGHT JOIN (SELECT 
        Ticket_ID, Ride_ID AS Service_ID
    FROM
        Rides_Tickets UNION SELECT 
        Ticket_ID, Facility_ID
    FROM
        Facilities_Tickets) service ON service.Ticket_ID = t.Ticket_ID) ct
    GROUP BY Customer_ID) customer_loyalty
        JOIN
    (SELECT 
        customer_ID, SUM(Price) AS Total_paid
    FROM
        Ticket
    GROUP BY Customer_ID) cl ON cl.customer_ID = customer_loyalty.customer_ID
ORDER BY cl.Total_Paid DESC limit 5;

-- 5
-- Objective: Find the 10 most popular activities (ranked by number of accesses)
-- Assumption: Activities include both facilities and rides. 
SELECT 
    service.Service_ID, allser.service_name, COUNT(Ticket_ID) as num_accesses
FROM
    (SELECT 
        Ticket_ID, Ride_ID AS Service_ID
    FROM
        Rides_Tickets UNION SELECT 
        Ticket_ID, Facility_ID
    FROM
        Facilities_Tickets) service
        LEFT JOIN
    (SELECT 
        Facility_ID AS service_ID, Facility_desc AS service_name
    FROM
        Facility UNION SELECT 
        Ride_ID, Ride_Name
    FROM
        Ride) allser ON allser.service_ID = service.service_ID
GROUP BY Service_ID , service_Name order by num_accesses desc limit 10;

-- 6
-- Objective: Determine if applying additional fees decreases the popularity of a ride.
-- Assumption: Only Rides have additonal fees as the data indicates. 
SELECT 
    'With Addtional Fee' AS Category,
    COUNT(Ride_ID) / COUNT(DISTINCT (Ride_ID)) AS avg_visits
FROM
    (SELECT 
        r.Ride_ID, r.Ride_Name
    FROM
        ride r
    RIGHT JOIN Rides_Tickets rt ON r.Ride_ID = rt.Ride_ID
    WHERE
        Additional_fees = 'Y') with_fees 
UNION SELECT 
    'Without Addtional Fee',
    COUNT(Ride_ID) / COUNT(DISTINCT (Ride_ID))
FROM
    (SELECT 
        r.Ride_ID, r.Ride_Name
    FROM
        ride r
    RIGHT JOIN Rides_Tickets rt ON r.Ride_ID = rt.Ride_ID
    WHERE
        Additional_fees = 'N') without_fees;


-- 7
-- Objectvie: See if applying ticket promotions increases happiness (i.e.,people being happier and therefore stimulates the number of accesses) compared to no promo applied.
SELECT 
    Promo_Applied,
    COUNT(Ticket_ID) / COUNT(DISTINCT (Ticket_ID)) AS average_num_access
FROM
    (SELECT 
        t.Ticket_ID, t.Promo_Applied
    FROM
        Ticket t
    LEFT JOIN (SELECT 
        Ticket_ID, Ride_ID AS Service_ID
    FROM
        Rides_Tickets UNION SELECT 
        Ticket_ID, Facility_ID
    FROM
        Facilities_Tickets) service ON t.Ticket_ID = service.Ticket_ID) accesses
GROUP BY Promo_Applied;



-- 8 
-- Objective: compare the averaged number of accesses to facilities and rides for those buying annual passes to those who hold the other two type of tickets, 
-- for each category, display the most popular service (facility or ride)
SELECT 
    a.Categ_Ticket, a.service_ID, a.Count
FROM
    (SELECT 
        category.Category_of_Ticket_Desc AS Categ_Ticket,
            category.Service_ID,
            COUNT(category.Service_ID) AS count
    FROM
        (SELECT 
        t.Ticket_ID,
            t.Category_of_Ticket_ID,
            tc.Category_of_Ticket_Desc,
            service.Service_ID
    FROM
        Ticket t
    LEFT JOIN (SELECT 
        Ticket_ID, Ride_ID AS Service_ID
    FROM
        Rides_Tickets UNION SELECT 
        Ticket_ID, Facility_ID
    FROM
        Facilities_Tickets) service ON t.Ticket_ID = service.Ticket_ID
    LEFT JOIN Ticket_Category tc ON t.Category_of_Ticket_ID = tc.Category_of_Ticket_ID) category
    GROUP BY category.Category_of_Ticket_Desc , category.Service_ID) a
        INNER JOIN
    (SELECT 
        Categ_Ticket, MAX(count) AS maxCount
    FROM
        (SELECT 
        category.Category_of_Ticket_Desc AS Categ_Ticket,
            category.Service_ID,
            COUNT(category.Service_ID) AS count
    FROM
        (SELECT 
        t.Ticket_ID,
            t.Category_of_Ticket_ID,
            tc.Category_of_Ticket_Desc,
            service.Service_ID
    FROM
        Ticket t
    LEFT JOIN (SELECT 
        Ticket_ID, Ride_ID AS Service_ID
    FROM
        Rides_Tickets UNION SELECT 
        Ticket_ID, Facility_ID
    FROM
        Facilities_Tickets) service ON t.Ticket_ID = service.Ticket_ID
    LEFT JOIN Ticket_Category tc ON t.Category_of_Ticket_ID = tc.Category_of_Ticket_ID) category
    GROUP BY category.Category_of_Ticket_Desc , category.Service_ID) ab
    GROUP BY Categ_Ticket) b ON a.Categ_Ticket = b.Categ_Ticket
        AND a.Count = b.maxCount;

-- 9
-- Objective: see during which time period people like to access rides and facilities.
-- Assumption: there are three time period: morning 8am-12pm, afternoon 12pm-4pm, night 4pm-8am 
SELECT 
    Period, COUNT(Ticket_ID)
FROM
    (SELECT  
        Ticket_ID,
            Service_ID,
            CASE -- allocate timestamp to three periods in a day (i.e., morning, afternoon, and night)
                WHEN Time BETWEEN '08:00:00' AND '12:00:00' THEN 'Morning'
                WHEN Time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
                ELSE 'Night'
            END AS Period
    FROM
        (SELECT 
        Ticket_ID, Ride_ID AS Service_ID, TIME(Time_Accessed) Time
    FROM
        Rides_Tickets UNION SELECT 
        Ticket_ID, Facility_ID, Time_Accessed TIMEONLY
    FROM
        Facilities_Tickets) service) period
GROUP BY Period;


-- 10
-- Objective: compare school stuff and students with other clients to see if there are different in their favorite ride and facility.
-- School stuff and students are the customers whose email ends with 'edu'
SELECT 
    *
FROM
    indProject.Customer;
SELECT 
    cc.Customer_type, cc.Service_ID, service.Service_Name
FROM
    ((SELECT 
        'School_customer' AS Customer_type,
            Facility_ID AS Service_ID,
            COUNT(Facility_ID) AS Freq
    FROM
        (SELECT 
        ct.Customer_ID, ct.Ticket_ID, ft.Facility_ID
    FROM
        (SELECT 
        c.Customer_ID, t.Ticket_ID
    FROM
        (SELECT 
        Customer_ID
    FROM
        Customer
    WHERE
        Email LIKE '%edu') c
    LEFT JOIN Ticket t ON t.customer_ID = c.customer_ID) ct
    LEFT JOIN Facilities_Tickets ft ON ft.Ticket_ID = ct.Ticket_ID) cft
    GROUP BY Facility_ID
    ORDER BY Freq DESC
    LIMIT 1) UNION (SELECT 
        'School_customer', Ride_ID, COUNT(Ride_ID) AS Freq
    FROM
        (SELECT 
        ct.Customer_ID, ct.Ticket_ID, rt.Ride_ID
    FROM
        (SELECT 
        c.Customer_ID, t.Ticket_ID
    FROM
        (SELECT 
        Customer_ID
    FROM
        Customer
    WHERE
        Email LIKE '%edu') c
    LEFT JOIN Ticket t ON t.customer_ID = c.customer_ID) ct
    LEFT JOIN Rides_Tickets rt ON rt.Ticket_ID = ct.Ticket_ID) cft
    GROUP BY Ride_ID
    ORDER BY Freq DESC
    LIMIT 1) UNION (SELECT 
        'Non_School_customer',
            Facility_ID,
            COUNT(Facility_ID) AS Freq
    FROM
        (SELECT 
        ct.Customer_ID, ct.Ticket_ID, ft.Facility_ID
    FROM
        (SELECT 
        c.Customer_ID, t.Ticket_ID
    FROM
        (SELECT 
        Customer_ID
    FROM
        Customer
    WHERE
        Email NOT LIKE '%edu') c
    LEFT JOIN Ticket t ON t.customer_ID = c.customer_ID) ct
    LEFT JOIN Facilities_Tickets ft ON ft.Ticket_ID = ct.Ticket_ID) cft
    GROUP BY Facility_ID
    ORDER BY Freq DESC
    LIMIT 1) UNION (SELECT 
        'Non_School_customer', Ride_ID, COUNT(Ride_ID) AS Freq
    FROM
        (SELECT 
        ct.Customer_ID, ct.Ticket_ID, rt.Ride_ID
    FROM
        (SELECT 
        c.Customer_ID, t.Ticket_ID
    FROM
        (SELECT 
        Customer_ID
    FROM
        Customer
    WHERE
        Email NOT LIKE '%edu') c
    LEFT JOIN Ticket t ON t.customer_ID = c.customer_ID) ct
    LEFT JOIN Rides_Tickets rt ON rt.Ticket_ID = ct.Ticket_ID) cft
    GROUP BY Ride_ID
    ORDER BY Freq DESC
    LIMIT 1)) cc
        JOIN
    (SELECT 
        Facility_ID AS Service_ID, Facility_Desc AS Service_Name
    FROM
        Facility UNION SELECT 
        Ride_ID, Ride_Name
    FROM
        Ride) service ON service.Service_ID = cc.service_ID;






