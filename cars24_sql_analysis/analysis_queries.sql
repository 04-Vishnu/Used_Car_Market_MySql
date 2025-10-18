-- Data Analysis of Market Trend and metrics in cars24 dataset.


/* 1. Count of cars by manufacturer to find which cars are in high demend for sale.

Finding: I find that Toyota, suzuki, Honda are the higer percent of demanding cars in India
*/

select manufacturer, count(manufacturer) as count_manufacturers from used_cars_cleaned 
group by manufacturer order by count_manufacturers desc;

/*
2. Count Number of cars based on model

The demand for vintage model cars are very low, and the stock keeping cars for pre 2003 model are very less.
The available car models are starting from year 1944 - 2023
Used CTE to calculate count of cars greater than 1000.
*/

select model, count(model) as number_of_cars_count from used_cars_cleaned
group by model order by number_of_cars_count desc;



with cars_greater_1000 as (
select model, count(model) as number_of_cars_count from used_cars_cleaned
group by model order by model desc
)
select model, number_of_cars_count from cars_greater_1000 where number_of_cars_count > 1000 ;

-- 3. Average price by car model, considering within 'Regular' Price_outlier.
-- I find that older model cars have low avg price_inr and the recent model cars are priced considerably higher.

select manufacturer, model, round(avg(price_inr)) as avg_price_inr
from used_cars_cleaned
where price_outlier = 'Regular' and
price_inr is not null
group by manufacturer, model
order by avg_price_inr desc;

/*
Looking into the top car listings such as 'Suzuki', 'Honda' and 'Toyota' a high demanding car brands with lower distance travelled command higher prices.
As mileage increases, resale value drops, especially after 100K km.
*/

select manufacturer, model, round(avg(price_inr)) as average_price, max(distance_travelled) as max_distance_travelled
from used_cars_cleaned
where price_outlier = 'Regular' and manufacturer in ('Suzuki', 'Toyota', 'Honda')
group by Manufacturer, model 
order by model desc;

/*
4. Count of car make where I find that majority of Indian brand such as Suzuki, Korean brands have high in numbers.
Locally made and regular use cars have taken the spot, less and minimal numbers of Imported and luxury cars which are priced high.
I find that analysis based on high demanding cars will help in find insights for large number of consumers who prefer more generic cars.
*/

select manufacturer, count(manufacturer) as count_manufacturer
from used_cars_cleaned group by Manufacturer
order by count_manufacturer desc; 

/*
5. Which car make and model travelled maximum distance.
As the Suzuki, Toyota, Honda takes the crown in maximum distance travelled cars.
Quite the same cars with recent make have priced higher and older is less. 
*/

select manufacturer, model, round(avg(price_inr)) as average_price, max(distance_travelled) as max_distance_travelled
from used_cars_cleaned
where price_outlier = 'Regular'
group by Manufacturer, model 
order by max_distance_travelled desc;

/*
6. Which fuel type cars have higher numbers.
Petrol cars are the highest numbers ranking 90.59 percentage of avalilable cars type.
*/

select fuel_type, count(fuel_type) as count_fuel_type,
round(count(fuel_type) * 100 / 
sum(count(fuel_type)) over (), 2 )
as percentage_count
from used_cars_cleaned 
group by fuel_type
order by count_fuel_type desc;

-- 7. Average, min, max price per manufacturer excluding Null and outlier price.

select manufacturer,
round(AVG(price_INR)) as avg_price,
min(price_INR) as min_price,
max(price_INR) as max_price
from used_cars_cleaned
where price_INR is not null and price_outlier = 'Regular'
group by manufacturer
order by avg_price desc;

-- 8. Price with Model analysis -- Find that past model 2000 are high is total number of cars

select model as model_year,
round(AVG(price_INR)) as avg_price,
count(*) as total_cars
from used_cars_cleaned
where price_INR is not null and price_outlier = 'Regular'
group by model_year
order by total_cars;

/*
9. Average price by fuel Type
Anlaysis find that Electric cars are highly priced and petrol cars are high in numbers and their price is much lesser than diesel and hybrid cars.
Finally CNG and LPG are the least average priced cars.
*/

select fuel_type, round(AVG(price_INR)) AS avg_price
from used_cars_cleaned
where price_INR is not null and  price_outlier = 'Regular'
group by fuel_type
order by avg_price desc;

/*
10 Using case statement to find which engine Capacity cars with average price and cars Count.
We find that engine range between 1200- 1600 cc are higher numbers and less than 1200 cc takes the second highest.
Greater 2000 cc are considered as luxury varient and count is much lesser.
*/

select case
	when engine_capacity < 1200 then 'less_than_1200cc'
	when engine_capacity between 1200 and 1600 then '1200-1600cc'
	when engine_capacity between 1601 and 2000 then '1601-2000cc'
		else '>2000cc'
       end as engine_ranges,
	round(AVG(price_INR)) as avg_price,
	count(*) as cars_count
from used_cars_cleaned
where price_INR is not null and price_outlier = 'Regular'
group by engine_ranges
order by cars_count desc;

/*
11. Automatic vs Manual transmission pricing and total count.
Analysis find that Automatic and Manual are crossing 35,000 total cars.
The average price of Manual is much lower than Automatic.
*/

select transmission,
round(AVG(price_INR)) as avg_price,
count(*) as cars_count
from used_cars_cleaned
where price_INR is not null and price_outlier = 'Regular'
group by transmission
order by cars_count desc;

