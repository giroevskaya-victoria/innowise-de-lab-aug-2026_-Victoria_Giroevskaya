raw_log = "ORDER-2025-01-15|FRT-APPLE-PL|+111 (23) 456-78-90| мИНсК "

split_log = raw_log.split('|')

order_id = split_log[0]
product_code = split_log[1]
raw_phone = split_log[2]
raw_city = split_log[3]


category = product_code[:3]
region = product_code[-2:]
print(f"Позиция первого дефиса в коде товара: {product_code.find('-')}")
if product_code.startswith("FRT"):
    print("Код товара начинается с 'FRT'")
else:
    print("Код товара не начинается с 'FRT'")


clean_phone = ""
for i in raw_phone:
    if i.isdigit():
        clean_phone += i
print(f"Длина номера телефона: {len(clean_phone)}")

print(f"Заказ: {order_id}")
print(f"Категория: {category} | Регион: {region}")
print(f"Телефон: {clean_phone}")

print(f"Город: {raw_city.strip().title()}")

