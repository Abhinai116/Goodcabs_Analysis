with Trips as (
		select c.city_name,month,d.city_id,trip_count,
		sum(repeat_passenger_count) over(partition by city_name) as total_city_repeat_passengers,
		sum(repeat_passenger_count) over(partition by trip_count,month,city_id) as trips
		from dim_repeat_trip_distribution d
		join dim_city c on c.city_id = d.city_id),
Repeat_frequency as (
		select city_name,trip_count,total_city_repeat_passengers,
		sum(trips) over (partition by trip_count,city_name) as repeat_passengers
		from Trips),
Frequency_trips as (
		select city_name,trip_count,concat(round(repeat_passengers/total_city_repeat_passengers*100,2),"%") as frequency
		from Repeat_frequency)
		SELECT 
		city_name,
		MAX(CASE WHEN trip_count = 2 THEN frequency END) AS "2-Trips",
		MAX(CASE WHEN trip_count = 3 THEN frequency END) AS "3-Trips",
		MAX(CASE WHEN trip_count = 4 THEN frequency END) AS "4-Trips",
		MAX(CASE WHEN trip_count = 5 THEN frequency END) AS "5-Trips",
		MAX(CASE WHEN trip_count = 6 THEN frequency END) AS "6-Trips",
		MAX(CASE WHEN trip_count = 7 THEN frequency END) AS "7-Trips",
		MAX(CASE WHEN trip_count = 8 THEN frequency END) AS "8-Trips",
		MAX(CASE WHEN trip_count = 9 THEN frequency END) AS "9-Trips",
		MAX(CASE WHEN trip_count = 10 THEN frequency END) AS "10-Trips"
		FROM 
		Frequency_trips
		GROUP BY 
		city_name