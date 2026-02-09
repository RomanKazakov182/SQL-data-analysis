WITH uni_cours AS
(SELECT date
     , COUNT(courier_id) AS new_couriers
FROM
(
SELECT courier_id
     , DATE(MIN(time)) AS date
FROM courier_actions
GROUP BY courier_id
) AS unique_couriers
GROUP BY date
ORDER BY date)
,
uni_usrs AS
(SELECT date
     , COUNT(user_id) AS new_users
FROM
(
SELECT user_id
     , DATE(MIN(time)) AS date
FROM user_actions
GROUP BY user_id
) AS unique_users
GROUP BY date
ORDER BY date)

SELECT date
     , new_users
     , new_couriers
     , SUM(new_users) OVER (ORDER BY date)::INTEGER AS total_users
     , SUM(new_couriers) OVER (ORDER BY date)::INTEGER AS total_couriers
FROM uni_usrs
JOIN uni_cours
USING(date)