create or replace view marts.mart_daily_anomaly as 
select
	dd.full_date,
	round(sum(fs.total_price), 2) as "revenue",
	round(avg(sum(fs.total_price)) over (order by full_date rows between 30 preceding and 1 preceding), 2) as "expected_revenue",
case 
	when avg(sum(fs.total_price)) over (order by full_date rows between 30 preceding and current row) > 0
	then 
		round((sum(fs.total_price) / avg(sum(fs.total_price)) over (order by full_date rows between 30 preceding and current row) - 1
	) * 100, 2)
	else null
end as "uplift(%)"
from gold.fact_sales fs inner join gold.dim_date dd on fs.date_sk = dd.date_sk
group by 1;

------------------------------------------------------------------------------------------------------------------

create or replace view marts.mart_shop_daily as
with daily_shop_revenue as (
	select 
		shop_sk,
		date_sk,
		sum(total_price) as revenue_per_day
	from gold.fact_sales
	group by 1,2
)
select 
	country_name,
	city_name,
	address,
	round(avg(revenue_per_day), 2) as avg_per_day
from daily_shop_revenue dsr inner join gold.dim_shop ds on ds.shop_sk = dsr.shop_sk
	inner join gold.dim_location dl on dl.location_sk = ds.location_sk
group by 1, 2, 3
order by 4 desc;
	
------------------------------------------------------------------------------------------------------------------

create or replace view marts.mart_customer_behavior as 
with last_purchase_date as (
	select t.customer_sk, max(full_date) as last_purchase, sum(total_price) as total_spent
	from gold.fact_sales t inner join gold.dim_date dd on dd.date_sk = t.date_sk 
	group by 1
)
select 
	dc.full_name,
	lpd.total_spent,
	case 
		when ('2023-12-31' - lpd.last_purchase) > 30
		then 'Inactive'
		else 'Active'
	end as status,
	ntile(100) over (order by total_spent) as procentile,
	ntile(4) over (order by total_spent) as cvartile,
	(total_spent / (select sum(total_price) from gold.fact_sales) * 100) as procent_ot_obchego
from gold.dim_customer dc inner join last_purchase_date lpd on dc.customer_sk = lpd.customer_sk;

------------------------------------------------------------------------------------------------------------------

create or replace view marts.mart_customer_segments as
select 
	status,
	case
		when cvartile = 4 then 'VIP'
		when cvartile = 3 then 'Gold'
		when cvartile = 2 then 'Silver'
		when cvartile = 1 then 'Bronze'
	end as segment_level,
	count(full_name) as customer_count,
	sum(total_spent) as total_segment_revenue,
	round(sum(total_spent) / (select sum(total_price) from gold.fact_sales) * 100, 2) as revenue_percent
from marts.mart_customer_behavior
group by 1, 2
order by 1, 2 desc;
	
------------------------------------------------------------------------------------------------------------------

create or replace view marts.mart_employee_performance as
with quartile_nums as(
	select
		employee_sk,
		sum(total_price) as employee_revenue,
		ntile(4) over (order by sum(total_price)) as quartile
	from gold.fact_sales
	group by 1
)
select
	case
		when quartile = 4 then 'leaders'
		when quartile = 1 then 'outsiders'
		else 'middles'
	end as employee_category,
	sum(employee_revenue) as category_revenue,
	round(sum(employee_revenue) / (select sum(total_price) from gold.fact_sales) * 100, 2) as revenue_percent
from quartile_nums 
group by 1;

------------------------------------------------------------------------------------------------------------------

create or replace view marts.mart_product_seasonality as 
with 
month_total as(
	select month_num, sum(total_price) as month_total_revenue
	from gold.dim_date dd inner join gold.fact_sales fs on fs.date_sk = dd.date_sk
	group by 1
),
category_total as(
	select dc.category_name, sum(total_price) as category_total_revenue
	from gold.fact_sales fs 
	inner join gold.dim_product dp on dp.product_sk = fs.product_sk
		inner join gold.dim_category dc on dc.category_sk = dp.category_sk
		group by 1
),
categ_month_sum_tier as(
	select
		dc.category_name,
		dd.month_num,
		month_name,
		sum(total_price) as category_month_revenue,
		rank() over (partition by dc.category_name order by sum(total_price) desc) as place,
	case
		when rank() over (partition by dc.category_name order by sum(total_price) desc) = 1 then 'S-class month'
		when rank() over (partition by dc.category_name order by sum(total_price) desc) = 2 then 'A-class month'
		when rank() over (partition by dc.category_name order by sum(total_price) desc) = 3 then 'B-class month'
		else 'F-class'
	end	as tier_list
	from gold.fact_sales fs 
		inner join gold.dim_product dp on dp.product_sk = fs.product_sk
		inner join gold.dim_category dc on dc.category_sk = dp.category_sk
		inner join gold.dim_date dd on dd.date_sk = fs.date_sk
	group by 1,2,3
)
select 
	ctmst.category_name,
	ctmst.month_num,
	month_name,
	tier_list,
	category_month_revenue,
	round(category_month_revenue / month_total_revenue * 100, 2) as percent_of_month,
	round(category_month_revenue / category_total_revenue * 100, 2) as percent_of_category,
	round(category_month_revenue / (select sum(total_price) from gold.fact_sales) * 100, 2) as percent_of_total_revenue
from categ_month_sum_tier ctmst
	inner join month_total mt on mt.month_num = ctmst.month_num
	inner join category_total ct on ct.category_name = ctmst.category_name
where tier_list != 'F-class'
group by 
	ctmst.category_name,
	ctmst.month_num,
	month_name,
	tier_list,
	category_month_revenue,
	month_total_revenue,
	category_total_revenue;	
	