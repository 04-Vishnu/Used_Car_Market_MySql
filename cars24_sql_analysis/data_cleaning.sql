-- Data Cleaning and Transformation for accurate analysis
   
   desc used_cars;
   
   select count(*) as total_count from used_cars;
   
   -- Finding duplicate values in the data table
   
   select Manufacturer,	Varient, Details, India_Locations, Model, Distance_Travelled, Fuel_Type, Engine_Capacity, Transmission, Price_INR,
count(*) as duplicate_count from used_cars
group by Manufacturer, Varient,	Details, India_Locations, Model, Distance_Travelled, Fuel_Type, Engine_Capacity, Transmission, Price_INR
having count(*) > 1;

-- Finding duplicated values by total count using CTE
   
 with duplicated_count as(
   select Manufacturer,	Varient, Details, India_Locations, Model, Distance_Travelled, Fuel_Type, Engine_Capacity, Transmission, Price_INR,
count(*) as duplicate_count from used_cars
group by Manufacturer, Varient,	Details, India_Locations, Model, Distance_Travelled, Fuel_Type, Engine_Capacity, Transmission, Price_INR
having count(*) > 1 
)
select count(*) as duplicated_numbers from duplicated_count;


-- Check using trim function to see if that shows more duplicated values

select count(*) as null_varient from used_cars where varient = '';

select trim(Manufacturer),	trim(Varient), trim(Details), trim(India_Locations), trim(Model), trim(Distance_Travelled),
trim(Fuel_Type), trim(Engine_Capacity), trim(Transmission), trim(Price_INR), count(*) as count_dup
from used_cars
group by trim(Manufacturer),	trim(Varient), trim(Details), trim(India_Locations), trim(Model), trim(Distance_Travelled),
trim(Fuel_Type), trim(Engine_Capacity), trim(Transmission), trim(Price_INR)
having count(*) > 1 ;
    
with counted_dup as (
select trim(Manufacturer),	trim(Varient), trim(Details), trim(India_Locations), trim(Model), trim(Distance_Travelled),
trim(Fuel_Type), trim(Engine_Capacity), trim(Transmission), trim(Price_INR), count(*) as count_dup
from used_cars
group by trim(Manufacturer),	trim(Varient), trim(Details), trim(India_Locations), trim(Model), trim(Distance_Travelled),
trim(Fuel_Type), trim(Engine_Capacity), trim(Transmission), trim(Price_INR)
having count(*) > 1
)
select count(*) as dupli_co from counted_dup ;

-- Updating the table using trim function to fix any spaces 

update used_cars
set Manufacturer= trim(Manufacturer),	Varient= trim(Varient), Details= trim(Details), India_Locations= trim(India_Locations), 
Model= trim(Model), Distance_Travelled= trim(Distance_Travelled), Fuel_Type= trim(Fuel_Type), 
Engine_Capacity= trim(Engine_Capacity), Transmission= trim(Transmission), Price_INR= trim(Price_INR) ;

-- Updating table to convert empty strings into NULL using NULLIF

update used_cars
set Manufacturer= nullif(Manufacturer, ''),	Varient= nullif(Varient, ''), Details= nullif(Details, ''), India_Locations= nullif(India_Locations, ''), 
Model= nullif(Model, ''), Distance_Travelled= nullif(Distance_Travelled, ''), Fuel_Type= nullif(Fuel_Type, ''), 
Engine_Capacity= nullif(Engine_Capacity, ''), Transmission= nullif(Transmission, ''), Price_INR= nullif(Price_INR, '') ;

-- Updating the NULL into UNKNOWN using COALESCE

update used_cars
set Manufacturer= coalesce(Manufacturer, 'UNKNOWN'),	Varient= coalesce(Varient, 'UNKNOWN'), Details= coalesce(Details, 'UNKNOWN'), 
India_Locations= coalesce(India_Locations, 'UNKNOWN'), Model= coalesce(Model, 'UNKNOWN'), Distance_Travelled= coalesce(Distance_Travelled, 'UNKNOWN'), 
Fuel_Type= coalesce(Fuel_Type, 'UNKNOWN'), Engine_Capacity= coalesce(Engine_Capacity, 'UNKNOWN'), 
Transmission= coalesce(Transmission, 'UNKNOWN'), Price_INR= coalesce(Price_INR, 'UNKNOWN') ;


select * from used_cars limit 10;

-- creating new table adding distinct data into it

create table used_cars_cleaned as
select distinct * from used_cars ;

-- Checking the duplications from old and new data created

select count(*) as original_data from used_cars;
select count(*) as cleaned_data from used_cars_cleaned;

select * from used_cars_cleaned limit 20;

desc used_cars_cleaned;

-- clean the engine capacity and outliers in Price column

update used_cars_cleaned set engine_capacity = 0 where engine_capacity = 'cc' ;

select engine_capacity, count(*) as frequency from used_cars_cleaned 
group by engine_capacity order by frequency ;

-- Updating the used_cars_cleaned of Engine_capacity unrealistic values.

update used_cars_cleaned set
engine_capacity = NULL 
where engine_capacity < 500 OR
engine_capacity > 5000 ;

select count(*) as null_count from used_cars_cleaned where engine_capacity is null;


select distinct engine_capacity from used_cars_cleaned
where engine_capacity not REGEXP '^[0-9]+$'
and engine_capacity is not null;

update used_cars_cleaned set engine_capacity = Round(engine_capacity)
where engine_capacity is not null;

-- altering the datatype of engine_capacity

alter table used_cars_cleaned modify column engine_capacity int ;


update used_cars_cleaned set engine_capacity = 0 where engine_capacity is null ;

select round(avg(engine_capacity)) as avg_cc from used_cars_cleaned where engine_capacity is not null;

update used_cars_cleaned set engine_capacity = 1345
where engine_capacity = 0 ;

-- Handling the Price column call values and outliers

update used_cars_cleaned set price_INR = null  -- This query is not working do check upcomming queries
where trim(lower(price_INR)) = 'call' ;

alter table used_cars_cleaned add column Price_Stat varchar(50);


    
select distinct price_inr from used_cars_cleaned where price_inr like '%Call%' ;

desc used_cars_cleaned;

-- Used HEX to find out the exact bytes stored in the Call value where I couldnt change the call value.

SELECT price_INR, HEX(price_INR) 
FROM used_cars_cleaned 
WHERE price_INR LIKE '%Call%';

-- updating the call value into null 

update used_cars_cleaned
set price_inr = Null
where replace(TRIM(price_inr), '\r', '') = 'Call' ;

-- used case statement to input updated variables in price_stat

update used_cars_cleaned set
price_stat = 
case
	when price_INR is null then 'Call'
    else 'Available'
    end ;

select * from used_cars_cleaned where price_stat = 'Call' ;


-- Altered price_inr to int datatype
alter table used_cars_cleaned modify column price_inr int ;


-- Fagging new column price_outlier, the Price_INR values greater than 1 Crore as 'Premium' and less than 1 Crore as 'Regular'

alter table used_cars_cleaned add column price_outlier Varchar(100);

update used_cars_cleaned 
set price_outlier = 'Premium'
where price_inr > 10000000 ;

update used_cars_cleaned
set price_outlier = 'Regular'
where price_inr < 10000000 or price_inr is null;

select * from used_cars_cleaned order by manufacturer limit 10;

-- Finally added a id column as primary key

alter table used_cars_cleaned add column id int auto_increment primary key first;

desc used_cars_cleaned;