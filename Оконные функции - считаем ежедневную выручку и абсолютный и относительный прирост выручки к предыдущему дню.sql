WITH revenue_data AS (
    SELECT DATE(creation_time) AS date
         , ROUND(SUM(price), 1) AS daily_revenue
    FROM (
        SELECT creation_time
             , UNNEST(product_ids) AS product_id
        FROM orders
        WHERE order_id NOT IN (
            SELECT order_id 
            FROM user_actions 
            WHERE action = 'cancel_order'
        )
    ) AS ords
    LEFT JOIN products USING (product_id)
    GROUP BY DATE(creation_time)
),
revenue_with_lag AS (
    SELECT date
         , daily_revenue
         , LAG(daily_revenue) OVER (ORDER BY date) AS prev_revenue
    FROM revenue_data
)
SELECT date
     , daily_revenue
     , COALESCE(ROUND(daily_revenue - prev_revenue, 1), 0) AS revenue_growth_abs
     , COALESCE(
         ROUND((daily_revenue - prev_revenue) / prev_revenue * 100, 1),
         0
       ) AS revenue_growth_percentage
FROM revenue_with_lag
ORDER BY date