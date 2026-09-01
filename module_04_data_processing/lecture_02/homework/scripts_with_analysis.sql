select dd.day_of_week, sum(total_price) as "выручка по дням неделям"
from gold.fact_sales fs inner join gold.dim_date dd on fs.date_sk = dd.date_sk 
group by 1
order by 2 desc;

select ds.address, dl.city_name, dl.country_name , sum(total_price) as "выручка по магазинам"
from gold.fact_sales fs inner join gold.dim_shop ds on fs.shop_sk  = ds.shop_sk 
	inner join gold.dim_location dl on dl.location_sk = ds.location_sk 
group by 1, 2, 3
order by 4 desc;

select dc.category_name , sum(total_price) as "выручка по атегориям"
from gold.fact_sales fs inner join gold.dim_product dp on fs.product_sk = dp.product_sk 
	inner join gold.dim_category dc on dp.category_sk  = dc.category_sk  
group by 1
order by 2 desc;

select 
	dc.full_name,
	dc.city_name,
	SUM(fs.total_price) as "сумма покупок клиента"
from gold.fact_sales fs inner join gold.dim_customer dc on dc.customer_sk = fs.customer_sk 
group by 1,2
order by 3 desc
limit 10;

select 
	de.first_name,
	de.last_name,
	ds.address as "адрес магазина",
	dl.city_name as "город магазина",
	SUM(total_price) as "сумма проданного товара сотрудникком",
	count(quantity) as "количество проданных единиц"
from gold.fact_sales t inner join gold.dim_employee de on t.employee_sk =de.employee_sk 
	inner join gold.dim_shop ds on t.shop_sk = ds.shop_sk 
	inner join gold.dim_location dl on ds.location_sk =dl.location_sk
where de.is_current = True
group by 1, 2, 3, 4
order by 5 desc;

select 
	dp.product_name as "самые продаваемые товары",
	count(quantity) as "количество проданных единиц"
from gold.fact_sales fs inner join gold.dim_product dp on dp.product_sk =fs.product_sk 
group by 1
order by 2 desc;

select round(avg(total_price), 2) as "Средний чек"
from gold.fact_sales;

-- маржинальность вычислить невозможно, потому что нам нужна себестоимость продуктов,а этих данных у нас нет :(