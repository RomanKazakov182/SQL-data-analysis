SELECT courier_id
     , delivered_orders
     , MAX(last_action) - MIN(date) AS days_employed

FROM
(
SELECT DISTINCT courier_id
     , DATE(time) AS date
     , COUNT(order_id) FILTER (WHERE action = 'deliver_order') OVER(PARTITION BY courier_id) AS delivered_orders
     , MAX(DATE(time)) OVER() AS last_action
FROM courier_actions
ORDER BY courier_id) AS t
GROUP BY courier_id, delivered_orders
HAVING MAX(last_action) - MIN(date) >= 10
ORDER BY days_employed DESC, courier_id