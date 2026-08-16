select con.country_name country, count(sh.shop_id)
from shops sh inner join cities c on c.city_id = sh.city_id inner join countries con on con.country_id = c.country_id
group by 1
order by 2 desc;