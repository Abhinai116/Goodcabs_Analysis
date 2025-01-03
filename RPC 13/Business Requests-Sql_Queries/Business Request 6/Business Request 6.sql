with passengers as (
        select 
        city_name as city,
        monthname(month) as month_name,
        sum(total_passengers) as total_passengers,
		sum(repeat_passengers) as repeat_passengers,
        concat(round((sum(repeat_passengers)/sum(total_passengers))*100,2),"%") as monthly_repeat_pass_rate
		from fact_passenger_summary p
		join dim_city c on c.city_id = p.city_id
		group by city,month_name),
city_rate as (        
		select 
        city,
        sum(total_passengers) as total_passengers,
		sum(repeat_passengers) as repeat_passengers,
        concat(round((sum(repeat_passengers)/sum(total_passengers))*100,2),"%") as city_repeat_pass_rate
        from passengers
		group by city)
select p.city,p.month_name,p.total_passengers,p.repeat_passengers,p.monthly_repeat_pass_rate,cr.city_repeat_pass_rate 
from passengers p
join city_rate cr on cr.city = p.city
order by p.city