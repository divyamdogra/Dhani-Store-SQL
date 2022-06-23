SELECT DATE(a.created_time) AS DATE,COUNT(DISTINCT a.order_uuid) AS total,
COUNT(case when  (a.device_type = 'mobile' OR a.device_type IS NULL) then a.order_uuid end) AS app,
COUNT(case when a.device_type = 'WEB' then a.order_uuid end) AS web
FROM epharmacy.orders a
JOIN epharmacy.payment b
ON a.id=b.order_id
WHERE
DATE(a.created_time) > '2022-05-01'
AND
a.order_type != "free_hb"
#AND b.`status`='success'
GROUP BY DATE(a.created_time)
ORDER BY DATE(a.created_time) DESC;



#New user and repeat user per day
SELECT cc.order_date,cc.total_Cust,bb.new_user,cc.total_Cust - bb.new_user AS repeat_cust FROM
(
SELECT DATE(c.created_time) AS order_date, COUNT(DISTINCT d.mobile) AS total_Cust FROM epharmacy.orders c
JOIN
epharmacy.customer d
ON c.customer_id=d.id
GROUP BY DATE(c.created_time)
ORDER BY DATE(c.created_time) DESC
)cc

JOIN

(
SELECT aa.frst_txn_date, COUNT(DISTINCT aa.mobile) AS new_user FROM
(
SELECT b.mobile, min(date(a.created_time)) AS frst_txn_date FROM epharmacy.orders a
JOIN
epharmacy.customer b
ON a.customer_id=b.id
GROUP BY b.mobile
ORDER BY frst_txn_date DESC
)aa
GROUP BY aa.frst_txn_date
ORDER BY aa.frst_txn_date DESC
)bb
ON
cc.order_date=bb.frst_txn_date;
