product_name = "Морковь мытая"
price = 2.5
stock_quantity = 150
is_local_farm = True
supplier = None

has_coupon = True
has_card = False
total = 10

is_hit = (price < 3) and is_local_farm
print(f"Является ли товар хитом? {is_hit}")

has_supplier = supplier is not None
print(f"Поставщик указан? {has_supplier}")

can_show_in_app = supplier is not None and stock_quantity is not None
print(f"Показывать в приложении? {can_show_in_app}")

needs_restock = stock_quantity <= 20 or is_hit
print(f"Нужно пополнение? {needs_restock}")

is_blocked = not is_local_farm
print(f"Товар заблокирован для акции? {is_blocked}")

print()

discount_without_brackets = has_coupon or has_card and total > 50
discount_with_brackets = (has_coupon or has_card) and total > 50
print(f"Скидка без скобок: {discount_without_brackets}")
print(f"Скидка c скобок: {discount_with_brackets}")

print()

price += 1
stock_quantity *= 2
boxes = stock_quantity // 10
print(f"Цена после изменения: {price}")
print(f"Остаток после изменения: {stock_quantity}")
print(f"Полных коробок по 10 кг: {boxes}")

print()

is_hit_a = (price < 3) and is_local_farm
print(f"Является ли товар хитом (после изменений)? {is_hit_a}")

needs_restock_a = stock_quantity <= 20 or is_hit
print(f"Нужно пополнение (после изменений)? {needs_restock_a}")
