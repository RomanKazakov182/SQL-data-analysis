SELECT user_id
     , COUNT(order_id) AS orders_count
     , ROUND(AVG(ARRAY_LENGTH(product_ids, 1)), 2) AS avg_order_size
     , SUM(order_price) AS sum_order_value
     , ROUND(SUM(order_price) / COUNT(order_id)::DECIMAL, 2) AS avg_order_value
     , MIN(order_price)AS min_order_value
     , MAX(order_price)AS max_order_value
FROM
(
SELECT order_id
     , SUM(price) AS order_price
FROM (SELECT order_id
           , unnest(product_ids) as product_id
      FROM orders) as ord
    LEFT JOIN products
         using(product_id)
GROUP BY order_id
ORDER BY order_id
)
      AS ords_prcs
INNER JOIN
(
SELECT user_id
     , order_id
     , product_ids
FROM (SELECT DISTINCT order_id
           , user_id
      FROM user_actions
      WHERE action = 'create_order'
        and order_id not in (SELECT order_id
                             FROM user_actions
                             WHERE action = 'cancel_order')) as ua
    LEFT JOIN orders as ord
         using(order_id)
ORDER BY user_id, order_id
)
     AS us_ords_prods
     USING(order_id)
GROUP BY user_id
ORDER BY user_id