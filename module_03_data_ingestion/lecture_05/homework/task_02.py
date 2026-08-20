product = " фермерский ТВОРОГ "
price = 4.567
qty = 3
csv_row = "milk,bread,cheese"
review = "Это лучший ТВОРОГ в городе!"
file_path = r"C:\EcoMarket\data\2025\january\sales.csv"

clean_product = product.strip().title()
total = price * qty
print(f'Чек "EcoMarket" \nТовар: {clean_product} \nКол-во: {qty} \nИтого: {round(total, 2)} руб.\n')

print('|'.join(csv_row.split(',')))

if 'творог' in product.lower():
    print('\nОтзыв относится к категории: Dairy')

# r используется для того, чтобы символ \ не считался как специальный(как \t, \n и тд)
print(file_path)