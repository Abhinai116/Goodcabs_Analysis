with Actual_trips as (
	select f.city_id,
		   city_name,
           monthname(date) as month_name,count(trip_id) as actual_trips
	from fact_trips f
	join dim_city c on c.city_id = f.city_id
	group by f.city_id,city_name,month_name),
Target_trips as 		
		(select 
        city_name,
        month_name,
        actual_trips,
        total_target_trips as target_trips
		from Actual_trips act
		join targets_db.monthly_target_trips mt on mt.city_id = act.city_id 
        and monthname(mt.month) = act.month_name)
select city_name,month_name,actual_trips,target_trips,
     case 
	 when actual_trips > target_trips then "Above Target"
    else "Below Target" end as performance_status,
    concat(round(((actual_trips-target_trips)/target_trips)*100,2), "%") as percentage_difference
from Target_trips
