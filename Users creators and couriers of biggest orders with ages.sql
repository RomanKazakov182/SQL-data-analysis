SELECT DISTINCT order_id
     , user_id
     , extract(year FROM age((SELECT max(time) FROM user_actions), usrs.birth_date))::integer as user_age
     , courier_id
     , extract(year FROM age((SELECT max(time) FROM user_actions), cours.birth_date))::integer as courier_age
FROM (SELECT order_id
           , user_id
           , birth_date
      FROM user_actions
      JOIN users
      USING(user_id)) as usrs
JOIN (SELECT order_id
           , courier_id
           , birth_date
      FROM courier_actions
      JOIN couriers
      USING(courier_id)) as cours
USING(order_id)
RIGHT JOIN
     (SELECT order_id
      FROM
     (SELECT order_id
           , unnest(product_ids) as product_id
      FROM orders) as ords
      GROUP BY order_id
      ORDER BY count(product_id) desc
      LIMIT 5) as sel_ords 
USING(order_id)

