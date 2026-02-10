WITH paying_users AS (
    SELECT user_id
         , order_id
         , DATE(time) AS date
    FROM user_actions
    WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
)

SELECT date
     , ROUND(COUNT(DISTINCT CASE WHEN order_count = 1 THEN user_id END)::DECIMAL / COUNT(DISTINCT user_id) * 100, 2) AS single_order_users_share
     , ROUND(COUNT(DISTINCT CASE WHEN order_count > 1 THEN user_id END)::DECIMAL / COUNT(DISTINCT user_id) * 100, 2) AS several_orders_users_share
FROM
(
SELECT date
     , user_id
     , COUNT(DISTINCT order_id) AS order_count
FROM paying_users
GROUP BY date, user_id
) AS t
GROUP BY date
ORDER BY date