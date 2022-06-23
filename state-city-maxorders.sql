SELECT DATE(a.created_time), b.state,b.city, floor(sum(a.product_payable)) AS sale, COUNT(DISTINCT a.order_uuid) AS total_orders
FROM orders AS a
inner JOIN address AS b
ON a.address_id = b.id
inner JOIN payment AS c
ON a.id = c.order_id
WHERE a.created_time BETWEEN "2022-06-02:12:00:00" AND "2022-06-02:23:59:59"
#WHERE DATE(a.created_time) = "2022-05-21"
AND c.status ='success'
GROUP BY b.state,b.city,DATE(a.created_time)
ORDER BY sale DESC;



SELECT * FROM epharmacy.orders LIMIT 100;
SELECT * FROM epharmacy.address LIMIT 100;
SELECT * FROM epharmacy.payment LIMIT 100;
