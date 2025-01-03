with New_passengers as (		
        select city_name,count(trip_id) as total_new_passengers
		from fact_trips t
		join dim_city c on c.city_id = t.city_id
		where passenger_type = "new"
		group by city_name),
Rnk as (
		select *,
        dense_rank() over(order by total_new_passengers desc) as top,
		dense_rank() over(order by total_new_passengers asc) as bottom
		from New_passengers)
select city_name,total_new_passengers,concat("Bottom City",bottom) as city_category
from Rnk
where bottom<=3
union all
select city_name,total_new_passengers,concat("Top City",top) as city_category
from Rnk
where top<=3 
order by city_category