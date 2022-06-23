7.	KBM Orders

SELECT DATE(a.created_time),
count(DISTINCT (case when (a.device_type = "Mobile" OR a.device_type IS NULL) then a.order_uuid END)) AS "App Orders",
count(DISTINCT (case when a.device_type = "Web" then a.order_uuid END)) AS "Web Orders",

count(DISTINCT (case when (a.device_type = "Mobile" OR a.device_type IS NULL) then a.customer_id END)) AS "App Unique Customers",
count(DISTINCT (case when a.device_type = "Web" then a.customer_id END)) AS "Web Unique Customers",

count(DISTINCT (case when (a.device_type = "Mobile" OR a.device_type IS NULL) AND a.status = "returned" then order_uuid END)) AS "App returned",
count(DISTINCT (case when device_type = "Web" AND a.status = "returned" then order_uuid END)) AS "Web returned"


FROM orders AS a
LEFT JOIN order_items AS b ON a.id = b.order_id
JOIN epharmacy.payment AS c ON b.order_id = c.order_id
WHERE DATE(a.created_time) >= "2022-05-01"
AND c.`status` = 'success'
GROUP BY DATE(a.created_time)
ORDER BY DATE(a.created_time) DESC;


8.	Total deliveries

SELECT DATE(c.delivery_time), COUNT(DISTINCT order_uuid),
count(DISTINCT (case when (a.device_type = "Mobile" OR a.device_type IS NULL) then a.order_uuid END)) AS "App Orders",
count(DISTINCT (case when a.device_type = "Web" then a.order_uuid END)) AS "Web Orders"

FROM orders AS a
LEFT JOIN order_items AS b ON a.id = b.order_id
LEFT JOIN shipments AS c ON a.id = c.order_id
WHERE DATE(c.delivery_time) >= "2022-05-01"
and a.status = "delivered"
GROUP BY DATE(c.delivery_time)
ORDER BY DATE(c.delivery_time) DESC ;


9.	Total Cancellations

SELECT DATE(a.cancellation_time),
count(DISTINCT (case when (a.device_type = "Mobile" OR a.device_type IS NULL) then a.order_uuid END)) AS "App Orders",
count(DISTINCT (case when a.device_type = "Web" then a.order_uuid END)) AS "Web Orders"
FROM orders AS a
LEFT JOIN order_items AS b ON a.id = b.order_id
WHERE DATE(a.cancellation_time) >= "2022-05-01"
GROUP BY DATE(a.cancellation_time)
ORDER BY DATE(a.cancellation_time) DESC ;


10.	App Web orders Revenue

SELECT DATE(a.created_time),
floor(sum((case when (a.device_type = "Mobile" OR a.device_type IS NULL) then a.product_payable END))) AS "App Orders",
floor(sum((case when a.device_type = "Web" then a.product_payable END))) AS "Web Orders"
FROM orders AS a
JOIN epharmacy.payment b
ON a.id=b.order_id
WHERE
b.status = 'success'
AND DATE(a.created_time) >= "2022-05-01"
GROUP BY DATE(a.created_time)
ORDER BY DATE(a.created_time) DESC ; 


11.	Delivery TAT

SELECT DATE(c.delivery_time) AS created_date,
FLOOR(avg(DATEDIFF(c.delivery_time,a.created_time))) AS "Overall TAT",
FLOOR(avg(case when (device_type = "Mobile" OR device_type IS NULL) then DATEDIFF(c.delivery_time,a.created_time) END)) AS "App Delivery TAT",
FLOOR(avg(case when device_type = "Web" then DATEDIFF(c.delivery_time,a.created_time) END)) AS "Web Delivery TAT"
FROM orders AS a
LEFT JOIN shipments AS c ON a.id = c.order_id
WHERE DATE(c.delivery_time) >= "2022-05-01"
GROUP BY created_date
ORDER BY created_date DESC;



12.	Cancellation TAT

SELECT DATE(a.cancellation_time) AS created_date,
FLOOR(avg(DATEDIFF(a.cancellation_time,a.created_time))) AS "Total Cancellation TAT",
FLOOR(avg(case when (device_type = "Mobile" OR device_type IS NULL) then DATEDIFF(a.cancellation_time,a.created_time) END)) AS "App Cancellation TAT",
FLOOR(avg(case when device_type = "Web" then DATEDIFF(a.cancellation_time,a.created_time) END)) AS "Web Cancellation TAT"
FROM orders AS a
LEFT JOIN shipments AS c ON a.id = c.order_id
WHERE DATE(a.cancellation_time) >= "2022-05-01"
GROUP BY created_date
ORDER BY created_date DESC;


