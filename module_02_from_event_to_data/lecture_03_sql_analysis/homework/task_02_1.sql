select sh.shop_id shop, sh.address shop_address, c.city_name city, con.country_name country
from shops sh inner join cities c on c.city_id = sh.city_id inner join countries con on con.country_id = c.country_id
where con.country_name  = 'Poland'
limit 10;