select
	month,
	monthly_revenue,
	lag(monthly_revenue) over(
		order by month) as prev_monthly_revenue,
	(monthly_revenue - lag(monthly_revenue) over(
		order by month) ) as revenue_diff_vs_previous
from (
	select 
		date_trunc('month', sales_timestamp) as month, 
		sum(total_price) as monthly_revenue
	from 
	
		(select sales_timestamp, total_price
		from sales n
			inner join employees e on n.employee_id = e.employee_id 
			inner join shops s on s.shop_id = e.shop_id 
			inner join cities c on c.city_id = s.city_id 
			inner join countries c2 on c2.country_id =c.country_id
		where c2.country_name = 'Germany' ) as new1
		
	group by 1) as new2
order by 1
limit 24;
