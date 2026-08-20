def calculate_purchase(product_name, weight, price):
    """
        Рассчитывает стоимость партии продукта и обрабатывает ошибки ввода.

        Параметры:
            product_name (str): Название продукта для вывода в отчёт.
            weight (str | int | float): Вес партии. Может быть числом или строкой,
                которую можно преобразовать в число (например, "2.5").
            price (int | float): Цена за единицу веса.

        Возвращает:
            None: Функция выводит результат в консоль и ничего не возвращает.

        Исключения внутри функции:
            TypeError, ValueError, ZeroDivisionError обрабатываются и выводят сообщение.
    """
    try:
        numeric_weight = float(weight)
        total_cost = numeric_weight * price
        technical_index = 100 / numeric_weight

        print(f"\nНазвание продукта: {product_name}")
        print(f"Итоговая стоимость партии: {total_cost}")
    except TypeError as t:
        print(f"В расчет попал неподходящий тип вместо числа \nТип: {type(t)}, Сообщение: {t}")
    except ValueError as v:
        print(f"Вы передали текст, который нельзя превратить в число \nТип: {type(v)}, Сообщение: {v}")
    except ZeroDivisionError as z:
        print(f"Произошло деление на 0 \nТип: {type(z)}, Сообщение: {z}")
    finally:
        print("\n--- Проверка партии завершена ---\n\n\n")


calculate_purchase('Томаты', 100, 2.5)
calculate_purchase('Огурцы', "пятьдесят", 1.8)
calculate_purchase('Перец', 0, 4)
calculate_purchase('Зелень', [10], 5)
