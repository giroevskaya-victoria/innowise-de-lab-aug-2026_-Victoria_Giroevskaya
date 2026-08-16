select s.sales_id as sale, p.product_name as product, sh.address as shop_address
from sales s left join products p on s.product_id = p.product_id inner join employees e on e.employee_id = s.employee_id inner join shops sh on e.shop_id = sh.shop_id
limit 10;