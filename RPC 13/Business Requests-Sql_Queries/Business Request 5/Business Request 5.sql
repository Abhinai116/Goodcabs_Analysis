With Revenue as (
		select monthname(date) as month_name,
        city_name,
        sum(f.fare_amount) as revenue
		from fact_trips f
		join dim_city c on c.city_id = f.city_id
		group by city_name,month_name
		order by month_name asc),
city_rank as (
		select *,sum(revenue) over(partition by city_name) as city_rev,
		dense_rank() over(partition by city_name order by revenue desc) as highestrevenue
		from Revenue)
Select city_name,
	   month_name as highest_revenue_month,
       revenue,concat(round((revenue/city_rev)*100,2),"%") as Percentage_contribution
From city_rank
Where highestrevenue = 1
Order by revenue desc