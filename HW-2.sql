USE `bank`;

-- 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT * FROM client WHERE LENGTH(FirstName) < 6;

-- 2.Вибрати львівські відділення банку.
SELECT * FROM department WHERE DepartmentCity = 'Lviv';

-- 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT * FROM  client WHERE Education = 'high' ORDER BY LastName;

-- 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT * FROM  application ORDER BY idApplication DESC LIMIT 5;

-- 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
SELECT * FROM  client WHERE LastName LIKE '%ov' or LastName LIKE '%ova';

-- 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT * FROM  client WHERE Department_idDepartment IN 
(SELECT idDepartment FROM  department WHERE DepartmentCity = 'Kyiv');

-- 7.Знайти унікальні імена клієнтів.
SELECT DISTINCT FirstName FROM client;

-- 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT * FROM  client WHERE idClient IN 
(SELECT Client_idClient FROM application WHERE Currency = 'Gryvnia' AND sum > '5000');

-- 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT
	(SELECT COUNT(*) FROM client) Allclients,
	(SELECT COUNT(*) FROM client WHERE City = 'Lviv') LvivClients;

-- 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT Client_idClient, MAX(Sum) FROM application GROUP BY Client_idClient;

-- 11. Визначити кількість заявок на кредит для кожного клієнта.
SELECT Client_idClient, COUNT(Client_idClient) Count FROM application GROUP BY Client_idClient;

-- 12. Визначити найбільший та найменший кредити.
SELECT MAX(Sum) MaxSum, MIN(Sum) MinSum FROM application;

-- 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SELECT Client_idClient, COUNT(Client_idClient) Count FROM application 
WHERE Client_idClient IN (SELECT idClient FROM client WHERE Education = 'high')
GROUP BY Client_idClient;

-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT * FROM client WHERE idClient = 
(SELECT Client_idClient FROM application GROUP BY Client_idClient ORDER BY AVG(Sum) DESC LIMIT 1);

-- 15. Вивести відділення, яке видало в кредити найбільше грошей.
SELECT idDepartment, DepartmentCity, SUM(Sum) MaxSum FROM department d JOIN client c 
ON d.idDepartment = c.Department_idDepartment JOIN application a
ON c.idClient = a.Client_idClient GROUP BY d.idDepartment ORDER BY MaxSum DESC LIMIT 1;

-- 16. Вивести відділення, яке видало найбільший кредит.
SELECT idDepartment, DepartmentCity, MAX(Sum) MaxSum FROM department d JOIN client c 
ON d.idDepartment = c.Department_idDepartment JOIN application a
ON c.idClient = a.Client_idClient;

-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application SET Currency = 'Gryvnia', Sum = '6000' WHERE Client_idClient IN
(SELECT idClient FROM client WHERE Education = 'high');

-- 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client SET City = 'Kyiv' WHERE Department_idDepartment IN
(SELECT idDepartment FROM department WHERE DepartmentCity = 'Kyiv');

-- 19. Видалити усі кредити, які є повернені.
DELETE FROM application WHERE CreditState = 'Returned' LIMIT 100;

-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
SELECT * FROM client WHERE LastName LIKE '_a%' OR LastName LIKE '_e%' 
OR LastName LIKE '_i%' OR LastName LIKE '_o%' OR LastName LIKE '_u%';

-- 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000.
SELECT idDepartment, SUM(Sum) AllSum FROM client c 
JOIN application a ON a.Client_idClient = c.idClient 
JOIN department d ON c.Department_idDepartment = d.idDepartment
WHERE DepartmentCity = 'Lviv' GROUP BY idDepartment HAVING AllSum > 5000;

-- 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000.
SELECT * FROM client WHERE idClient IN 
(SELECT Client_idClient FROM application WHERE Sum > 5000 AND CreditState = 'Returned');

-- 23.Знайти максимальний неповернений кредит.
SELECT * FROM application WHERE Sum = 
(SELECT Sum FROM application WHERE CreditState = 'Not returned' ORDER BY Sum DESC LIMIT 1);

-- 24.Знайти клієнта, сума кредиту якого найменша.
SELECT * FROM client WHERE idClient = 
(SELECT Client_idClient FROM application WHERE Sum = 
(SELECT MIN(Sum) FROM application));

-- 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів.
SELECT * FROM application WHERE Sum >
(SELECT AVG(Sum) FROM application);

-- 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів.
SELECT * FROM client WHERE City = 
(SELECT City FROM client c JOIN application a ON c.idClient = a.Client_idClient GROUP BY Client_idClient ORDER BY COUNT(idApplication) DESC LIMIT 1);

-- 27. Місто клієнта з найбільшою кількістю кредитів.
SELECT City FROM client c JOIN 
(SELECT Client_idClient, COUNT(Client_idClient) Count FROM application GROUP BY Client_idClient ORDER BY Count DESC LIMIT 1) r
ON c.idClient = r.Client_idClient;