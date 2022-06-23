SELECT aa.hours,T0_orders,T0_orders/59 AS today_run_rate,T1_orders,T1_orders/59 AS yesterday_run_rate  FROM
(
SELECT HOUR(a.created_time) AS hours,COUNT(a.order_uuid) AS T1_orders FROM epharmacy.orders a
JOIN epharmacy.payment b
ON a.id=b.order_id
WHERE
date(a.created_time) >= DATE(NOW()) - INTERVAL 1 DAY
AND
DATE(a.created_time) < DATE(NOW())
group by hours
ORDER BY hours DESC
)aa
LEFT JOIN
(
SELECT HOUR(a.created_time) AS hours,COUNT(a.order_uuid) AS T0_orders FROM epharmacy.orders a
JOIN epharmacy.payment b
ON a.id=b.order_id
WHERE
a.created_time>= DATE(NOW())
group by hours
ORDER BY hours DESC
)bb
ON aa.hours=bb.hours;


