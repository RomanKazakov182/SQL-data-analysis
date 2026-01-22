WITH sort_table AS (
  SELECT o.order_id
       , product_id
       , p.name
  FROM (
        SELECT order_id
             , UNNEST(product_ids) AS product_id
        FROM orders
        WHERE order_id IN (
                           SELECT order_id
                           FROM user_actions
                           WHERE action = 'create_order'
                           EXCEPT
                           SELECT order_id
                           FROM user_actions
                           WHERE action = 'cancel_order'
                          )
       ) AS o
  LEFT JOIN products AS p USING(product_id)
),
pre_final_tab AS (
                  SELECT DISTINCT order_id
                       , LEAST(st1.name, st2.name) AS name_1
                       , GREATEST(st1.name, st2.name) AS name_2
                  FROM sort_table AS st1
                  JOIN sort_table AS st2 USING(order_id)
                  WHERE st1.product_id < st2.product_id
                  ORDER BY order_id, name_1, name_2
                 ),
fin_tab AS (
            SELECT order_id, ARRAY[name_1, name_2] AS pair
            FROM pre_final_tab
           )

SELECT pair, COUNT(order_id) AS count_pair
FROM fin_tab
GROUP BY pair
ORDER BY count_pair DESC, pair