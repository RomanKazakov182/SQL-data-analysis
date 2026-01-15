SELECT user_id
     , ROUND(AVG(ARRAY_LENGTH(product_ids, 1)), 2) AS avg_order_size
FROM
    (SELECT order_id, user_id
     FROM user_actions
     WHERE action = 'create_order' AND order_id NOT IN (SELECT order_id
                                                        FROM user_actions
                                                        WHERE action = 'cancel_order')) AS ua
    LEFT JOIN
    orders AS ord
    USING(order_id)
GROUP BY user_id
ORDER BY user_id
