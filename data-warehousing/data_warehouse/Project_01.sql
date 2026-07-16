--Creating Dim_Passenger table
CREATE TABLE Dim_Passenger (     
    Passenger_Key VARCHAR(50) PRIMARY KEY,
    First_Name VARCHAR(50) NULL,
	Last_Name VARCHAR(50) NULL,
	Gender VARCHAR(50) NULL,
	Age INT NULL,
	Age_Type VARCHAR(50) NULL
);
--Creating Dim_Nationality table
CREATE TABLE Dim_Nationality (     
    Nationality_ID VARCHAR(50) PRIMARY KEY,
    Nationality VARCHAR(50) NULL
);
--Creating Dim_Date table
CREATE TABLE Dim_Date (     
    Date_ID INT PRIMARY KEY,
    Departure_Date Date NULL,
	Month INT NULL,
	Quarter INT NULL,
	YEAR INT NULL
);
--Creating Dim_Location table
CREATE TABLE Dim_Location (     
    Location_ID INT PRIMARY KEY,
    Region_Name VARCHAR(200) NULL,
	Country_Name VARCHAR(200) NULL,
	Continent VARCHAR(200) NULL
);
--Creating Dim_Airport table
CREATE TABLE Dim_Airport (     
    Airport_ID INT PRIMARY KEY,
    Airport_Name VARCHAR(200) NULL,
	Airport_Size VARCHAR(200) NULL
);
--Creating Dim_Status table
CREATE TABLE Dim_Status (     
    Status_ID INT PRIMARY KEY,
    Flight_Status VARCHAR(50) NULL
);
--Creating Fact_Flights table
CREATE TABLE Fact_Flights (
    Flight_Key INT PRIMARY KEY,
    Passenger_Key VARCHAR(50) NULL,
    Nationality_ID VARCHAR(50) NULL,
    Date_ID INT NULL,
    Airport_ID INT NULL,
    Location_ID INT NULL,
    Status_ID INT NULL,
    FOREIGN KEY (Passenger_Key) REFERENCES Dim_Passenger(Passenger_Key),
	FOREIGN KEY (Nationality_ID) REFERENCES Dim_Nationality(Nationality_ID),
	FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID),
	FOREIGN KEY (Airport_ID) REFERENCES Dim_Airport(Airport_ID),
	FOREIGN KEY (Location_ID) REFERENCES Dim_Location(Location_ID),
	FOREIGN KEY (Status_ID) REFERENCES Dim_Status(Status_ID)
);

-- Inserting data values to the tables
COPY Dim_Passenger
FROM 'D:\PostgreSQL\17\data\Data Warehouse project\Dim_Passenger.csv'
WITH (FORMAT csv, HEADER true);

COPY Dim_Nationality
FROM 'D:\PostgreSQL\17\data\Data Warehouse project\Dim_Nationality.csv'
WITH (FORMAT csv, HEADER true);

COPY Dim_Date
FROM 'D:\PostgreSQL\17\data\Data Warehouse project\Dim_Date.csv'
WITH (FORMAT csv, HEADER true);

COPY Dim_Airport
FROM 'D:\PostgreSQL\17\data\Data Warehouse project\Dim_Airport.csv'
WITH (FORMAT csv, HEADER true);

COPY Dim_Location
FROM 'D:\PostgreSQL\17\data\Data Warehouse project\Dim_Location.csv'
WITH (FORMAT csv, HEADER true);

COPY Dim_Status
FROM 'D:\PostgreSQL\17\data\Data Warehouse project\Dim_Status.csv'
WITH (FORMAT csv, HEADER true);

COPY Fact_Flights
FROM 'D:\PostgreSQL\17\data\Data Warehouse project\Fact_Flights.csv'
WITH (FORMAT csv, HEADER true);

-- Testing if tables were correctly populated
--Select * from Dim_Passenger;

'''
DROP TABLE Dim_Passenger;
DROP TABLE Dim_Nationality;
DROP TABLE Dim_Date;
DROP TABLE Dim_Airport;
DROP TABLE Dim_Location;
DROP TABLE Dim_Status;
DROP TABLE Fact_Flights;
'''

-- SQL Queries for our Business Questions 
--Q1
SELECT 
l.country_name,
COUNT(*) AS total_passengers
FROM Fact_Flights f
JOIN Dim_Location l 
ON f.location_id = l.location_id
JOIN Dim_Date d 
ON d.Date_ID = f.Date_ID
WHERE d.YEAR = 2022
GROUP BY l.country_name
ORDER BY total_passengers DESC
LIMIT 10;

--Q2

SELECT 
n.Nationality,
COUNT(*) AS total_passengers
FROM Fact_Flights f
JOIN Dim_nationality n 
ON f.Nationality_ID = n.Nationality_ID
JOIN Dim_Location l
ON f.Location_ID = l.Location_ID
WHERE l.Country_Name = 'Australia'
GROUP BY n.Nationality
ORDER BY total_passengers DESC
LIMIT 10;


--Q3
SELECT 
d.Quarter,s.Flight_Status,
COUNT(*) AS total_passengers
FROM Fact_Flights f
JOIN Dim_Date d 
ON f.Date_ID = d.Date_ID
JOIN Dim_Status s
ON f.Status_ID  = s.Status_ID
JOIN Dim_Location l 
ON f.location_id = l.location_id
WHERE l.Country_Name = 'Australia'
GROUP BY d.Quarter,s.Flight_Status
ORDER BY d.Quarter;


--Q4
SELECT 
a.Airport_Size,s.Flight_Status,
COUNT(*) AS total_passengers
FROM Fact_Flights f
JOIN Dim_Airport a
ON f.Airport_ID = a.Airport_ID
JOIN Dim_Status s
ON f.Status_ID  = s.Status_ID
JOIN Dim_Location l 
ON f.location_id = l.location_id
WHERE l.Country_Name = 'Australia'
GROUP BY a.Airport_Size,s.Flight_Status
ORDER BY a.Airport_Size;


--Q5
SELECT 
p.Age_Type,l.Region_Name,
COUNT(*) AS total_passengers
FROM Fact_Flights f
JOIN Dim_Passenger p
ON f.Passenger_Key = p.Passenger_Key
JOIN Dim_Location l 
ON f.location_id = l.location_id
WHERE l.Country_Name = 'Australia'
GROUP BY p.Age_Type,l.Region_Name
ORDER BY total_passengers DESC;
