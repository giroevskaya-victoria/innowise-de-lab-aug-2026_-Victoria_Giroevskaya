select e.employee_id, last_name, count(sales_id) as count_sales
from sales s inner join employees e on e.employee_id = s.employee_id  
group by 1, 2
having count(sales_id) > 1000
order by 1
limit 15;