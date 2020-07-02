USE db_analyt_loc;
SELECT * FROM orders_20190822 o;

SELECT *
  FROM (
SELECT 
  user_id,
  TIMESTAMPDIFF(DAY,MAX(o_date),date('2017-12-31')) AS period_from_last_ord,
  CEILING(COUNT(o.id_o)/TIMESTAMPDIFF(DAY,MIN(o.o_date),MAX(o.o_date))) AS freq,
  ROUND(AVG(o.price),2) as avg_price
FROM orders_20190822 o
GROUP BY o.user_id) t;