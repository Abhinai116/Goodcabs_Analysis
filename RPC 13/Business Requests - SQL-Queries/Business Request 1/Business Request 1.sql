/*Business Request - 1: 
City-Level Fare and Trip Summary Report
Generate a report that displays the total trips, average fare per km, average fare per trip, 
and the percentage contribution of each city’s trips to the overall trips. 
This report will help in assessing trip volume, pricing efficiency, 
and each city’s contribution to the overall trip count. 
Fields:city_name,total_trips,avg_fare_per_km,avg_fare_per trip,%_contribution_to_total_trips*/

-- Query --

with trips as (
		select city_name,
        count(trip_id) as total_trips,
        sum(fare_amount) as fare,
        sum(distance_travelled_km) as distance,
        concat(round((count(trip_id)/(select count(trip_id) from fact_trips)),2)*100,"%") as Percentage_contribution_to_total_trips
		from fact_trips t
		join dim_city c on c.city_id = t.city_id
		group by city_name)
select city_name,total_trips,
       round((fare/distance),2) as avg_fare_per_km,
       round((fare/total_trips),2) as avg_fare_per_trip,
	   Percentage_contribution_to_total_trips
from trips 
group by city_name
order by total_trips desc