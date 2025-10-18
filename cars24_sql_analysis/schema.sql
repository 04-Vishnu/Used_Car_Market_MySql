-- creating a database name cars24

create database cars24;

use cars24;

-- Creating table name used_cars

CREATE TABLE used_cars (
	Manufacturer VARCHAR(50),
    Varient VARCHAR(100),
    Details VARCHAR(100),
    India_Locations VARCHAR(50),
    Model int,
    Distance_Travelled INT,
    Fuel_Type VARCHAR(50),
    Engine_Capacity VARCHAR(50),          -- Change datatype int
    Transmission VARCHAR(50),
    Price_INR VARCHAR(50)                -- Change datatype int
    );
    
    -- Load the CSV Data
    
    LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Dataset_Used Cars .csv"
    into table used_cars
    fields terminated BY ','
    enclosed BY '"'
    lines terminated BY '\n'
    ignore 1 ROWS ;
    
   -- Checking the data values
   
   select * from used_cars limit 10;