13.	Warehouses and Suppliers Quantities

	SELECT DATE(a.created_time) AS created_date,
	sum(case when is_mp_product = 0 then quantity END) AS warehouses_quantity,
	sum(case when is_mp_product = 1 then quantity END) AS Supplier_quantity,
	
	sum(case when is_mp_product = 0 then cancelled_quantity END) AS cancelled_warehouses_quantity,
	sum(case when is_mp_product = 1 then cancelled_quantity END) AS cancelled_Supplier_quantity,
	
	FLOOR( sum(case when is_mp_product = 0 then selling_price END)) AS Warehouse_Revenue,
	FLOOR( sum(case when is_mp_product = 1 then selling_price END)) AS Supplier_Revenue,
	
	
	sum(case when is_mp_product = 0 then returned_quantity END) AS returned_warehouses_quantity,
	sum(case when is_mp_product = 1 then returned_quantity END) AS returned_Supplier_quantity
	
	FROM order_items AS a
	JOIN epharmacy.payment as b
	ON a.order_id=b.order_id
	WHERE DATE(a.created_time) >= "2022-05-01"
	AND
	b.`status` = 'success'
	AND
	a.sap_code <> '10171041873'
	GROUP BY DATE(a.created_time)
	ORDER BY DATE(a.created_time) DESC;



14.	Deliveries based on Quantities


SELECT DATE(c.delivery_time) AS delivery_date,
sum(case when is_mp_product = 0 then delivered_quantity END) AS delivered_warehouses_quantity,
sum(case when is_mp_product = 1 then delivered_quantity END) AS delivered_Supplier_quantity

FROM  order_items AS a
LEFT JOIN shipments AS c ON a.order_id = c.order_id
WHERE DATE(delivery_time) >= "2022-05-01"
GROUP BY delivery_date
ORDER BY delivery_date DESC;


15. DOF Customer -ROW-31 

SELECT COUNT(DISTINCT a.mobile_number),a.time
from analytics_db.store_orders_may a 
inner JOIN udio_wallet.ib_creditline_application b
ON a.mobile_number = b.mobile_number
where b.status = 'onboarded'
GROUP BY a.time;


16 Top Products

SELECT DATE(b.created_time) AS created_date,b.product_id,b.sap_code,b.name,(b.selling_price)#,b.mrp,#p.payment_method,
,count(DISTINCT a.order_uuid) "Total Orders",count(DISTINCT a.customer_id) "Unique Customers", sum(b.quantity) AS quantity
FROM 
orders AS a
LEFT JOIN address AS d ON a.address_id = d.id
left join order_items AS b ON a.id = b.order_id
LEFT JOIN product AS c ON b.product_id = c.id
LEFT JOIN payment AS p ON p.order_id = a.id
WHERE #b.name LIKE ("%hiphop%") AND # OR b.name LIKE ("%HRV Analog%") OR b.name LIKE ("%Green printed georgatte%") OR b.name LIKE ("%Men Black and White Colorblocked%") OR b.name LIKE ("%first front power free hand blander%")) AND 
#b.sap_code IN ("MG-230","PAD-27","BEJOY-HO-42","M54_9") AND
#b.sap_code IN ("ShopsyVNP","FITNESSACC19_3","Shopsy_P01_APPLE_CUTTER","NM-1886","MG-113","PAD-25") AND 
#b.sap_code IN ("SAHIL26","UN_Pyramid_Stand","UnV_Flat_Stand","AMISTSCHAMPBLK01","NM-2207","SKU - 1315060") AND 
#b.selling_price BETWEEN 30 AND 48  and
#b.sap_code IN ("10170491126") AND

b.created_time BETWEEN "2022-05-27:00:00:00" AND "2022-05-27:23:59:59" AND b.sap_code IS NOT NULL AND b.sap_code NOT IN ("10171041873","Plastic")
AND p.STATUS = "success"
GROUP BY DATE(b.created_time),b.product_id,b.sap_code,b.name#,b.selling_price#,p.payment_method
ORDER BY quantity DESC; 


17 Top Cities

SELECT DATE(a.created_time),#a.device_type,
(case when a.device_type = "mobile" OR a.device_type IS NULL then "App" 
ELSE "Web" END) AS device,
b.city,
COUNT(DISTINCT order_uuid) AS orders1
FROM orders AS a
LEFT JOIN address AS b
ON a.address_id = b.id
WHERE DATE(a.created_time) >= "2022-05-20"
GROUP BY DATE(a.created_time),device,b.city
ORDER BY orders1 DESC;



18 New and Repeat Customers--ROW 31,32

SELECT cc.order_date,cc.total_Cust,bb.new_user,cc.total_Cust - bb.new_user AS repeat_cust FROM
(
SELECT DATE(c.created_time) AS order_date, COUNT(DISTINCT d.mobile) AS total_Cust 

FROM epharmacy.orders c
JOIN
epharmacy.customer d
ON c.customer_id=d.id

JOIN 
epharmacy.payment p
ON c.id = p.order_id

WHERE p.status = "success"

GROUP BY DATE(c.created_time)
ORDER BY DATE(c.created_time) DESC

)cc

JOIN

(
SELECT aa.frst_txn_date, COUNT(DISTINCT aa.mobile) AS new_user FROM 
(
SELECT b.mobile,min(date(a.created_time)) AS frst_txn_date FROM epharmacy.orders a
JOIN order_items AS c ON a.id = c.order_id
JOIN epharmacy.customer b
ON a.customer_id=b.id

GROUP BY b.mobile
ORDER BY frst_txn_date DESC
)aa
GROUP BY aa.frst_txn_date
ORDER BY aa.frst_txn_date DESC
)bb
ON
cc.order_date=bb.frst_txn_date;
