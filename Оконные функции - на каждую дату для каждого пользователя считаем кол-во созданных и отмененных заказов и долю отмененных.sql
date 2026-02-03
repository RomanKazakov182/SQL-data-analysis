SELECT user_id
     , order_id
     , action
     , time
     , COUNT(order_id) FILTER (WHERE action = 'create_order') OVER(PARTITION BY user_id ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS created_orders
     , COUNT(order_id) FILTER (WHERE action = 'cancel_order') OVER(PARTITION BY user_id ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS canceled_orders
     , ROUND(COUNT(order_id) FILTER (WHERE action = 'cancel_order') OVER(PARTITION BY user_id ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)::DECIMAL / COUNT(order_id) FILTER (WHERE action = 'create_order') OVER(PARTITION BY user_id ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cancel_rate
FROM user_actions
ORDER BY user_id, order_id, time