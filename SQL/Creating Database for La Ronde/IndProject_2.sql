Use indProject_external;
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


CREATE TABLE Weather (
    WEATHER_ID INT PRIMARY KEY,
    WEATHER_TYPE VARCHAR(20)
);

CREATE TABLE Day_Type (
    DAY_TYPE_ID INT PRIMARY KEY,
    DAY_TYPE VARCHAR(20)
);

CREATE TABLE Facilities_Tickets (
    FACILITY_TICKET_ID INTEGER,
    FACILITY_ID VARCHAR(10),
    TICKET_ID INTEGER,
    DATE_ACCESSED Datetime,
    WEATHER_ID int,
    DATE_TYPE_ID int,
    PRIMARY KEY (FACILITY_TICKET_ID),
    FOREIGN KEY (FACILITY_ID)
        REFERENCES Facility (FACILITY_ID),
    FOREIGN KEY (TICKET_ID)
        REFERENCES Ticket (TICKET_ID),
	FOREIGN KEY (WEATHER_ID)
        REFERENCES Weather(WEATHER_ID),
	FOREIGN KEY (DATE_TYPE_ID)
        REFERENCES Day_Type(DAY_TYPE_ID)
);


CREATE TABLE Rides_Tickets (
    RIDE_TICKET_ID INTEGER,
    RIDE_ID CHAR(4),
    TICKET_ID INTEGER,
    DATE_ACCESSED TIMESTAMP,
    WEATHER_ID int,
    DATE_TYPE_ID int,
    PRIMARY KEY (RIDE_TICKET_ID),
    FOREIGN KEY (RIDE_ID)
        REFERENCES Ride (RIDE_ID),
    FOREIGN KEY (TICKET_ID)
        REFERENCES Ticket (TICKET_ID),
	FOREIGN KEY (WEATHER_ID)
        REFERENCES Weather(WEATHER_ID),
	FOREIGN KEY (DATE_TYPE_ID)
        REFERENCES Day_Type(DAY_TYPE_ID)
);



UPDATE Customer 
SET 
    DOB = STR_TO_DATE(DOB, '%m/%d/%Y');
    
UPDATE Customer 
SET 
    DATE_OF_REG = STR_TO_DATE(DATE_OF_REG, '%m/%d/%Y');

UPDATE Ticket 
SET 
    PURCHASE_DATE = STR_TO_DATE(PURCHASE_DATE, '%d-%m-%Y');


use indProject_external;
-- 1
-- Objective: find out if customers' accesses to facilities and rides are affected by weathers, and if so, which weather condition impedes the most.
-- Assumption: Five weather types: Rainy, Snowy, Too Hot, Too Cold, Moderate.
SELECT 
    weather.weather_type AS Weather,
    rtft.access_per_Ticket AS Avg_Access_per_Ticket
FROM
    ((SELECT 
        weather_ID,
            COUNT(Ticket_ID) / COUNT(DISTINCT (Ticket_ID)) AS access_per_ticket
    FROM
        (SELECT 
        Ride_ID AS service_ID, Ticket_ID, Weather_ID
    FROM
        rides_tickets UNION ALL SELECT 
        Facility_ID, Ticket_ID, Weather_ID
    FROM
        facilities_tickets) rft
    GROUP BY weather_ID) rtft)
        JOIN
    weather ON weather.weather_ID = rtft.Weather_ID;

-- 2
-- Find out if male customers are more willing to access rides and facilities in extreme weathers (i.e. weathers other than moderate)
SELECT 
    a.gender,
    a.access_per_ticket AS access_good_weather,
    b.access_per_ticket AS access_bad_weather,
    FORMAT((a.access_per_ticket - b.access_per_ticket) / a.access_per_ticket,
        2) AS percent_decrease
FROM
    (SELECT 
        gender,
            COUNT(ticket_ID) / COUNT(DISTINCT (ticket_ID)) AS access_per_ticket
    FROM
        (SELECT 
        c.customer_ID,
            c.gender,
            t.ticket_ID,
            rft.service_ID,
            rft.Weather_ID
    FROM
        ticket t
    JOIN customer c ON c.customer_ID = t.customer_ID
    JOIN (SELECT 
        Ride_ID AS service_ID, Ticket_ID, Weather_ID
    FROM
        rides_tickets UNION ALL SELECT 
        Facility_ID, Ticket_ID, Weather_ID
    FROM
        facilities_tickets) rft ON rft.Ticket_ID = t.ticket_ID
    WHERE
        weather_ID = 1) w
    GROUP BY gender) a
        JOIN
    (SELECT 
        gender,
            COUNT(ticket_ID) / COUNT(DISTINCT (ticket_ID)) AS access_per_ticket
    FROM
        (SELECT 
        c.customer_ID,
            c.gender,
            t.ticket_ID,
            rft.service_ID,
            rft.Weather_ID
    FROM
        ticket t
    JOIN customer c ON c.customer_ID = t.customer_ID
    JOIN (SELECT 
        Ride_ID AS service_ID, Ticket_ID, Weather_ID
    FROM
        rides_tickets UNION ALL SELECT 
        Facility_ID, Ticket_ID, Weather_ID
    FROM
        facilities_tickets) rft ON rft.Ticket_ID = t.ticket_ID
    WHERE
        weather_ID != 1) w
    GROUP BY gender) b ON a.gender = b.gender;

