daily_logs = [
    [500, 0, 1200],       # Касса 1 (Нормальная)
    [300, -999, 800],     # Касса 2 (Сломалась посередине, 800 не должно посчитаться)
    [1500, 200]           # Касса 3 (Нормальная)
]

total_revenue = 0

for i, day in enumerate(daily_logs):
    print(f"--- Обработка Кассы №{i} ---")
    for i2 in day:
        if i2 == -999:
            break
        elif i2 == 0:
            continue
        else:
            total_revenue += i2
            print(f"Добавлено {i2}")

print(f"Общая выручка магазина:{total_revenue}")
