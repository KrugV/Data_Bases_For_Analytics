SELECT user_id,COUNT(id_o) n, SUM(price), TIMESTAMPDIFF(DAY,MAX(o_date),date('2017-12-31')) d,MIN(o_date)
FROM ds.orders_20190822
  GROUP BY user_id;

SELECT t.user_id,CONCAT(t.m,t.r) AS rfm
  FROM
  (
SELECT user_id, 
  CASE WHEN SUM(price) < 1000 THEN "1"
       WHEN SUM(price) >= 1000 AND price < 5000 THEN "2"
  ELSE "3" end  AS m,
  CASE WHEN TIMESTAMPDIFF(DAY,MAX(o_date),date('2018-01-01')) < 30 THEN "1"
       WHEN TIMESTAMPDIFF(DAY,MAX(o_date),date('2018-01-01')) >= 30 AND TIMESTAMPDIFF(DAY,MAX(o_date),date('2018-01-01')) < 60 THEN "2"
  ELSE "3" end  AS r
  FROM orders_20190822
GROUP BY user_id
) t;



CREATE TABLE user_n

SELECT user_id,COUNT(id_o) n,date('2017-01-01') 
From orders_20190822
  WHERE date(o_date)< date('2017-01-01')
  GROUP BY user_id;

SELECT n,COUNT(user_id)
  FROM user_n
  GROUP BY n;


SELECT t.n,SUM(t.price),COUNT(DISTINCT t.user_id)
  FROM 
  (
SELECT n.n,o.price, id_o, o.user_id
  FROM orders_20190822_117 o
  JOIN user_n n
  ON o.user_id = n.user_id
  WHERE n.n = 1 -- >0  AND  n.n < 4 -- year(o_date) = 2017 AND month(o_date) =1
  ) t
  GROUP BY t.n;

  CREATE TABLE orders_20190822_1172
SELECT n.n,o.price, id_o, o.user_id
  FROM orders_20190822_117 o
  JOIN user_n n
  ON o.user_id = n.user_id
  WHERE n.n = 1;
      -- WHERE year(o_date) = 2017 AND month(o_date) =1