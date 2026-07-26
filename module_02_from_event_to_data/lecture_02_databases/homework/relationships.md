Первичные ключи для сущностей:

sales - sales\_id

customers - customer\_id. Используем именно этот атрибут как PK, т.к. в других полях чисто теоретически могут встретится повторяющиеся значения(например, ФИО хоть и в редких случаях, но может быть одинаковое, поэтому здесь даже составной ключ будет плох в выборе, а адрес и город тоже могут повторятся)

products - product\_id

categories - category\_id. Здесь мы используем именно номер категории, потому что мы можем легко в будущем использовать  его, а название каждый раз долго писать, когда добавляется новый товар и когда вводишь данные можно легко ошибиться(написать неправильно слово или опечататься), а цифру одну ввести намного легче

employees - employee\_id

cities - city\_id

countries - country\_id

shops - shop\_id



Внешние ключи:

cities: country\_id - ссылка на страну(табл. countries)

customers: city\_id - ссылка на город проживания покупателя(cities)

employees: city\_id - ссылка на город проживания сотрудника(cities); shop\_id - ссылка на магазин, в котором работает(shops)

products: categoty\_id - на категорию, к которой относится товар(categories)

sales: employee\_id - ссылка на сотрудника(employees), который обслуживал покупателя; customer\_id - сам покупатель(customers), product\_id - какой продукт купил(products)

shops: city\_id - ссылка на город, в котором находится магаз(cities)



Типы связей:

Sales и products. Связь 1:M (sales - промежуточная таблица между products и customers).

2\. Employees и cities. M:1

3\. Cities и countries. M:1



**Текстовая логическая модель**

Cities связана с countries как М:1, свзяана с customers, employees и shops как 1:М
Employees связана с shops как М:1

Products связана с categories как М:1
Sales связана с customers, products как 1:М и с employees как М:1

&#x20;

