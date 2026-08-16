create or replace view FullStatShops as
	select 
		sh.shop_id, 
		shop_address, 
		country_name as country, 
		count(total_price) as total_sales_count,
		sum(total_price) as total_sales_amount
	from sales s 
		inner join employees e on e.employee_id = s.employee_id
		inner join shops sh on sh.shop_id = e.shop_id
		inner join cities c on c.city_id = sh.city_id
		inner join countries c2 on c2.country_id = c.country_id
	group by 1, 2, 3;