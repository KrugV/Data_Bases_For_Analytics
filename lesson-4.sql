
SELECT min(o_date), max(o_date) FROM orders_all oa;

-- по мес
DROP TABLE IF EXISTS one_month_table;
CREATE TABLE IF NOT EXISTS one_month_table (
SELECT 
	user_id,
	COUNT(id_o) AS n,
	MONTH(o_date) AS date_m,
	YEAR(o_date) AS date_y
FROM orders_20190822 o
WHERE price BETWEEN 0 AND 150000
GROUP BY user_id, date_m, date_y);

SELECT count(*) FROM one_month_table;

SELECT DISTINCT(n) FROM one_month_table ORDER BY n DESC;



-- Группировка пользователей на грууппы в зависимости от количества заказов
-- Разделение по группам кол-во покупак в разные месяцы до 20170101.
SELECT 
	COUNT(omt.user_id) AS count_users,
	CASE 
		WHEN n < 5 THEN 1
		WHEN n BETWEEN 5 AND 10 THEN 2
		WHEN n BETWEEN 11 AND 20 THEN 3
		WHEN n > 20 THEN 4 END AS buyer_group,
	date_m,
	date_y,
	sum(o.price) AS summ
FROM one_month_table omt
LEFT JOIN orders_20190822 AS o
ON omt.user_id = o.user_id
WHERE 
	o.price BETWEEN 0 AND 150000 AND 
	o.o_date < DATE('2017-01-01') AND
	DATE(concat(omt.date_y,'-',omt.date_m,'-','01')) < DATE('2017-01-01')
GROUP BY buyer_group, omt.date_m, omt.date_y;


-- просмотр, в какой групе был пользователь, и в какую группу он попал
SELECT 
	ot.user_id, 
	expenses,
	buyer_group_prev,
	CASE 
		WHEN buyer_group_cur < 5 THEN 1
		WHEN buyer_group_cur BETWEEN 5 AND 10 THEN 2
		WHEN buyer_group_cur BETWEEN 11 AND 20 THEN 3
		WHEN buyer_group_cur > 20 THEN 4 END AS buyer_group_cur
FROM (
	SELECT 
		DISTINCT(user_id),
		CASE 
			WHEN n < 5 THEN 1
			WHEN n BETWEEN 5 AND 10 THEN 2
			WHEN n BETWEEN 11 AND 20 THEN 3
			WHEN n > 20 THEN 4 END AS buyer_group_prev
	FROM one_month_table AS ot
	WHERE DATE(concat(date_y,'-',date_m,'-','01')) < DATE('2017-01-01')) ot
INNER JOIN (
	SELECT
		user_id,
		sum(price) AS expenses,
		count(id_o) AS buyer_group_cur
	FROM orders_20190822 oh
	WHERE YEAR(o_date) = 2017 AND
		  MONTH(o_date) = 1 AND
		  price BETWEEN 0 AND 150000
	GROUP BY user_id) oh ON ot.user_id = oh.user_id;
	
-- просмотр, сколько пользователей из группп в прошлом сохранились в анализируемом месяце
SELECT
	buyer_group_prev,
	count(ot.user_id) AS осталось,
	count(ot.user_id) / (
			SELECT count(user_id) 
			FROM one_month_table ot2 
			WHERE n = ot.buyer_group_prev AND
					DATE(concat(date_y,'-',date_m,'-','01')) < DATE('2016-12-01'))*100 '%'
FROM (
	SELECT *,
		CASE 
			WHEN n < 5 THEN 1
			WHEN n BETWEEN 5 AND 10 THEN 2
			WHEN n BETWEEN 11 AND 20 THEN 3
			WHEN n > 20 THEN 4 END AS buyer_group_prev
	FROM one_month_table AS ot
	WHERE DATE(concat(date_y,'-',date_m,'-','01')) < DATE('2016-12-01')) ot
INNER JOIN (
	SELECT
		user_id,
		sum(price) AS expenses,
		count(id_o) AS buyer_group_cur
	FROM orders_20190822 oh
	WHERE YEAR(o_date) = 2017 AND
		  MONTH(o_date) = 1 AND
		  price BETWEEN 0 AND 150000
	GROUP BY user_id) oh 
ON ot.user_id = oh.user_id
GROUP BY buyer_group_prev; 
	