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