/*
12. Finding top 10 India Locations listings.
The total car listings are majorly in India locations in Delhi, Mumbai, Mahbubnagar crossing 10K listings.
*/

select india_locations, count(*) as total_listing
from used_cars_cleaned
group by india_locations
order by total_listing desc
limit 10;

/*
13. City with its average price excluding outliers top 10.
All the major cities average price is crossing 20 Lakh.
*/

select india_locations, round(AVG(price_INR)) as avg_price, count(*) AS total_cars
from used_cars_cleaned
where price_INR is not null and price_outlier = 'Regular'
group by india_locations
order by total_cars desc
limit 10;

/*
14. Outliers and Premium priced Cars segment calculation.
There are 3535 luxury segement cars priced more than 1 Crores to 17 Crores.
*/

select count(*) as luxury_cars_segment
from used_cars_cleaned
where price_inr > 10000000 ;

/*
15. Luxury cars brand crossing 1 Crore in price.
In this analysis I find that cars such as MG ZS EV, Honda CR-V, Honda Accord, Toyota Camry, Honda Civic, Hyundai Sonata, and Toyota Fortuner
Are priced much higher than the market price which are mis priced and doesnt fall under luxury segment.
*/

select manufacturer, varient, COUNT(*) AS luxury_listing, round(AVG(price_INR)) as avg_luxury_price
from used_cars_cleaned
where price_INR > 10000000
group by manufacturer, varient
order by luxury_listing desc;

/*
16. Which India Locations have high number of make in terms of total count of cars.
As we see that Majorly Suzuki, Toyota and Honda takes the top spot in number of cars listings in major cities.
Demand for those cars are considerably higher.
*/

select manufacturer, India_locations, count(*) as total_cars
from used_cars_cleaned
group by Manufacturer, india_locations
order by total_cars desc
limit 10;

/*
17. Which type of cars are the price 'Call' / unavailable.
And we find that the high number of cars such as Toyota, Honda, and Suzuki have unknown Price in the data table.
*/

select manufacturer, count(*) as call_for_price
from used_cars_cleaned
where price_stat = 'Call'
group by manufacturer
order by call_for_price desc;

/*
18. Distance travelled with average price.
Cars in the bucket of 20K - 50K have higher resale value. Which is quite closer to cars uder 20K KM.
As the distance travelled increases the average price and value of the cars decreases.
In this analysis I find that the total cars count is much higher where the distance travelled bucket crosses 100K plus.
When the total distance travelled corsses 50K KM people sells a lot of cars where the jump is very high compared to less than 50K.
*/

select case
	when distance_travelled <= 20000 then 'under_20K KM'
    when distance_travelled <= 50000 then '20K - 50K KM'
    when distance_travelled <= 100000 then '50K - 100K KM'
    else '100K Plues'
    end as distance_bucket,
    round(avg(price_inr)) as avg_price,
    count(*) as total_cars
    from used_cars_cleaned
    where price_inr is not null and price_outlier = 'Regular'
    group by distance_bucket
    order by avg_price desc;
    
-- 19. Majority of older model in Honda, Suzuki and Toyota find that their entry level cars are overpriced which affects the total average price.

select manufacturer, Varient, model,
	MAX(price_INR) as max_price,
	MIN(price_INR) as min_price,
    round(avg(price_inr)) as avg_price
from used_cars_cleaned
where manufacturer in ('Suzuki', 'Honda', 'Toyota') and model >= 2003 and price_outlier = 'Regular'
group by manufacturer, varient, model
order by manufacturer, model, max_price desc;

/*
20. High demanding model cars with India Locations
Delhi and Mumbai is the major India location which has high number of recent listed model cars
*/

select count(id) as count_id, india_locations, model from used_cars_cleaned
where price_outlier = 'Regular'
group by india_locations, model
order by count_id desc
limit 10;

/*
21. Petrol dominated the market 
Diesel is dying in major popular cities.
*/

select india_locations, fuel_type, count(*) as count_numbers from used_cars_cleaned
group by India_Locations, Fuel_Type
order by count_numbers desc
limit 10;

/*
22. Brand Domination
As we see Suzuki, Honda and Toyota dominates the market.
As a indian economy car makers Suzuki has high number of Premium priced cars which can be considered unfaily priced.
Toyota and Honda has majorly premium priced cars which is nearly 20000 total cars crossing 20 Lakhs in which some of the imported
and luxury segments affects the pricing.
*/

select manufacturer, 
	case
		when price_inr < 1000000 then 'Budget'
        when price_inr between 1000000 and 2000000 then 'Mid-Range'
        else 'Premium'
	end as price_segments,
    count(*) as total_cars
    from used_cars_cleaned
    where price_outlier = 'Regular'
group by manufacturer, price_segments
order by manufacturer;

/* 
23. Regional Luxury cars
Delhi and Mumbai takes the top spot of more than 20 lakhs priced used cars.
*/

select india_locations, count(*) as premium_priced_cars
from used_cars_cleaned
where price_inr > 2000000 and price_outlier = 'Regular'
group by India_Locations
order by premium_priced_cars desc
limit 10;

/* 
24. Yearly Depreciation by popular Cars
This analysis finds that Suzuki is the least priced cars, and all popular branded vehicles have positive relationship with the model year and average price.
The average price highly depreciates with the older model cars.
*/

select manufacturer, model, round(avg(price_inr)) as avg_price
from used_cars_cleaned
where Manufacturer in ('Suzuki', 'Honda', 'Toyota', 'Hyundai') and price_outlier = 'Regular'
group by Manufacturer, model
order by Manufacturer, model;