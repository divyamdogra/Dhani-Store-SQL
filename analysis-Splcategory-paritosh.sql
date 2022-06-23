Paritosh orders

SELECT date(b.created_time) AS created_date ,b.sap_code,b.is_mp_product,b.name,count(DISTINCT a.order_uuid) "Total Orders", sum(b.quantity) AS quantity
FROM
orders AS a
LEFT JOIN address AS d ON a.address_id = d.id
left join order_items AS b ON a.id = b.order_id
LEFT JOIN product AS c ON b.product_id = c.id
WHERE 
b.sap_code IN ("GVGXBLK48-5","10171048672","AV-2135","SAM Earphones") AND
b.created_time BETWEEN "2022-05-02:00:00:00" AND "2022-05-02:23:59:59" AND b.sap_code IS NOT NULL AND b.sap_code NOT IN (10171041873)
GROUP BY created_date,b.sap_code,b.name
ORDER BY quantity DESC;


#Total orders current time-wise

SELECT 'Orders' AS Head, '#' AS Units,aa.T0-T1 AS yesterday_diff,aa.T0-T7 AS weekly_diff,
T0,T1,T2,T3,T4,T5,T6,T7 from
(SELECT
COUNT(case when  (a.created_time BETWEEN DATE(NOW()) AND NOW()) then a.order_uuid end) AS T0,
COUNT(case when (a.created_time BETWEEN (DATE(NOW())-INTERVAL 1 DAY) AND NOW()-INTERVAL 1 DAY) then a.order_uuid end) AS T1,
COUNT(case when (a.created_time BETWEEN (DATE(NOW())-INTERVAL 2 DAY) AND NOW()-INTERVAL 2 DAY) then a.order_uuid end) AS T2,
COUNT(case when (a.created_time BETWEEN (DATE(NOW())-INTERVAL 3 DAY) AND NOW()-INTERVAL 3 DAY) then a.order_uuid end) AS T3,
COUNT(case when (a.created_time BETWEEN (DATE(NOW())-INTERVAL 4 DAY) AND NOW()-INTERVAL 4 DAY) then a.order_uuid end) AS T4,
COUNT(case when (a.created_time BETWEEN (DATE(NOW())-INTERVAL 5 DAY) AND NOW()-INTERVAL 5 DAY) then a.order_uuid end) AS T5,
COUNT(case when (a.created_time BETWEEN (DATE(NOW())-INTERVAL 6 DAY) AND NOW()-INTERVAL 6 DAY) then a.order_uuid end) AS T6,
COUNT(case when (a.created_time BETWEEN (DATE(NOW())-INTERVAL 7 DAY) AND NOW()-INTERVAL 7 DAY) then a.order_uuid end) AS T7
FROM epharmacy.orders a
#JOIN epharmacy.payment b ON a.id=b.order_id
WHERE
DATE(a.created_time) > DATE(NOW())-INTERVAL 8 DAY
AND
#b.status = 'success' AND   
a.order_type != "free_hb"
)aa; 



SELECT * FROM order_items LIMIT 100;



#to check how many sell at 105 and 143 we simple take b.selling price
SELECT date(b.created_time) AS created_date ,b.selling_price,b.sap_code,b.is_mp_product,b.name,count(DISTINCT a.order_uuid) "Total Orders", sum(b.quantity) AS quantity
FROM
orders AS a
LEFT JOIN address AS d ON a.address_id = d.id
left join order_items AS b ON a.id = b.order_id
LEFT JOIN product AS c ON b.product_id = c.id
WHERE 
b.sap_code IN ("10171045734") AND
b.created_time BETWEEN "2022-05-01:00:00:00" AND "2022-05-01:23:59:59" AND b.sap_code IS NOT NULL AND b.sap_code NOT IN (10171041873)
GROUP BY created_date,b.sap_code,b.name,b.selling_price
ORDER BY quantity DESC;


#analysis of product acc to their SAP code
SELECT date(b.created_time) AS created_date ,b.sap_code,b.is_mp_product,b.name,count(DISTINCT a.order_uuid) "Total Orders", sum(b.quantity) AS quantity
FROM
orders AS a
LEFT JOIN address AS d ON a.address_id = d.id
left join order_items AS b ON a.id = b.order_id
LEFT JOIN product AS c ON b.product_id = c.id
WHERE 
b.sap_code IN ("AV-2008","FSB-1509","AV-2135","ORION3") AND
b.created_time BETWEEN "2022-05-02:00:00:00" AND "2022-05-02:23:59:59" AND b.sap_code IS NOT NULL AND b.sap_code NOT IN (10171041873)
GROUP BY created_date,b.sap_code,b.name
ORDER BY quantity DESC;