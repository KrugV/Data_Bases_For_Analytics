SELECT * 
FROM orders_20190822
ORDER BY price ASC;


DELETE LOW_PRIORITY QUICK
  FROM orders_filter
  WHERE price <= 0;

SELECT * FROM orders_filter of WHERE price <= 0;


SELECT COUNT(o_date) FROM
  (
SELECT o_date, SUM(price) s, COUNT(id_o) n
  FROM orders_filter
  GROUP BY o_date) AS filt;

SELECT YEAR(o_date),MONTH(o_date), CEIL(SUM(price))
  FROM orders_filter 
  GROUP BY YEAR(o_date), MONTH(o_date)
  ORDER BY YEAR(o_date);