-- 3 
-- Check if weather affects more accesses to rides than facilities. (rides are mostly outdoor whereas facilities are mostly indoor)
CREATE VIEW xxRide AS
    SELECT 
        'Ride',
        'Good Weather' AS Weather,
        COUNT(ticket_ID) / COUNT(DISTINCT (ticket_ID)) AS avg_access
    FROM
        Rides_tickets
    WHERE
        weather_ID = 1 
    UNION SELECT 
        'Ride',
        'Bad Weather',
        COUNT(ticket_ID) / COUNT(DISTINCT (ticket_ID)) AS avg_access
    FROM
        Rides_tickets
    WHERE
        weather_ID != 1;

CREATE VIEW xxFacility AS
    SELECT 
        'Facility',
        'Good Weather' AS Weather,
        COUNT(ticket_ID) / COUNT(DISTINCT (ticket_ID)) AS avg_access
    FROM
        Facilities_tickets
    WHERE
        weather_ID = 1 
    UNION SELECT 
        'Facility',
        'Bad Weather',
        COUNT(ticket_ID) / COUNT(DISTINCT (ticket_ID))
    FROM
        Facilities_tickets
    WHERE
        weather_ID != 1;

(SELECT 
    x.Ride AS Ride_or_Facility,
    x.Weather,
    x.avg_access,
    y.Weather,
    y.avg_access,
    (y.avg_access - x.avg_access) / x.avg_access AS '%increase'
FROM
    xxRide x
        JOIN
    xxRide y ON x.Ride = y.Ride
        AND x.Weather != y.Weather
LIMIT 1) UNION (SELECT 
    x.Facility,
    x.Weather,
    x.avg_access,
    y.Weather,
    y.avg_access,
    (y.avg_access - x.avg_access) / x.avg_access AS '%increase'
FROM
    xxFacility x
        JOIN
    xxFacility y ON x.Facility = y.Facility
        AND x.Weather != y.Weather
LIMIT 1);


-- 4
-- more tickets(distinct) per day on holidays.

SELECT 
    Day_Type.Day_type 'Day Type',
    dt.ticket_per_day 'Ticket per Day'
FROM
    (SELECT 
        Date_type_ID,
            COUNT(DISTINCT (Ticket_ID)) / COUNT(DISTINCT (Date_accessed)) ticket_per_day
    FROM
        (SELECT 
        Ride_ID AS service_ID,
            Ticket_ID,
            Date_accessed,
            Date_type_ID
    FROM
        rides_tickets UNION ALL SELECT 
        Facility_ID, Ticket_ID, Date_accessed, Date_type_ID
    FROM
        facilities_tickets) rft
    GROUP BY Date_Type_ID) dt
        JOIN
    Day_type ON Day_type.Day_type_ID = dt.Date_type_ID;

-- 5
-- the most popular ride for each of the three types of days.

SELECT 
    dt.day_type 'Day Type', r.ride_name 'Favorite Ride'
FROM
    (SELECT 
        a.Date_Type_ID, a.max_count, b.ride_ID
    FROM
        (SELECT 
        Date_Type_ID, MAX(count) max_count
    FROM
        (SELECT 
        Date_Type_ID, ride_id, COUNT(ride_id) count
    FROM
        Rides_Tickets
    GROUP BY date_type_id , ride_id) a
    GROUP BY Date_Type_ID) a
    JOIN (SELECT 
        Date_Type_ID, ride_id, COUNT(ride_id) count
    FROM
        Rides_Tickets
    GROUP BY date_type_id , ride_id) b ON a.Date_Type_ID = b.Date_Type_ID
        AND a.max_count = b.count) c
        JOIN
    day_type dt ON dt.day_type_id = c.date_type_id
        JOIN
    Ride r ON r.Ride_ID = c.Ride_ID;

