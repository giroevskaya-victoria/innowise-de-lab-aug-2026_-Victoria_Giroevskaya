select e.first_name f_name, e.last_name l_name, s.address shop_address
from employees e inner join shops s on e.shop_id = s.shop_id inner join sales sl on sl.employee_id = e.employee_id 
where sl.total_price = (
	select MAX(s2.total_price)
	from sales s2
	);
