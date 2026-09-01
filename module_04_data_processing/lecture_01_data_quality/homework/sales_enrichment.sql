update silver.silver_sales as s 
set 
	city_id = e.city_id,
	shop_id = e.shop_id
from silver.silver_employees as e
where s.employee_id = e.employee_id;