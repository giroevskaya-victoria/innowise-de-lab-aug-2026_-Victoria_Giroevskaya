SMALL_BATCH_LIMIT = 500


def calculate_batch(weight, price, discount=0.0):
    """
    Рассчитывает стоимость партии и проверяет превышение лимита.

    Параметры:
        weight, price — число (int/float).
        discount — скидка от 0 до 1, по умолчанию 0.0.

    Возвращает:
        (final_sum, is_limit_exceeded) — float и bool.
    """
    final_sum = weight * price * (1 - discount)
    is_limit_exceeded = final_sum > SMALL_BATCH_LIMIT
    return final_sum, is_limit_exceeded


carrot_sum, carrot_limit_exceeded = calculate_batch(100, 4)
apple_sum, apple_limit_exceeded = calculate_batch(50, 20, 0.1)

print(f"Партия 1 (Морковь): Сумма {carrot_sum}. Превышение лимита: {carrot_limit_exceeded}")
print(f"Партия 2 (Яблоки): Сумма {apple_sum}. Превышение лимита: {apple_limit_exceeded}")

